issuesOverlay.prototype = new google.maps.OverlayView();

function issuesOverlay(map) {
  this._map = map;
  this._issues = [];
  //this._radius = 6;
  this._container = document.createElement("div");
  this._container.id = "issueslayer";
  this.addIssue = function (issue) {
    this._issues.push(issue);
  };
}


issuesOverlay.prototype.createIssueIcon = function (issue) {

  var issueIcon = document.createElement('canvas');
  issueIcon.id = 'issueIcon_' + issue["id_"];
  this._radius = 8;
  issueIcon.width = issueIcon.height =  this._radius * 2;
  issueIcon.style.width = issueIcon.width + 'px';
  issueIcon.style.height = issueIcon.height + 'px';
  issueIcon.style.left = (issue["xy"].x - this._radius) + 'px';
  issueIcon.style.top = (issue["xy"].y - this._radius) + 'px';
  issueIcon.style.position = "absolute";
  issueIcon.style.borderRadius = this._radius+"px";

  var centerX = issueIcon.width / 2;
  var centerY = issueIcon.height / 2;
  var ctx = issueIcon.getContext('2d');
  ctx.globalCompositeOperation = 'destination-over';
  ctx.globalAlpha=0.8;
  ctx.fillColor=issue["color"]
  ctx.beginPath();
  ctx.arc(centerX, centerY, this._radius, 0, Math.PI * 2, true);
  ctx.fill()
  google.maps.event.addDomListener(issueIcon, 'mouseover', function() {
    $(issueIcon).css("cursor","pointer");
  });

  google.maps.event.addDomListener(issueIcon, 'click', function() {
    if(!drag){
      $("#streets").removeClass("open");
      $("#sidebar").addClass("open");
      $("#issues").addClass("open");
      $("#home").addClass("open");
      $("#main").addClass("open");
      $(".issueRow").removeClass("selected");
      $issue = $("#"+issue["id_"]);
      $issue.addClass("selected");
      $issue.after($(".issueRow"));
      $(".sidebarContent").scrollTop(0);
    };
    drag=false;
  });

  return issueIcon;
};


issuesOverlay.prototype.ensureIssueIcon = function (issue){
  var issueIcon = document.getElementById("issueIcon_" + issue["id_"]);
  if(issueIcon){
    issueIcon.style.left = (issue["xy"].x - 8) + 'px';
    issueIcon.style.top = (issue["xy"].y - 8) + 'px';
    return issueIcon;
  }
  return this.createIssueIcon(issue);
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
    issue["xy"] = overlayProjection.fromLatLngToDivPixel(issue["position"]);
    var issueIcon = issueMap.ensureIssueIcon(issue);
    container.appendChild(issueIcon);
  });
};

issuesOverlay.prototype.onRemove = function () {
  this._container.parentNode.removeChild(this._container);
};
