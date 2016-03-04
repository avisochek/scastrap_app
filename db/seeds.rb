# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

cities=[{:id_=>1,:name=>'New Haven, CT',:lng=>-72,:lat=>42}]
cities.each {|city| City.create(city)}

streets=[{:id_=>1,:name=>'Chapel Street',:city_id=>1,:length=>1}]
streets.each {|street| Street.create(street)}

request_types=[{:id_=>1,:name=>'asdf',:city_id=>1}]
request_types.each {|request_type| RequestType.create(request_type)}

batches=[{:id_=>1,:created_at=>'2016-02-23T13:26:28-05:00'}]
batches.each {|batch| Batch.create(batch)}

clusters=[{:id_=>1,:score=>5,:request_type_id=>1,:batch_id=>1,:city_id=>1}]
clusters.each {|cluster| Cluster.create(cluster)}

issues=[
  {
    :id_=>1,
    :request_type_id=> 1,
    :created_at=> "2016-02-23T13:26:28-05:00",
    :status=> "acknowledged",
    :lng=>  -72.8886171,
    :lat=> 41.3151235,
    :street_id => 1,
    :city_id=>1
  },
  {
    :id_=>2,
    :request_type_id=> 1,
    :created_at=> "2016-02-23T13:26:28-05:00",
    :status=> "acknowledged",
    :lng=>  -72.8886171,
    :lat=> 41.315123,
    :street_id => 1,
    :city_id=>1
  },
  {
    :id_=>3,
    :request_type_id=> 1,
    :created_at=> "2016-02-23T13:26:28-05:00",
    :status=> "acknowledged",
    :lng=>  -72.8886171,
    :lat=> 41.315787,
    :street_id => 1,
    :city_id=>1
  },
  {
    :id_=>4,
    :request_type_id=> 1,
    :created_at=> "2016-02-23T13:26:28-05:00",
    :status=> "acknowledged",
    :lng=>  -72.8886171,
    :lat=> 41.314632,
    :street_id => 1,
    :city_id=>1
  },
  {
    :id_=>5,
    :request_type_id=> 1,
    :created_at=> "2016-02-23T13:26:28-05:00",
    :status=> "acknowledged",
    :lng=>  -72.8886171,
    :lat=> 41.315275,
    :street_id => 1,
    :city_id=>1
  }
]

issues.each {|issue| Issue.create(issue)}

clusters_issues=[{:issue_id=>1,:cluster_id=>1},
                   {:issue_id=>2,:cluster_id=>1},
                   {:issue_id=>3,:cluster_id=>1},
                   {:issue_id=>4,:cluster_id=>1},
                   {:issue_id=>5,:cluster_id=>1}]

clusters_issues.each {|cluster_issue| ClustersIssues.create(cluster_issue)}
