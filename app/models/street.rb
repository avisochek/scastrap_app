class Street < ActiveRecord::Base
  has_many :issues
  belongs_to :city
  self.primary_key = :id_

  def self.bulk_upsert streets
    self.bulk_street_params(streets)["streets"].each do |street|
      if Street.where(:id_=>street[:id_]).count==0
        Street.create(street).save()
      end
    end
  end

  def self.ranking request_type_id
    ## start by getting the number of issues for each street
    street_counts=Issue.where(
      :status=>["Acknowledged","Open"],
      :request_type_id=>request_type_id
      ).includes(
      :street=>["name","length"])
      .group(:street_id).count()

    ## iterate over streets, getting the probability of each
    ## where the probability is the likelihood that excactly
    ## n events would occur on that street by chance...
    @streets=[]
    ## get the combined length of all streets
    ## in city where issues have been reported
    request_type=RequestType.find(request_type_id)
    t = Street.where(:city_id=>request_type[:city_id]).sum(:length)
    n_issues=Issue.where(
      :status=>["Acknowledged","Open"],
      :request_type_id=>request_type_id
      ).count
    street_counts.each do |street_id,count|
      if street_id != 0 && street_id != nil && street_id != ""
        street=Street.find(street_id)
        probability=StreetsHelper.get_probability street[:length],t,n_issues,count
        @streets.push({
          :length=>street[:length],
          :id_=>street[:id_],
          :name=>street[:name],
          :count=>count,
          :length=>street[:length],
          :issues_per_mile=>count/street[:length],
          :probability=>probability
        })
      end
    end
    ## order and rank streets by their probability score...
    @streets.sort_by! {|street| street[:probability]}
    1.upto(@streets.length).each do |index|
      @streets[index-1][:rank]=index
      @streets[index-1][:percentile]=(1-(index.to_f/@streets.length)).round(2)
    end
    @streets
  end

  def self.stats street_id
    counts=Issue.where(
      :status=>["Acknowledged","Open"],
      :street_id=>street_id
      ).includes(:reques_type).group(:request_type_id).count()
    @stats=[]
    counts.each do |request_type_id,count|
      request_type=RequestType.find(request_type_id)
      @stats.push(
        :name=>request_type[:name],
        :count=>count
      )
    end
    @stats
  end

  private
    def self.bulk_street_params streets
      streets.permit(:streets=>[:id_,
                              :city_id,
                              :name,
                              :length])
    end
end
