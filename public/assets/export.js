function exportIssues(issues,title){
  data=issues.map(function(issue){
    return [
      issue["id_"],
      issue["date"],
      issue["summary"],
      issue["description"],
      issue["lat"],
      issue["lng"]
    ]
  });
  data.unshift(["issue_id","date created","summary","description","lat","lng"]);
  exportData(data,title);
};

function exportStreets(streets,title){
  data = streets.map(function(street){
    return [
      street["name"],
      street["rank"],
      street["percentile"],
      street["count"],
      street["length"],
      street["probability"],
      street["issues_per_mile"]
    ];
  });
  data.unshift([
    "rank",
    "name",
    "percentile",
    "number_of_issues",
    "length",
    "probability",
    "issues_per_mile"]);
  exportData(data,title);
};

function exportData(data,title){
  var csvContent = "data:text/csv;charset=utf-8,";
  data.forEach(function(infoArray, index){
    dataString = infoArray.join(",");
    csvContent += index < data.length ? dataString+ "\n" : dataString;
  });
  var encodedUri = encodeURI(csvContent);
  var link = document.createElement("a");
  link.setAttribute("href", encodedUri);
  link.setAttribute("download", title);

  link.click();
}
