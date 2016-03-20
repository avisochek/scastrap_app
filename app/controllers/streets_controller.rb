class StreetsController < ApplicationController
  def home
  end
  def ranking
    street_counts=Issue.where(:status=>["Acknowledged","Open"],:request_type_id=>params[:request_type_id]).includes(:street=>["name","length"]).group(:street_id).count()
    @streets=[]
    street_counts.each do |street_id,count|
      if street_id != 0
        puts street_id
        street=Street.find(street_id)
        @streets.push({
            :name=>street[:name],
            :count=>count,
            :length=>street[:length],
            :issues_per_mile=>count/street[:length],
            :confidence=>1-1/(count**(0.5))
          })
      end
    end
    @streets.sort_by! {|street| -street[:issues_per_mile]}
    puts @streets
    render :json => {:streets=>@streets}
  end
end
