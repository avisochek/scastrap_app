//initialize variables, clusterMap and heatMap and issuesMap are the overlays,
//map is the main google maps object, and drag is a parameter
//we use to prevent dragging map from triggering click event
var clusterMap,heatMap,issueMap,map,drag;

function initMap(){
  var mapOptions = {zoom:13};
  map = new google.maps.Map(
    document.getElementById('map'),
    mapOptions
  );

  // //prevent dragging map from triggering a
  // //click event
  // map.addListener('dragstart',function(){
  //   drag = true;
  // });
  // map.addListener('click',function(){
  //   drag = false;
  // });
  // map.addListener('mousedown',function(){
  //   $(".issue").removeClass("selected");
  // });
};
function clearMap(){
  if (heatMap){heatMap.setMap(null);};
  if (clusterMap){clusterMap.setMap(null);};
  if (issueMap){issueMap.setMap(null);};
};

function plotHeatMap(issues,cluster_counts){
  //create a heatmap using the aggregated issue
  //data provided
  issue_coords=issues.map(function(issue){
    return new google.maps.LatLng(issue[1],issue[0]);
  });
  heatMap = new google.maps.visualization.HeatmapLayer({
    data: issue_coords,
    map: null,
    radius:10,
    opacity:0.95,
    //contstrain the heatmap to the 90th percentile
    maxIntensity:cluster_counts[Math.floor(cluster_counts.sort().length*0.9)-1],
    gradient:['rgba(0, 255, 255, 0)','rgba(0, 255, 255, 1)','rgba(0, 191, 255, 1)','rgba(0, 127, 255, 1)','rgba(0, 63, 255, 1)','rgba(0, 0, 255, 1)','rgba(0, 0, 223, 1)','rgba(0, 0, 191, 1)','rgba(0, 0, 159, 1)','rgba(0, 0, 127, 1)','rgba(63, 0, 91, 1)','rgba(127, 0, 63, 1)','rgba(191, 0, 31, 1)','rgba(255, 0, 0, 1)']
  });
  // map.setCenter(latlngbounds.getCenter());
};

function plotClusterMap(clusters) {
  clusterMap = new clustersOverlay(map);
  var latlngbounds = new google.maps.LatLngBounds()
  var cluster_counts=[];
  clusters.forEach(function(cluster){
  // create a cluster icon here in the clusters overlay...
    if(typeof cluster!='undefined'){
      var loc=new google.maps.LatLng(cluster["lat"],cluster["lng"]);
      latlngbounds.extend(loc);
      cluster["position"] = loc;
      cluster["color"] = "black";
      cluster["count"] = cluster["score"];
      clusterMap.addCluster(cluster);
    };
    cluster_counts.push(cluster["count"]);
  });
  clusterMap.setMap(map);
  console.log(latlngbounds.getCenter().lng());
  map.setCenter(new google.maps.LatLng(
    latlngbounds.getCenter().lat(),
    latlngbounds.getCenter().lng()));
  return cluster_counts
};

  function plotIssuesMap(issues){
    console.log("plotting...");
    if (issueMap){issueMap.setMap(null);};
    // map.fitBounds(bounds)
    //
    issueMap = new issuesOverlay(map);
    var latlngbounds=new google.maps.LatLngBounds;
    issues.forEach(function(issue){
      var loc = new google.maps.LatLng(issue["lat"],issue["lng"]);
      issue["position"]=loc;
      issue["color"]="#000000";
      issueMap.addIssue(issue);
      latlngbounds.extend(loc);
    });
    issueMap.setMap(map);
    map.fitBounds(latlngbounds);
  }
  //determine weather to displar the
  //heatmap or the cluster map first



function sort(array){
  return array.sort(function(a,b){
    return a<b;
  });
};
