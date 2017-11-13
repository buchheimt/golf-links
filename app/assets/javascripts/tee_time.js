$(document).on("turbolinks:load", function() {
  $("#filterForm").submit(reloadTeeTimes);
})

const reloadTeeTimes = (e) => {
  e.preventDefault();
  const templateSource = $("#tee-time-template").html();
  const template = Handlebars.compile(templateSource);
  const values = $(e.target).serialize();
  $.get("/tee_times.json", values, (teeTimes) => {
    $("#teeTimeCards").fadeOut('fast', function() {
      $("#teeTimeCards").empty();
      teeTimes.forEach(function(teeTime) {
        const $teeTimeDiv = $(template(teeTime));
        $("#teeTimeCards").append($teeTimeDiv);
        if (!teeTime['available?']) {
          $teeTimeDiv.children("div").addClass("tee-time-unjoinable");
        }
        if ($(".nav-user-card")[0]) {
          const userMatch = teeTime.user_tee_times.find(function(el) {
            return el.user_id === $(".nav-user-card").data("id");
          });
          if (userMatch) {
            $teeTimeDiv.find(".joined-marker").show();
          }
        }
      });
      $("#filterBtn").removeAttr("data-disable-with");
      $("#filterBtn").removeAttr("disabled");
      $("#teeTimeCards").fadeIn('fast');
    });
  });

}
