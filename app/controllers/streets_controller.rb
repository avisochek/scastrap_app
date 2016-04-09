class StreetsController < ApplicationController
  def factorial(n,k)
    if n<=k
      return k
    else
      return n*factorial(n-1,k)
    end
  end
  def n_choose_k(n,k)
    return factorial(n,k)/factorial(k,1)
  end
  def home
  end
  def ranking
    street_counts=Issue.where(
      :status=>["Acknowledged","Open"],
      :request_type_id=>params[:request_type_id]
      ).includes(
      :street=>["name","length"])
      .group(:street_id).count()
    @streets=[]
    rank=1
    request_type=RequestType.find(params[:request_type_id])
    t = Street.where(:city_id=>request_type[:city_id]).sum(:length)
    n_issues=Issue.where(
      :status=>["Acknowledged","Open"],
      :request_type_id=>params[:request_type_id]
      ).count
    street_counts.each do |street_id,count|
      if street_id != 0 && street_id != nil && street_id != ""
        street=Street.find(street_id)
        probability=((1-(street[:length]/t))**(n_issues-count))
        puts probability
        probability=probability*(street[:length]/t)**count
        puts probability
        puts n_issues
        n_choose_k(n_issues,count)
        @streets.push({
            :name=>street[:name],
            :count=>count,
            :length=>street[:length],
            :issues_per_mile=>count/street[:length],
            :probability=>probability
          })
      end
    end
    @streets.sort_by! {|street| street[:probability]}
    rank=1
    0.upto(@streets.length-1).each do |index|
      @streets[index][:rank]=index
    end
    render :json => {:streets=>@streets}
  end
  def stats
    counts=Issue.where(
      :status=>["Acknowledged","Open"],
      :street_id=>params[:street_id]
      ).includes(:reques_type).group(:request_type_id).count()
    @stats=[]
    counts.each do |request_type_id,count|
      request_type=RequestType.find(request_type_id)
      @stats.push(
        :name=>request_type[:name],
        :count=>count
      )
    end
    render :json => {:stats=>@stats}
  end
end
