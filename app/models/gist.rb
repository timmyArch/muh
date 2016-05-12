
class Gist < Base

  attr_accessor :id, :contents

  def self.find id
    id = id.to_s.gsub("gists::", "")
    conn.incr "info::gists_fetched"
    Gist.new(id: "gists::#{id}", contents: conn.smembers("gists::"+id))
  end

  def self.all
    conn.keys("gists::*").map do |k|
      find(k)
    end
  end

  def id
    @id ||= "gists::#{SecureRandom.uuid}"
  end

  def << string
    @contents ||= []
    string = string.to_json unless string.is_a? String
    s = Snippet.new.from_json string
    conn.incr "info::snippets_load"
    @contents << string
    s
  end

  def contents
    @contents.to_a.map do |x|
      Snippet.new.from_json x
    end
  end

  def save!
    conn.incr "info::gists_stored"
    conn.sadd id, @contents.to_a
    self.class.find id
  end

  def locked?
    conn.exists "gists::#{id}::lock"
  end

  def unlocked?
    not locked?
  end

  def lock!
    conn.set "gists::#{id}::lock", "true"
  end

  def unlock!
    conn.del "gists::#{id}::lock"
  end

  class Snippet < Base

    attr_accessor :paste, :mime_type, :lang 

  end

end
