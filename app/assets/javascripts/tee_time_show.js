$(document).on("turbolinks:load", () => {
  $("#joinTeeTime").submit(joinTeeTime);
  $("#addGuest").submit(addGuest);
  $("#removeGuest").submit(removeGuest);
  $("#leaveTeeTime").submit(leaveTeeTime);
});

const joinTeeTime = e => {
  const templateSource = $("#user-card-template").html();
  const template = Handlebars.compile(templateSource);
  e.preventDefault();
  const values = $("#joinTeeTime").serialize();
  $.post("/user_tee_times", values, userTeeTime => {
    const newCard = template(userTeeTime.user);
    $("div.user-list > div.row").append($(newCard));
    $("#currentUser").fadeIn();

    if (userTeeTime.user.get_image !== "user-default.jpg") {
      $("#currentUser img").attr("src", userTeeTime.user.get_image);
    }
    updateField("groupSize", userTeeTime.tee_time.group_size);
    updateField("avgPace", userTeeTime.tee_time.avg_pace);
    updateField("avgExperience", userTeeTime.tee_time.avg_experience);

    toggleButtons({join: true, leave: false, add: !userTeeTime.tee_time['available?']})
    $("#currentUser").data("id", userTeeTime.id);
  });
  $("#commentSection").fadeIn();
}

const addGuest = e => {
  const templateSource = $("#guest-card-template").html();
  const template = Handlebars.compile(templateSource);
  e.preventDefault();
  $.ajax({
    url: "/user_tee_times/" + $("#currentUser").data("id"),
    method: 'PATCH',
    data: {'operation': '1'}
  }).done(userTeeTime => {
    updateField("groupSize", userTeeTime.tee_time.group_size);
    $("div.user-list > div.row").append($(template(userTeeTime)));
    $(".userGuest").last().fadeIn();

    toggleButtons({add: !userTeeTime.tee_time['available?'], remove: false})
  });
}

const removeGuest = e => {
  e.preventDefault();
  $.ajax({
    url: "/user_tee_times/" + $("#currentUser").data("id"),
    method: 'PATCH',
    data: {'operation': '-1'}
  }).done(function(userTeeTime) {
    updateField("groupSize", userTeeTime.tee_time.group_size);
    $(".userGuest").last().fadeOut(400, function() {$(this).remove()});

    toggleButtons({add: false, remove: userTeeTime.guest_count < 1})
  });
}

const leaveTeeTime = e => {
  const userCount = $("#currentUser").length;
  const guestCount = $(".userGuest").length;
  const totalCount = $("div.user-list > div.row > div").length;
  if (userCount + guestCount < totalCount) {
    e.preventDefault();
    $.ajax({
      url: "/user_tee_times/" + $("#currentUser").data("id"),
      method: "DELETE"
    }).done(teeTime => {
      updateField("groupSize", teeTime.group_size);
      updateField("avgPace", teeTime.avg_pace);
      updateField("avgExperience", teeTime.avg_experience);

      $("#currentUser").fadeOut(400, function() {$(this).remove()});
      $(".userGuest").fadeOut(400, function() {$(this).remove()});
      toggleButtons({join: false, add: true, remove: true, leave: true})
      $("#commentSection").fadeOut();
    });
  }
}

const updateField = (selector, value) => {
  $("#" + selector).hide();
  $("#" + selector).text(value);
  $("#" + selector).fadeIn();
}

const toggleButtons = buttonStates => {
  for (let key in buttonStates) {
    const state = buttonStates[key]
    $(`#${key}Btn`).prop("disabled", state);
    if (!state) {
      $(`#${key}Btn`).removeAttr("data-disable-with");
    }
  }
}
