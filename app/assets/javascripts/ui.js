$(document).ready(function(){
  $("#streetsToggle").click(function(e){
    $("#streets").toggleClass("open");
    $("#issues").removeClass("open");
  });
  $("#issuesToggle").click(function(e){
    $("#issues").toggleClass("open");
    $("#streets").removeClass("open");
  });
  // $("#main").click(function(e){
  //   if (e.target.id!="streetsToggle"){
  //   $("issues").removeClass("open");
  //   $("streets").removeClass("open");
  // }
  // }
  $(".aboutLink").click(function(e){
    $("#aboutPage").show();
  });
  $(".helpLink").click(function(e){
    $("#helpPage").show();
  });
  $(".back").click(function(e){
    $(".page").hide();
  });
});

  // set the data and callback
  //function for the autocomplete input
  function setInput(data,callBack){
    var input_data=data.map(
      function(item){
        return {
          label: item["name"],
          value: item["id"],
          data: item
          }
    });

    $("#input").autocomplete({
      source:input_data,
      autoFocus:true,
      select: function(event,ui){
        callBack(ui.item.data);
        $("#input").val("");
        return false;
      },
      position:{my:"center top",at:"center bottom",of:"input"}
    });
  };
var cm;

$(document).ready(function(){
  function ClusterViewModel(){
    var self = this;

    // Observables
    // order of observable declaration reflects
    // the flow of selection in the UI
    self.requestTypes = ko.observable();
    self.chosenRequestTypeId = ko.observable();
    self.clusters = ko.observable();
    self.streets = ko.observable();
    self.chosenStreetName = ko.observable();
    self.chosenStreetStats = ko.observable();
    self.mapMode = ko.observable("clusterMap");
    self.issues=ko.observable();
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
      // self.chosenRequestType(requestTypeId);
      // self.location("app");
      $.get('/clusters/cluster_menu/'+requestTypeId,
        function(data){
          self.clusters(data["clusters"]);
          self.batch(data["batch"]);
          plotMap(data["clusters"],self.mapMode());
      });
      $.get("/streets/ranking/"+requestTypeId,
        function(data){
          self.streets(data["streets"]);
      });
    };

    self.goToStreetPage = function(street){
      console.log(street);
      self.chosenStreetName(street["name"]);
      $.get("/streets/stats/"+street["id"],function(data){
        self.chosenStreetStats(data["stats"]);
      });
      $("#streetPage").show();
    };

    //toggle map using global heatmap and overlay
    //variables which are created in the map module
    $("#mapToggle").click(function(e){
      self.mapMode(self.mapMode()=="heatMap" ? "clusterMap":"heatMap");
      $("#mapToggle").toggleClass("heatmap");
      if (heatMap){
        heatMap.setMap(heatMap.getMap() ? null : map);
        clusterMap.setMap(clusterMap.getMap() ? null : map);
      };
    });

    $("#issuesExport").click(function(e){
      title="Scastrap_issues_"
      title+self.chosenRequestType()["name"];
      title+="_"+self.batch()["created_at"];
      title+="_cluster_id#"+self.chosenCluster()["id"]+".csv";
      exportIssues(self.issues(),title);
    });

    $("#streetsExport").click(function(e){
      title="Scastrap_street_ranking_";
      title+=self.chosenRequestType()["name"];
      title+="_"+self.batch()["created_at"]+".csv";
      exportStreets(self.streets(),title);
    });

    $("#combobox").change(function(e){
      // console.log("asdf");
      self.getData($("#combobox").val())
    });

    self.getRequestTypeMenu();
  }
  cm = new ClusterViewModel();
  ko.applyBindings(cm);
});
