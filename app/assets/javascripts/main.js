$(document).on("turbolinks:load", function() {
  $(".btn.warning").click(function(e) {
    if (confirm("Are you sure?")) {
      const deleteRoute = $(this).data("url");
      $.ajax({url: deleteRoute, method: "DELETE"});
    }
  });
  $("#mobileNavBtn").click(toggleMobileDropdown);
  loadRangeSliders();
});

const toggleMobileDropdown = () => {
  const darkColor = "rgb(54, 79, 64)";
  if ($("svg.octicon-grabber").css("fill") === darkColor ) {
    $("svg.octicon-grabber").css({fill: "white"});
  } else {
    $("svg.octicon-grabber").css({fill: darkColor});
  }
  $(".mobileLinks").toggle();
}

const loadRangeSliders = () => {
  $('input[type="range"]').rangeslider({polyfill: false});
  $('input[type="range"]').on("input change", function(e) {
    $(this).parent().prev().val($(this).val());
  });
}
