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
    $("#joinDiv").hide();
    $("#leaveDiv").show();
    if ($("div.user-list > div.row > div").length < 4) {
      $("#addDiv").show();
    }
    $("#currentUser").data("id", data.id);
  });
  $("#joinBtn").removeAttr("data-disable-with");
  $("#joinBtn").removeAttr("disabled");
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
    $("#addDiv").hide();
  }
  $("#addBtn").removeAttr("data-disable-with");
  $("#addBtn").removeAttr("disabled");
  $("#removeDiv").show();
}

const removeGuest = (e) => {
  e.preventDefault();
  alert ("removing!");


  $("#removeBtn").removeAttr("data-disable-with");
  $("#removeBtn").removeAttr("disabled");
  // show add button
}

const leaveTeeTime = (e) => {
  e.preventDefault();
  $.ajax({
    url: "/user_tee_times/" + $("#currentUser").data("id"),
    method: "DELETE"
  }).done(function(user) {
    $("#currentUser").remove();
    $(".userGuest").remove();
    $("#leaveDiv").hide();
    $("#joinDiv").show();
    $("#addDiv").hide();
    $("#removeDiv").hide();
    $("#leaveBtn").removeAttr("data-disable-with");
    $("#leaveBtn").removeAttr("disabled");
  });
}
