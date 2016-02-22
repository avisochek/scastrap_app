// var map;
// function initMap(category) {
//   // Create a map object and specify the DOM element for display.
//   map = new google.maps.Map(document.getElementById('map'), {
//     center: {lat: 41.31, lng: -72.898197},
//     scrollwheel: false,
//     zoom: 8
//   });
//
// //debugger;
//
// //create array of longitude, latitude coordinates
// var geo_data=[]
// var latlngbounds = new google.maps.LatLngBounds();
// <% @issues.each do |issue| %>
//   var lat = <%=issue[:lat]%>
//   var lng = <%=issue[:lng]%>
//   geo_data.push(new google.maps.LatLng(lat,lng));
// <% end %>
//
// //use geo_data to create bounds and populate the map
// geo_data.forEach(function(loc){
//         latlngbounds.extend(loc);
//         var color = "blue";
//         //if (meta_data[i]['status']==="Open"){color="red"}
//         var Circle = new google.maps.Circle({
//           strokeColor: color,
//           strokeOpacity: 0.8,
//           strokeWeight: .5,
//           fillColor: color,
//           fillOpacity: 0.35,
//           map: map,
//           center: loc,
//           radius: 4
//         });
// });
// map.setCenter(latlngbounds.getCenter());
// map.fitBounds(latlngbounds);
// }
