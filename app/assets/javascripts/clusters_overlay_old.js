var overlay;
////////////////
////////////////
////////////////
//Clusters Overlay

clustersOverlay.prototype = new google.maps.OverlayView();

function clustersOverlay(map) {
    this._map = map;
    this._clusters = [];
    //this._radius = 6;
    this._container = document.createElement("div");
    this._container.id = "clusterslayer";
    this.addCluster = function (cluster) {
        this._clusters.push(cluster);
    };
}


clustersOverlay.prototype.createClusterIcon = function (cluster) {
  var clusterIcon = document.createElement('div');
  clusterIcon.id = 'clustericon_' + cluster["id_"];
  //calculate radius based on issues count
  this._radius=10*Math.pow(cluster["count"],1/3);
  // this._radius=20
  clusterIcon.width = clusterIcon.height =  this._radius * 2;
  clusterIcon.style.width = clusterIcon.width + 'px';
  clusterIcon.style.height = clusterIcon.height + 'px';
  clusterIcon.style.left = (cluster["xy"].x - this._radius) + 'px';
  clusterIcon.style.top = (cluster["xy"].y - this._radius) + 'px';
  clusterIcon.style.position = "absolute";
  clusterIcon.style.borderRadius = this._radius+"px";
  clusterIcon.style.backgroundColor = "grey";
  clusterIcon.style.opacity = 0.7;
  var centerX = clusterIcon.width / 2;
  var centerY = clusterIcon.height / 2;
  var textHeight=25;
  var margin = this._radius-(textHeight/2);
  style="style='padding:0;margin-bottom:0;margin-top:"+margin+"px;'"
  $(clusterIcon).append("<h1 "+style+">"+cluster["count"]+"</h1>");
  // var ctx = clusterIcon.getContext('2d');
  // var textHeight=20;
  // ctx.font = textHeight+"px Georgia";
  // textWidth = ctx.measureText(String(cluster["count"])).width;
  // ctx.fillStyle = cluster["color"];
  // ctx.fillText(
  //   String(cluster["count"]),
  //   (clusterIcon.width/2)-(textWidth/2),
  //   (clusterIcon.height/2)+(textHeight/3));
  // //ctx.globalCompositeOperation = 'destination-over';
  // ctx.globalAlpha=0.3
  // ctx.beginPath();
  // ctx.arc(centerX, centerY, this._radius, 0, Math.PI * 2, true);
  // ctx.fill();

  google.maps.event.addDomListener(clusterIcon, 'mouseover', function() {
    $(clusterIcon).css("cursor","pointer");
  });

  google.maps.event.addDomListener(clusterIcon, 'click', function() {
    if(!drag){
      cm.goToCluster(cluster);
    }
    drag=false;
  });

  return clusterIcon;
};

clustersOverlay.prototype.ensureIssueIcon = function (cluster) {
  var clusterIcon = document.getElementById("clustericon_" + cluster["id_"]);
  if(clusterIcon){
    clusterIcon.style.left = (cluster["xy"].x - clusterIcon.width/2) + 'px';
    clusterIcon.style.top = (cluster["xy"].y - clusterIcon.height/2) + 'px';
    return clusterIcon;
  }
  return this.createClusterIcon(cluster);
};

clustersOverlay.prototype.onAdd = function () {
  var panes = this.getPanes();
  panes.overlayMouseTarget.appendChild(this._container);
};

clustersOverlay.prototype.draw = function () {
  var zoom = this._map.getZoom();
  var overlayProjection = this.getProjection();

  var container = this._container;
  this._clusters.forEach(function(cluster,idx){
    cluster["xy"] = overlayProjection.fromLatLngToDivPixel(cluster.position);
    var clusterIcon = clusterMap.ensureIssueIcon(cluster);
    container.appendChild(clusterIcon);
  });
};

clustersOverlay.prototype.onRemove = function () {
    this._container.parentNode.removeChild(this._container);
};
