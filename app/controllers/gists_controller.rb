class GistsController < ApplicationController

  layout 'material'

  def show
    @gist = Gist.find(params[:id])
  end

end
