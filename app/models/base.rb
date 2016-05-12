
class Base

  include ActiveModel::Model
  include ActiveModel::Serialization
  include ActiveModel::Serializers::JSON

  delegate :conn, to: :class

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

end
