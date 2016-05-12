class GistsController < ApplicationController

  def show
    @gist = Gist.find(params[:id])
  end

end
