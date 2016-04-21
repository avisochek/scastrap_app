//initialize variables, clusterMap and heatMap and issuesMap are the overlays,
//map is the main google maps object, and drag is a parameter
//we use to prevent dragging map from triggering click event
var clusterMap,heatMap,issueMap,map,drag;

function initMap(){
  // set map styles for heatmap view
  var styles=[
    {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "blue"
            },
            {
                "lightness": 17
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#f5f5f5"
            },
            {
                "lightness": 20
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#888888"
            },
            {
                "lightness": 17
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#ffffff"
            },
            {
                "lightness": 29
            },
            {
                "weight": 0.2
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#888888"
            },
            {
                "lightness": 18
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#888888"
            },
            {
                "lightness": 16
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#ffffff"
            },
            {
                "lightness": 21
            }
        ]
    },
    {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#dedede"
            },
            {
                "lightness": 21
            }
        ]
    },
    {
        "elementType": "labels.text.stroke",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "color": "#ffffff"
            },
            {
                "lightness": 0
            }
        ]
    },
    {
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 0
            }
        ]
    },
    {
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#f2f2f2"
            },
            {
                "lightness": 19
            }
        ]
    },
    {
        "featureType": "administrative",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#fefefe"
            },
            {
                "lightness": 20
            }
        ]
    },
    {
        "featureType": "administrative",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#fefefe"
            },
            {
                "lightness": 17
            },
            {
                "weight": 1.2
            }
        ]
    }
]
var styledMap = new google.maps.StyledMapType(styles,
  {name: "Styled Map"});

  var mapOptions = {
    mapTypeControl:false,
    zoom:13,
    mapTypeControlOptions: {
      mapTypeIds: [google.maps.MapTypeId.ROADMAP, 'map_style']
    }
  };
  map = new google.maps.Map(
    document.getElementById('map'),
    mapOptions
  );
  map.mapTypes.set('map_style', styledMap);

  //reset the map when things move
  $(window).on('resize orientationChange',function(event) {
    google.maps.event.trigger(map, 'resize');
  });
  $("#map").on('resize orientationChange',function(event) {
    google.maps.event.trigger(map, 'resize');
  });
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
    opacity:0.75,
    //contstrain the heatmap to the 90th percentile
    maxIntensity:cluster_counts[Math.floor(cluster_counts.sort().length*0.9)-1],
    gradient:['rgba(255,255,255,0)','#5EEDF0','#56F2C8','#4DF395','#45F55C','#5BF63C','#8FF833','#C8F92A','#FAEC21','#FCA917','#FD5F0E']
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
  // console.log(latlngbounds.getCenter().lng());
  map.setCenter(new google.maps.LatLng(
    latlngbounds.getCenter().lat(),
    latlngbounds.getCenter().lng()));
  return cluster_counts
};

  function plotIssuesMap(issues){
    // console.log("plotting...");
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
