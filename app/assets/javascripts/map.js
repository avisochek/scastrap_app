var overlay;
issuesOverlay.prototype = new google.maps.OverlayView();

function issuesOverlay(map) {
    this._map = map;
    this._issues = [];
    this._radius = 6;
    this._container = document.createElement("div");
    this._container.id = "issueslayer";
    this.addIssue = function (issue,clusterColor,type,count,bounds,issues) {
        this._issues.push({
          position: new google.maps.LatLng(issue["lat"],issue["lng"]),
          fillColor:clusterColor,
          type:type,
          count:count,
          bounds:bounds,
          data:issues
        });
    };
}


issuesOverlay.prototype.createIssueIcon = function (color,type,count,bounds,id,pos,data) {

    var issueIcon = document.createElement('canvas');
    issueIcon.id = 'issueicon_' + id;
    //calculate radius based on poulation
    if (type=="label"){this._radius=20;}
    else{this._radius = 10;};
    issueIcon.width = issueIcon.height =  this._radius * 2;
    issueIcon.style.width = issueIcon.width + 'px';
    issueIcon.style.height = issueIcon.height + 'px';
    issueIcon.style.left = (pos.x - this._radius) + 'px';
    issueIcon.style.top = (pos.y - this._radius) + 'px';
    issueIcon.style.position = "absolute";
    issueIcon.style.borderRadius = 5;
    //issueIcon.style.opacity=0;
    //issueIcon.fillStyle = color;

    var centerX = issueIcon.width / 2;
    var centerY = issueIcon.height / 2;
    var ctx = issueIcon.getContext('2d');
    if (type=="label"){
      var textHeight=30;
      ctx.font = textHeight+"px Georgia";

      textWidth = ctx.measureText(String(count)).width;
      ctx.fillStyle = "#000000";
      //console.log(textHeight);
      ctx.fillText(
        String(count),
        (issueIcon.width/2)-(textWidth/2),
        (issueIcon.height/2)+(textHeight/3));
      //ctx.textBaseline="center"
      ctx.globalCompositeOperation = 'destination-over';
      ctx.globalAlpha=0.5
      ctx.beginPath();
      ctx.arc(centerX, centerY, this._radius, 0, Math.PI * 2, true);
      google.maps.event.addDomListener(issueIcon, 'mouseover', function() {
          //google.maps.event.trigger(me, 'click');
          $(issueIcon).css("cursor","pointer");
      });

      google.maps.event.addDomListener(issueIcon, 'click', function() {
          //google.maps.event.trigger(me, 'click');
          if(!drag){
            map.fitBounds(bounds);
            cm.issues(data["issues"]);
            cm.chosenCluster(data);
          }
          drag=false;
      });

    ctx.fill()
      // ctx.globalAlpha = 0.4;
    }else{
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.arc(centerX, centerY, this._radius, 0, Math.PI * 2, true);
    ctx.fill();}

    return issueIcon;
};


issuesOverlay.prototype.ensureIssueIcon = function (color,type,count,bounds,id,pos,data) {
    var issueIcon = document.getElementById("issueicon_" + id);
    if(issueIcon){
      if (type=="label"){
        issueIcon.style.left = (pos.x - 20) + 'px';
        issueIcon.style.top = (pos.y - 20) + 'px';
      }else{
        issueIcon.style.left = (pos.x - 10) + 'px';
        issueIcon.style.top = (pos.y - 10) + 'px';
      }
        return issueIcon;
    }
    return this.createIssueIcon(color,type,count,bounds,id,pos,data);
};



issuesOverlay.prototype.onAdd = function () {
    var panes = this.getPanes();
    panes.overlayMouseTarget.appendChild(this._container);

};



issuesOverlay.prototype.draw = function () {
    var zoom = this._map.getZoom();
    var overlayProjection = this.getProjection();

    var container = this._container;
    this._issues.forEach(function(issue,idx){
        var xy = overlayProjection.fromLatLngToDivPixel(issue.position);
        var issueIcon = clusterMap.ensureIssueIcon(issue.fillColor,issue.type,issue.count,issue.bounds,idx,xy,issue.data);
        container.appendChild(issueIcon);

    // // Add a listener - we'll accept clicks anywhere on this div, but you may want
    // // to validate the click i.e. verify it occurred in some portion of your overlay.
    //
    });

};

issuesOverlay.prototype.onRemove = function () {
    this._container.parentNode.removeChild(this._container);
    //this._container = null;
};



function getRandomInterval(min, max) {
    return Math.random() * (max - min) + min;
}


<!-- function for manipulating map -->
var clusterMap;
var heatMap;
var map;
var drag;

function plotMap(clusters,mapMode) {
  if (heatMap){
    heatMap.setMap(null);
    clusterMap.setMap(null);
  }
  var mapOptions = {zoom:13};
  map = new google.maps.Map(document.getElementById('map'), mapOptions);

  clusterMap = new issuesOverlay(map,6);
  clusterLabels = new issuesOverlay(map,20);

  var latlngbounds = new google.maps.LatLngBounds();
  var issue_coords=[];
  var cluster_counts=[];
  var cluster_centers=[];
  var cluster_bounds=[];
  clusters.forEach(function(cluster){
    var count=0;
    var clusterbounds = new google.maps.LatLngBounds();
    clusterColor = "#" + Math.random().toString(16).slice(2, 8);
    cluster["issues"].forEach(function(issue){
      loc = new google.maps.LatLng(issue["lat"],issue["lng"])
      latlngbounds.extend(loc);
      clusterbounds.extend(loc);
      clusterMap.addIssue(issue,clusterColor,"issue");
      issue_coords.push(new google.maps.LatLng(issue["lat"],issue["lng"]));
      count+=1;
    });
    clusterCenter={"lng":clusterbounds.getCenter().lng(),"lat":clusterbounds.getCenter().lat()}
    cluster_counts.push(count);
    cluster_centers.push(clusterCenter);
    cluster_bounds.push(clusterbounds);
  });
  for (var i =0;i<cluster_counts.length;i++){
    clusterMap.addIssue(cluster_centers[i],"#000000","label",cluster_counts[i],cluster_bounds[i],clusters[i]);
  }
  clusterMap.setMap(null);
  heatMap = new google.maps.visualization.HeatmapLayer({
    data: issue_coords,
    map: null,
    radius:10,
    opacity:0.95,
    //return 90th percentile
    maxIntensity:cluster_counts[Math.floor(cluster_counts.sort().length*0.9)-1],
    gradient:['rgba(0, 255, 255, 0)','rgba(0, 255, 255, 1)','rgba(0, 191, 255, 1)','rgba(0, 127, 255, 1)','rgba(0, 63, 255, 1)','rgba(0, 0, 255, 1)','rgba(0, 0, 223, 1)','rgba(0, 0, 191, 1)','rgba(0, 0, 159, 1)','rgba(0, 0, 127, 1)','rgba(63, 0, 91, 1)','rgba(127, 0, 63, 1)','rgba(191, 0, 31, 1)','rgba(255, 0, 0, 1)']
  });

  map.setCenter(latlngbounds.getCenter());
  if (mapMode=="heatMap"){
    heatMap.setMap(map);
  }else{
    clusterMap.setMap(map);
  };
  map.addListener('dragstart',function(){
    drag = true;
  });
  map.addListener('click',function(){
    drag = false;
  });
  // map.addListener('dragend',function(){
  //   drag=false;
  // });
};
//google.maps.event.addDomListener(window, 'load', initialize);

function sort(array){
  return array.sort(function(a,b){
    return a<b;
  });
};
