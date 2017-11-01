$(function() {
  $(".btn.warning").click(function(e) {
    if (confirm("Are you sure?")) {
      const deleteRoute = $(this).data("url");
      $.ajax({url: deleteRoute, method: "DELETE"});
    }
  });
});
