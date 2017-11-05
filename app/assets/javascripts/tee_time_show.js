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
    console.log(data);
    console.log(data.id);
    $("#currentUser").data("id", data.id);
  });
  $("#joinBtn").removeAttr("data-disable-with");
  $("#joinBtn").removeAttr("disabled");
}

const addGuest = (e) => {
  e.preventDefault();
  $.ajax({
    url: "/user_tee_times/" + $("#currentUser").data("id"),
    method: 'PATCH',
    data: {'operation': 1}
  }).done(function() {
    alert('done did!')
  });


  $("#addBtn").removeAttr("data-disable-with");
  $("#addBtn").removeAttr("disabled");
  // show remove button
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
    $("#leaveDiv").hide();
    $("#joinDiv").show();
    $("#addDiv").hide();
    $("#removeDiv").hide();
    $("#leaveBtn").removeAttr("data-disable-with");
    $("#leaveBtn").removeAttr("disabled");
  });
}
