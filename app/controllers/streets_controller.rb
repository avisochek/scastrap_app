class StreetsController < ApplicationController
  def ranking
    @streets=Street.ranking params[:request_type_id]
    render :json => {:streets=>@streets}
  end
  def stats
    @stats = Street.stats params[:street_id]
    render :json => {:stats=>@stats}
  end
end
