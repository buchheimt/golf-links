$(function() {
  $("#filterBtn").click(reloadTeeTimes);
})


const reloadTeeTimes = (e) => {
  e.preventDefault();
  const templateSource = $("#tee-time-template").html();
  const template = Handlebars.compile(templateSource);
  $.get("/tee_times.json", (teeTimes) => {
    $("#teeTimeCards").empty();
    teeTimes.forEach(function(teeTime) {
      const $teeTimeDiv = $(template());
      $("#teeTimeCards").append($teeTimeDiv);
    })
  });
}
