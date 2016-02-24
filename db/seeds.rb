# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# require 'csv'
#
# CSV.foreach('data/nh_cluster_data.csv') do |id_,rtt,rtid,score|
#   Cluster.create(:id_=>id_,
#                  :rtid=>rtid,
#                  :rtt=>rtt,
#                  :score=>score)
# end
#
# CSV.foreach('data/nh_issues_data.csv') do |row|
#   Issue.create(:status=>row[0],
#                :neighborhood=>row[1],
#                :street_name=>row[2],
#                :rtid=>row[3],
#                :rtt=>row[4],
#                :address=>row[5],
#                :lat=>row[6],
#                :lng=>row[7],
#                :id_=>row[8],
#                :created_at=>row[9],
#                :acknowledged=>row[10],
#                :acknowledged_at=>row[12],
#                :closed_at=>row[13],
#                :cluster_id=>row[14])
# end

# request_types=Issue.select("rtt","request_type_id").distinct
# request_types.each do |rt|
#   RequestType.create(:id_=>rt.request_type_id,
#                      :name =>rt.rtt)
# end


request_types=[{:id_=>1,:name=>'asdf'}]
request_types.each {|request_type| RequestType.create(request_type)}

batches=[{:id_=>1,:created_at=>'2016-02-23T13:26:28-05:00'}]
batches.each {|batch| Batch.create(batch)}

clusters=[{:id_=>1,:score=>5,:request_type_id=>1,:batch_id=>1}]
clusters.each {|cluster| Cluster.create(cluster)}

issues=[
  {
    :id_=>1,
    :request_type_id=> 1,
    :created_at=> "2016-02-23T13:26:28-05:00",
    :status=> "acknowledged",
    :lng=> 52.1994138,
    :lat=> -105.1363869,
    :street_name => "Chapel Street"
  },
  {
    :id_=>2,
    :request_type_id=> 1,
    :created_at=> "2016-02-23T13:26:28-05:00",
    :status=> "acknowledged",
    :lng=> 52.1994138,
    :lat=> -105.1363869,
    :street_name => "Chapel Street"
  },
  {
    :id_=>3,
    :request_type_id=> 1,
    :created_at=> "2016-02-23T13:26:28-05:00",
    :status=> "acknowledged",
    :lng=> 52.1994138,
    :lat=> -105.1363869,
    :street_name => "Chapel Street"
  },
  {
    :id_=>4,
    :request_type_id=> 1,
    :created_at=> "2016-02-23T13:26:28-05:00",
    :status=> "acknowledged",
    :lng=> 52.1994138,
    :lat=> -105.1363869,
    :street_name => "Chapel Street"
  },
  {
    :id_=>5,
    :request_type_id=> 1,
    :created_at=> "2016-02-23T13:26:28-05:00",
    :status=> "acknowledged",
    :lng=> 52.1994138,
    :lat=> -105.1363869,
    :street_name => "Chapel Street"
  }
]

issues.each {|issue| Issue.create(issue)}

clusters_issues=[{:issue_id=>1,:cluster_id=>1},
                   {:issue_id=>2,:cluster_id=>1},
                   {:issue_id=>3,:cluster_id=>1},
                   {:issue_id=>4,:cluster_id=>1},
                   {:issue_id=>5,:cluster_id=>1}]

clusters_issues.each {|cluster_issue| ClustersIssues.create(cluster_issue)}
