var map;
var issue_markers =[];
var cluster_markers =[];
var latlngbounds;

function newMap(city_coords){
  // Create a map object and specify the DOM element for display.
  map = new google.maps.Map(document.getElementById('map'), {
    center: city_coords,
    scrollwheel: false,
    zoom:8
  });
};

function plotMap(clusters){
  //create map, set the maptype controll to false because its ugly...
  map = new google.maps.Map(document.getElementById('map'),{
    mapTypeControl:false
  });
  // create new latlngbounds object
  // which we will use to center and focus the map
  latlngbounds = new google.maps.LatLngBounds();
  issue_markers.forEach(function(marker){marker.setMap(null);});
  cluster_markers.forEach(function(marker){marker.setMap(null);});
  issue_markers=[];
  cluster_markers=[];
  //iterate over issues populating the map and the bounds
  clusters.forEach(function(cluster){
    var clusterBounds= new google.maps.LatLngBounds();
    issues=cluster["issues"]
    issues.forEach(function(issue){
      var loc = new google.maps.LatLng(issue.lat,issue.lng);
      latlngbounds.extend(loc);
      clusterBounds.extend(loc);
      issue_markers.push(
        new google.maps.Marker({
          sName:issue["id_"],
          position: loc,
          map: map,
          icon: {
            path: google.maps.SymbolPath.CIRCLE,
            fillOpacity: 0.1,
            fillColor: "blue",
            strokeWeight: 0,
            scale: 10 //pixels
          }
        })
      );
    });
    clusterLoc=new google.maps.LatLng(
      clusterBounds.getCenter().lat(),
      clusterBounds.getCenter().lng()
    );
    /// create cluster marker using the google
    /// markerwithlabel.js file, since API does not
    /// currently support labels with multiple characters
    var clusterMarker=new MarkerWithLabel({
      sName:clusters["id_"],
      zIndex:10000,
      visible:false,
      position: clusterLoc,
      map: map,
      labelContent: String(cluster.issues.length),
      labelAnchor: new google.maps.Point(15,15),
      labelClass: "labels", // the CSS class for the label
      labelStyle: {opacity: 1},
      labelInBackground:false,
      icon: {
        path: google.maps.SymbolPath.CIRCLE,
        fillOpacity: 0.5,
        fillColor: "black",
        strokeWeight: 2,
        scale: 20 //pixels
      },
    })
    clusterMarker.addListener('click', function(){focusCluster(cluster);})
    cluster_markers.push(clusterMarker);
  });
  //map.setCenter(latlngbounds.getCenter());
  map.fitBounds(latlngbounds);
};

function goToHeatMapView(){
  issue_markers.forEach(function(marker){
    marker.setIcon({
      path: google.maps.SymbolPath.CIRCLE,
      fillOpacity: 0.1,
      fillColor: "blue",
      scale: 10,
      strokeWeight:0
    });
  });

  cluster_markers.forEach(function(marker){
    marker.setVisible(false);
  });

  map.fitBounds(latlngbounds);
}

function goToClusterView(clusters){

  issue_ids = issue_markers.map(function(marker){
    return marker.sName;
  });

  clusters.forEach(function(cluster){
    clusterColor = "#" + Math.random().toString(16).slice(2, 8);
    cluster["issues"].forEach(function(issue){
      var marker_ind = issue_ids.indexOf(issue["id_"]);
      issue_markers[marker_ind].setIcon({
        path: google.maps.SymbolPath.CIRCLE,
        fillOpacity: 1.0,
        fillColor:clusterColor,
        strokeWeight:0,
        scale:10
      });
    });
  });
  cluster_markers.forEach(function(marker){
    marker.setVisible(true);
  })
  map.fitBounds(latlngbounds);
};

function focusCluster(cluster){
  var clusterBounds= new google.maps.LatLngBounds();
  cluster.issues.forEach(function(issue){
    var loc = new google.maps.LatLng(issue.lat,issue.lng);
    clusterBounds.extend(loc);
  });
  map.fitBounds(clusterBounds);
};
