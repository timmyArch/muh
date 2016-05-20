
class Gist < Base

  def snippets
    SnippetCollection.new(gist: self)
  end

  class SnippetCollection

    include Enumerable
    include ActiveModel::Model

    attr_accessor :gist

    def snippets
      gist.conn.smembers(gist.key).to_a.map do |x|
        Snippet.find(x)
      end
    end

    def create snippet
      gist.conn.sadd(gist.key, snippet.id)
      snippet.save
    end

    def each &block
      snippets.each do |snippet|
        block.call snippet
      end
    end

  end

end
