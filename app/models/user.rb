require 'bcrypt'
require 'securerandom'
require 'base64'

BCrypt::Engine.cost = 4

class User < Base

  attr_accessor :uuid, :username, :password, :password_digest 

  def self.create(username: nil, password: nil)
    p = BCrypt::Password.create(password)
    raw_username = username
    uuid = SecureRandom.uuid
    username = Base64.encode64(username)
    fail 'Username already exists.' if conn.exists("user::name::#{username}")
    conn.multi do |x|
      x.incr("info::users_created")
      x.set("user::name::#{username}", uuid)
      x.set("user::id::#{uuid}", raw_username)
      x.set("user::pass::#{username}", p)
    end
    new(username: raw_username, password: password, 
        password_digest: p, uuid: uuid)
  end
 
  def self.find_by(username: nil, uuid: nil)
    conn.incr("info::users_fetched")
    if username
      raw_username = username
      username = Base64.encode64(username)
      if pd = conn.get("user::pass::#{username}")
        new(username: raw_username, password_digest: BCrypt::Password.new(pd))
      end
    elsif uuid
      if username = conn.get("user::id::#{uuid}")
        new(username: username, uuid: uuid) 
      end
    end
  end

  def destroy
    conn.incr("info::users_deleted")
    conn.del("user::name::#{encoded_username}", 
             "user::pass::#{encoded_username}", 
             "user::id::#{self.uuid}")
  end

  def uuid
    @uuid ||= conn.get("user::name::#{encoded_username}")
  end

  def username
    @username ||= conn.get("user::id::#{uuid}")
  end

  def password_digest
    @password_digest ||= BCrypt::Password.new(
      conn.get("user::pass::#{encoded_username}")
    )
  end

  def encoded_username
    @encoded_username ||= Base64.encode64(username)
  end

  def reset_id!
    new_id = SecureRandom.uuid
    conn.multi do |x|
      x.set("user::name::#{encoded_username}", new_id)
      x.set("user::id::#{new_id}", username)
      x.del("user::id::#{self.uuid}")
    end
    self.class.find_by(uuid: new_id) 
  end

  def self.authorize!(username: nil, password: nil)
    if u = find_by(username: username)
      u if u.password_digest == password
    end
  end

end
