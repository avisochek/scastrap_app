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

request_types=Issue.select("rtt","request_type_id").distinct
request_types.each do |rt|
  RequestType.create(:id_=>rt.request_type_id,
                     :name =>rt.rtt)
end
