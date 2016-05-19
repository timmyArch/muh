class GistsController < ApplicationController

  layout 'material'

  before_action :get_gist, only: [:show, :delete]

  def new
    @languages = CODEMIRROR[:modes]
  end
  def show; end

  private

  def get_gist
    @gist = Gist.find(params[:id])
  end

end
