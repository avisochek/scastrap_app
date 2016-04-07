class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def home
  end
  def request_type_menu
    requestTypes=RequestType.where.not(:id_=>0).includes(:city).as_json
    @requestTypes=[]
    requestTypes.each do |request_type,ind|
      city_name=City.find(request_type["city_id"])["name"]
      full_name=city_name+" : "+request_type["name"]
      request_type[:full_name]=full_name
      @requestTypes.push(request_type)
    end
    render :json => {:requestTypes=>@requestTypes}
  end
end
