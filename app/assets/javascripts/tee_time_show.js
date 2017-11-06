$(function() {
  $("#joinTeeTime").submit(joinTeeTime);
  $("#addGuest").submit(addGuest);
  $("#removeGuest").submit(removeGuest);
  $("#leaveTeeTime").submit(leaveTeeTime);
});

const joinTeeTime = (e) => {
  const templateSource = $("#user-card-template").html();
  const template = Handlebars.compile(templateSource);
  e.preventDefault();
  const values = $("#joinTeeTime").serialize();
  $.post("/user_tee_times", values, function(data) {
    const newCard = template(data.user);
    $("div.user-list > div.row").append($(newCard));
    $("#joinBtn").prop("disabled");
    $("#leaveBtn").removeAttr("disabled");
    if ($("div.user-list > div.row > div").length < 4) {
      $("#addBtn").removeAttr("disabled");
    }
    $("#currentUser").data("id", data.id);
  });
  $("#commentSection").show();
}

const addGuest = (e) => {
  const templateSource = $("#guest-card-template").html();
  const template = Handlebars.compile(templateSource);
  e.preventDefault();
  $.ajax({
    url: "/user_tee_times/" + $("#currentUser").data("id"),
    method: 'PATCH',
    data: {'operation': '1'}
  }).done(function(user) {
    const newCard = template(user);
    $("div.user-list > div.row").append($(newCard));
  });
  if ($("div.user-list > div.row > div").length + 1 >= 4) {
    $("#addBtn").prop("disabled");
  }
  $("#removeBtn").removeAttr("disabled");
}

const removeGuest = (e) => {
  e.preventDefault();
  $.ajax({
    url: "/user_tee_times/" + $("#currentUser").data("id"),
    method: 'PATCH',
    data: {'operation': '-1'}
  }).done(function(userTeeTime) {
    $(".userGuest").last().remove();
    if (userTeeTime.guest_count < 1) {
      $("#removeBtn").prop("disabled");
    }
  });
  $("#addBtn").removeAttr("disabled");
}

const leaveTeeTime = (e) => {
  const userCount = $("#currentUser").length;
  const guestCount = $(".userGuest").length;
  const totalCount = $("div.user-list > div.row > div").length;
  if (userCount + guestCount < totalCount) {
    e.preventDefault();
    $.ajax({
      url: "/user_tee_times/" + $("#currentUser").data("id"),
      method: "DELETE"
    }).done(function(user) {
      $("#currentUser").remove();
      $(".userGuest").remove();
      $("#leaveBtn").prop("disabled");
      $("#addBtn").prop("disabled");
      $("#removeBtn").prop("disabled");
      $("#joinBtn").removeAttr("disabled");
      $("#commentSection").hide();
    });
  }
}
