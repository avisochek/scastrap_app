$(document).on('ready',function(){
  $("#map").height(($(window).height()-150)+"px");
  $(".sidebarContent").height(($(window).height()-120)+"px");
  //$("#main.open").width($(window).width()-300+"px");

  // $("#issuesToggle").click(function(){
  // $("#sidebar").addClass("open");
  // $("#main").addClass("open");
  // $("#issues").addClass("open");
  // $("#streets").removeClass("open");

})

$(window).on('resize',function(){
  $("#map").height(($(".container").height()-150)+"px");
  $(".sidebarContent").height(($(window).height()-120)+"px");
  // if ($(window).width()<600){
  //   $("#main").css("margin-right",$(".container").width-600+"px");
  // }
}).trigger('resize');
