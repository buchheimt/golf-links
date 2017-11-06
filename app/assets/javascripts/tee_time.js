$(function() {
  $("#filterForm").submit(reloadTeeTimes);
})


const reloadTeeTimes = (e) => {
  e.preventDefault();
  const templateSource = $("#tee-time-template").html();
  const template = Handlebars.compile(templateSource);
  const values = $(e.target).serialize();
  $.get("/tee_times.json", values, (teeTimes) => {
    $("#teeTimeCards").empty();
    teeTimes.forEach(function(teeTime) {
      const $teeTimeDiv = $(template(teeTime));
      $("#teeTimeCards").append($teeTimeDiv);
      if (!teeTime['available?']) {
        $teeTimeDiv.children("div").addClass("tee-time-unjoinable");
      }
    })
    $("#filterBtn").removeAttr("data-disable-with");
    $("#filterBtn").removeAttr("disabled");
  });
}
