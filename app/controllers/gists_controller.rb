class GistsController < ApplicationController

  before_action :get_gist, only: [:show, :delete]

  def new
    @languages = CODEMIRROR[:modes]
  end
  def show; end

  def create

    snippets = params['gist']
    langs = params['lang']

    gist = Gist.new
    snippets.each_with_index do |s,i|
      gist.snippets.create(Snippet.new(paste: s, lang: langs[i]))
    end
    flash[:created] = {title: 'Successfully created gist.', id: gist.id}
    redirect_to "/gists/#{gist.id}"
  end

  private

  def get_gist
    @gist = Gist.find(params[:id])
  end

end
