class GistsController < ApplicationController

  def index
  end

  def new
  end

  def create
    a = Gist.new
    params[:snippets].each do |x|
      a.snippets.create Snippet.new(x)
    end
    redirect_to gists_url(id: a.id)
  end

  def show
    @gist = Gist.find(params[:id])
  end

end
