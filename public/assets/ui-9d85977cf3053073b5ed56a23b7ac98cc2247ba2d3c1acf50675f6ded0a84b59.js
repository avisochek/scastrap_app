//todo: include error message if the thing fails....

var monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];

$(document).ready(function(){
  //guides
  $(document).click(function(e){
    $("#streetsToggle").removeClass("highlited");
    $("#issuesToggle").removeClass("highlited");
  });
  $(".custom-combobox").click(function(e){
    $(".custom-combobox").removeClass("highlited");
  });
  //sidebar
  $("#streetsToggle").click(function(e){
    $("#sidebar").addClass("open");
    $("#main").addClass("open");
    $("#home").addClass("open");
    $("#streets").addClass("open");
    $("#issues").removeClass("open");
    // $("#main").width(($(".container").width()-320)+"px");
  });
  $("#issuesToggle").click(function(e){
    $("#sidebar").addClass("open");
    $("#main").addClass("open");
    $("#home").addClass("open");
    $("#issues").addClass("open");
    $("#streets").removeClass("open");
    // $("#main").width(($(".container").width()-320)+"px");
  });
  $(".collapse").click(function(e){
    $("#sidebar").removeClass("open");
    $("#main").removeClass("open");
    $("#home").removeClass("open");
  });
  // $("#main").click(function(e){
  //   if (e.target.id!="streetsToggle"){
  //   $("issues").removeClass("open");
  //   $("streets").removeClass("open");
  // }
  // }
  $(".aboutLink").click(function(e){
    $("#home").hide();
    $(".page").hide();
    $("#aboutPage").show();
  });
  $(".helpLink").click(function(e){
    $("#home").hide();
    $(".page").hide();
    $("#helpPage").show();
  });
  $(".feedbackLink").click(function(e){
    $("#home").hide();
    $(".page").hide();
    $("#feedbackPage").show();
  });
  $(".back").click(function(e){
    $(".page").hide();
    $("#home").show();
  });
});

var cm;

$(document).ready(function(){
  function ClusterViewModel(){
    var self = this;

    // Observables
    // order of observable declaration reflects
    // the flow of selection in the UI
    self.requestTypes = ko.observable();
    self.chosenRequestTypeName = ko.observable();
    self.chosenRequestTypeId = ko.observable();
    self.clusters = ko.observable(true);
    self.streets = ko.observable(false);
    self.chosenStreetName = ko.observable();
    self.chosenStreetStats = ko.observable();
    self.mapMode = ko.observable("clusterMap");
    self.issues=ko.observable(false);
    self.chosenCluster=ko.observable();
    self.batch=ko.observable();
    self.loading=ko.observable(false);

    self.lastUpdated=ko.computed(function(){
      if (typeof self.batch() !='undefined'){
        // set month, because this doesn't work when it is compiled...
        d.setMonth( d.getMonth( ) + 1 );
        return d.getMonth()+'-'+d.getDate()+'-'+d.getFullYear()
      }else{return false}
    });
    //Behaviors
    self.getRequestTypeMenu =function(){
      self.loading(true);
      $.get('/request_type_menu',
        function(data){
          self.requestTypes(data["requestTypes"]);
          self.loading(false);
      });
    };

    self.getData = function(requestTypeId){
      $("#map").css("background","none");
      self.loading(true);
      self.clusters(true);
      self.chosenRequestTypeId(requestTypeId);
      initMap();
      clearMap();
      self.issues(false);
      self.mapMode("clusterMap");
      $.get("/streets/ranking/"+requestTypeId,
        function(data){
          self.streets(data["streets"]);

          $.get('/clusters/get_clusters/'+requestTypeId,
            function(data){
              self.clusters(data["clusters"]);
              self.batch(data["batch"]);
              if (data["clusters"].length==0){
                self.clusters(false);
                self.loading(false);
              }else{
                // we're using the cluster counts here to determine
                // the max_intensity of the heat map...
                cluster_counts=plotClusterMap(data["clusters"]);
                $.get('/issues/get_issues/'+requestTypeId,
                  function(data){
                    plotHeatMap(data["issues"],cluster_counts);
                    self.loading(false);
                    $("#streetsToggle").addClass("highlited");
                });
              };
          });
      });
    };

    self.goToCluster=function(cluster){
      self.loading(true);
      self.chosenCluster(cluster);
      $.get("/issues/get_cluster/"+cluster["id_"],
        function(data){
          self.issues(data["issues"].map(
            function(issue){
              var date = new Date(issue["created_at"]);
              issue["month"]=monthNames[date.getMonth()];
              issue["year"]=date.getFullYear();
              return issue;
          }));
          plotIssuesMap(data["issues"]);
          self.loading(false);
          $("#issuesToggle").addClass("highlited");
      });
    }

    self.goToStreetPage = function(street){
      self.loading(true);
      self.chosenStreetName(street["name"]);
      $.get("/streets/stats/"+street["id_"],function(data){
        self.chosenStreetStats(data["stats"]);
        $("#home").hide();
        $("#streetPage").show();
        self.loading(false);
      });
    };

    //toggle map using global heatmap and overlay
    //variables which are created in the map module
    $("#mapToggle").click(function(e){
      self.mapMode(self.mapMode()=="heatMap" ? "clusterMap":"heatMap");
      $("#mapToggle").toggleClass("heatmap");
      if (heatMap){heatMap.setMap(heatMap.getMap() ? null : map);}
      if (heatMap){
        if (map.getMapTypeId()=='map_style'){
          map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
        }else{
          map.setMapTypeId('map_style');
        }
      }
      if (clusterMap){clusterMap.setMap(clusterMap.getMap() ? null : map)};
      if (issueMap){issueMap.setMap(issueMap.getMap() ? null : map)};
    });

    self.asdfg=function(requestType){
      console.log("asdfg");
      console.log(requestType);};

    //highlite issue on map when hovering over issue row...
    self.highliteIssue=function(issue){
      console.log("asdf")
      document.getElementById("issueIcon_"+issue["id_"]).style.background="red";
    };
    self.unhighliteIssue=function(issue){
      document.getElementById("issueIcon_"+issue["id_"]).style.background="none";
    };

    $("#issuesFooter").click(function(e){
      title="Scastrap_issues_"
      title+self.chosenRequestTypeName();
      title+="_"+self.lastUpdated()+".csv";
      title+="_cluster_id#"+self.chosenCluster()["id_"]+".csv";
      exportIssues(self.issues(),title);
    });

    $("#streetsFooter").click(function(e){
      title="Scastrap_street_ranking_";
      title+=self.chosenRequestTypeName();
      title+="_"+self.lastUpdated()+".csv";
      exportStreets(self.streets(),title);
    });

    $("#combobox").change(function(e){
      self.chosenRequestTypeName($("option:selected").text());
      self.getData($("#combobox").val());
    });

    self.getRequestTypeMenu();
  }
  cm = new ClusterViewModel();
  ko.applyBindings(cm);
});
