
class Base

  include ActiveModel::Model
  include ActiveModel::Serialization
  include ActiveModel::Serializers::JSON

  delegate :conn, to: :class

  attr_accessor :id

  def self.conn
    @redis ||= Redis.new
  end

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def attributes
    instance_values
  end

  def delete
    conn.del key
  end

  def expire_in seconds
    conn.expire id, seconds
  end

  def key
    "#{self.class.key}::#{id}"
  end

  def self.find id
    conn.incr "info::#{key}_fetched"
    new(id: id)
  end

  def self.all
    conn.keys("#{key}::*").map do |k|
      find(k.split("::").last)
    end
  end

  def self.key
    self.name.to_s.tableize
  end

  def id
    @id ||= SecureRandom.uuid
  end

end
