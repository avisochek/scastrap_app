//initialize variables, clusterMap and heatMap and issuesMap are the overlays,
//map is the main google maps object, and drag is a parameter
//we use to prevent dragging map from triggering click event
var clusterMap,heatMap,issueMap,map,drag;

function plotMap(clusters,mapMode) {
  //if our overlays are set, set map to null
  //for each so as to create new overlays
  if (heatMap){heatMap.setMap(null);};
  if (clusterMap){clusterMap.setMap(null);};
  if (issueMap){issueMap.setMap(null);};
  var mapOptions = {zoom:13};
  map = new google.maps.Map(document.getElementById('map'), mapOptions);

  clusterMap = new clustersOverlay(map);
  //clusterLabels = new issuesOverlay(map,20);

  //iterate over clusters aggregating the
  //overall cluster and issue data
  var latlngbounds = new google.maps.LatLngBounds();
  var issue_coords= cluster_counts=cluster_centers=cluster_bounds=[];
  clusters.forEach(function(cluster){
    var count=0;
    var cluster_bounds = new google.maps.LatLngBounds();
    clusterColor = "#" + Math.random().toString(16).slice(2, 8);
    cluster["issues"].forEach(function(issue){
      loc = new google.maps.LatLng(issue["lat"],issue["lng"])
      latlngbounds.extend(loc);
      cluster_bounds.extend(loc);
      issue_coords.push(new google.maps.LatLng(issue["lat"],issue["lng"]));
      count+=1;
    });
    clusterCenter=new google.maps.LatLng(
      cluster_bounds.getCenter().lat(),
      cluster_bounds.getCenter().lng())

  // create a cluster icon here in the clusters overlay...
    if(typeof cluster!='undefined'){
      cluster["position"] = clusterCenter;
      cluster["color"] = "black";
      cluster["count"] = count;
      cluster["bounds"] = cluster_bounds;
      clusterMap.addCluster(cluster);
    };
  });
  clusterMap.setMap(null);

  //create a heatmap using the aggregated issue
  //data from previous step
  heatMap = new google.maps.visualization.HeatmapLayer({
    data: issue_coords,
    map: null,
    radius:10,
    opacity:0.95,
    //contstrain the heatmap to the 90th percentile
    maxIntensity:cluster_counts[Math.floor(cluster_counts.sort().length*0.9)-1],
    gradient:['rgba(0, 255, 255, 0)','rgba(0, 255, 255, 1)','rgba(0, 191, 255, 1)','rgba(0, 127, 255, 1)','rgba(0, 63, 255, 1)','rgba(0, 0, 255, 1)','rgba(0, 0, 223, 1)','rgba(0, 0, 191, 1)','rgba(0, 0, 159, 1)','rgba(0, 0, 127, 1)','rgba(63, 0, 91, 1)','rgba(127, 0, 63, 1)','rgba(191, 0, 31, 1)','rgba(255, 0, 0, 1)']
  });

  //determine weather to displar the
  //heatmap or the cluster map first
  map.setCenter(latlngbounds.getCenter());
  if (mapMode=="heatMap"){
    heatMap.setMap(map);
  }else{
    clusterMap.setMap(map);
  };

  //prevent dragging map from triggering a
  //click event
  map.addListener('dragstart',function(){
    drag = true;
  });
  map.addListener('click',function(){
    drag = false;
  });
  map.addListener('mousedown',function(){
    $(".issue").removeClass("selected");
  });
};

function sort(array){
  return array.sort(function(a,b){
    return a<b;
  });
};

function plotIssues(issues,bounds){
  map.fitBounds(bounds)
  if (issueMap){issueMap.setMap(null);};
  issueMap = new issuesOverlay(map);
  issues.forEach(function(issue){
    issue["position"]=new google.maps.LatLng(
      issue["lat"],
      issue["lng"]);
    issue["color"]="#000000";
    issueMap.addIssue(issue);
  });
  issueMap.setMap(map);
}
