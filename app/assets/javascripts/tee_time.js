function TeeTime(attributes) {
  this.id = attributes.id;
  this.course = attributes.course;
  this.timeFormatted = attributes.time_formatted;
  this.groupSize = attributes.group_size;
  this.avgPace = attributes.avg_pace;
  this.avgExperience = attributes.avg_experience;
  this.userTeeTimes = attributes.user_tee_times;
  this.available = attributes['available?'];
}

TeeTime.ready = function() {
  if ($("#tee-time-template")[0]) {
    TeeTime.templateSource = $("#tee-time-template").html();
    TeeTime.template = Handlebars.compile(TeeTime.templateSource);
  }
}

TeeTime.prototype.renderDiv = function() {
  this.$div = $(TeeTime.template(this));
  $("#teeTimeCards").append(this.$div);
  if (!this.available) {
    this.$div.children("div").addClass("tee-time-unjoinable");
  }
  if (this.includesCurrentUser()) {
    this.$div.find(".joined-marker").show();
  }
}

TeeTime.prototype.includesCurrentUser = function() {
  if ($(".nav-user-card")[0]) {
    return !!this.userTeeTimes.find(function(el) {
      return el.user_id === $(".nav-user-card").data("id");
    });
  }
  return false;
}

$(document).on("turbolinks:load", function() {
  $("#filterForm").submit(reloadTeeTimes);
  TeeTime.ready();
})

const reloadTeeTimes = (e) => {
  e.preventDefault();
  const values = $(e.target).serialize();
  $.get("/tee_times.json", values, (teeTimes) => {
    $("#teeTimeCards").fadeOut('fast', function() {
      $("#teeTimeCards").empty();
      teeTimes.forEach(function(teeTimeJSON) {
        const teeTime = new TeeTime(teeTimeJSON);
        teeTime.renderDiv();
      });
      $("#filterBtn").removeAttr("data-disable-with");
      $("#filterBtn").removeAttr("disabled");
      $("#teeTimeCards").fadeIn('fast');
    });
  });
}
