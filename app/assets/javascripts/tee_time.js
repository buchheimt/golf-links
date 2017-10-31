$(function() {
  $("#filterBtn").click(reloadTeeTimes);
})


const reloadTeeTimes = (e) => {
  e.preventDefault();
  $.get("/tee_times.json", (teeTimes) => {
    $("#teeTimeCards").empty();
    teeTimes.forEach(function(teeTime) {
      const $teeTimeCard = $("#teeTimeCards").append('<div class="col-sm-6">' + teeTime["time"] + '</div>');
    })
  });
}
