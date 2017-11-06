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

    if (data.user.get_image !== "user-default.jpg") {
      $("#currentUser img").attr("src", data.user.get_image);
    }

    $("#joinBtn").prop("disabled", true);
    $("#leaveBtn").prop("disabled", false);
    if ($("div.user-list > div.row > div").length < 4) {
      $("#addBtn").prop("disabled", false);
    } else {
      $("#addBtn").prop("disabled", true);
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
    $("#addBtn").prop("disabled", true);
  } else {
    $("#addBtn").prop("disabled", false);
    $("#addBtn").removeAttr("data-disable-with");
  }
  $("#removeBtn").prop("disabled", false);
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
      $("#removeBtn").prop("disabled", true);
    } else {
      $("#removeBtn").prop("disabled", false);
      $("#removeBtn").removeAttr("data-disable-with");
    }
  });
  $("#addBtn").prop("disabled", false);
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
      $("#leaveBtn").prop("disabled", true);
      $("#addBtn").prop("disabled", true);
      $("#removeBtn").prop("disabled", true);
      $("#joinBtn").prop("disabled",false);
      $("#commentSection").hide();
    });
  }
}
