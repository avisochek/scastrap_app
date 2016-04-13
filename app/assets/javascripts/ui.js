var monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];

$(document).ready(function(){
  $("#streetsToggle").click(function(e){
    $("#sidebar").addClass("open");
    $("#streets").addClass("open");
    $("#issues").removeClass("open");
  });
  $("#issuesToggle").click(function(e){
    $("#sidebar").addClass("open");
    $("#issues").addClass("open");
    $("#streets").removeClass("open");
  });
  $(".collapse").click(function(e){
    $("#sidebar").removeClass("open");
  });
  // $("#main").click(function(e){
  //   if (e.target.id!="streetsToggle"){
  //   $("issues").removeClass("open");
  //   $("streets").removeClass("open");
  // }
  // }
  $(".aboutLink").click(function(e){
    $("#home").hide();
    $("#aboutPage").show();
  });
  $(".helpLink").click(function(e){
    $("#home").hide();
    $("#helpPage").show();
  });
  $(".feedbackLink").click(function(e){
    $("#home").hide();
    $("#feedbackPage").show();
  });
  $(".back").click(function(e){
    $(".page").hide();
    $("#home").show();
  });
  $(".issueContent").hover(function(e){
    console.log("asdf");
    // $("#issueicon_"+e.target.id).css("color","red");
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
    self.clusters = ko.observable();
    self.streets = ko.observable();
    self.chosenStreetName = ko.observable();
    self.chosenStreetStats = ko.observable();
    self.mapMode = ko.observable("clusterMap");
    self.issues=ko.observable(false);
    self.chosenCluster=ko.observable();
    self.batch=ko.observable();


    //Behaviors
    // order of behaviors reflects
    // the flow of selection in the UI
    self.getRequestTypeMenu =function(){
      $.get('/request_type_menu',
        function(data){
          self.requestTypes(data["requestTypes"]);
      });
    };

    self.getData = function(requestTypeId){
      self.chosenRequestTypeId(requestTypeId);
      // self.location("app");
      initMap();
      clearMap();
      self.issues(false);
      self.mapMode("clusterMap");
      $.get('/clusters/get_clusters/'+requestTypeId,
        function(data){
          self.clusters(data["clusters"]);
          self.batch(data["batch"]);
          // we're using the cluster counts here to determine
          // the max_intensity of the heat map...
          cluster_counts=plotClusterMap(data["clusters"]);
          $.get('/issues/get_issues/'+requestTypeId,
            function(data){
              plotHeatMap(data["issues"],cluster_counts);
          });
      });
      $.get("/streets/ranking/"+requestTypeId,
        function(data){
          self.streets(data["streets"]);
      });
    };

    self.goToCluster=function(cluster){
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
      });
    }

    self.goToStreetPage = function(street){
      console.log(street);
      self.chosenStreetName(street["name"]);
      console.log(street["id_"]);
      $.get("/streets/stats/"+street["id_"],function(data){
        console.log(data)
        self.chosenStreetStats(data["stats"]);
        $("#home").hide();
        $("#streetPage").show();
      });
    };

    //toggle map using global heatmap and overlay
    //variables which are created in the map module
    $("#mapToggle").click(function(e){
      self.mapMode(self.mapMode()=="heatMap" ? "clusterMap":"heatMap");
      $("#mapToggle").toggleClass("heatmap");
      if (heatMap){heatMap.setMap(heatMap.getMap() ? null : map);}
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

    $("#issuesExport").click(function(e){
      title="Scastrap_issues_"
      title+self.chosenRequestTypeName();
      title+="_"+self.batch()["created_at"]+".csv";
      title+="_cluster_id#"+self.chosenCluster()["id_"]+".csv";
      exportIssues(self.issues(),title);
    });

    $("#streetsExport").click(function(e){
      title="Scastrap_street_ranking_";
      title+=self.chosenRequestTypeName();
      title+="_"+self.batch()["created_at"]+".csv";
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
