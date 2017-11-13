$(function() {
  $(".btn.warning").click(function(e) {
    if (confirm("Are you sure?")) {
      const deleteRoute = $(this).data("url");
      $.ajax({url: deleteRoute, method: "DELETE"});
    }
  });
  $("#mobileNavBtn").click(function() {
    const darkColor = "rgb(54, 79, 64)";
    if ($("svg.octicon-grabber").css("fill") === darkColor ) {
      $("svg.octicon-grabber").css({fill: "white"});
    } else {
      $("svg.octicon-grabber").css({fill: darkColor});
    }
    $(".mobileLinks").toggle();
  });
});
