
class Snippet < Base

  attr_accessor :paste, :lang

  def self.find *args
    a = super(*args)
    a.from_json(conn.get a.key)
  end

  def update **kwargs
    a = attributes.reject{|k,v| k == 'id'}
    conn.set key, a.merge(kwargs.stringify_keys).to_json
    self.class.find id
  end

  def save
    conn.set key, ({paste: paste, lang: lang}).to_json
    self.class.find id
  end

end

