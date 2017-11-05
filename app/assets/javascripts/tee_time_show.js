$(function() {
  $("#joinTeeTime").submit(joinTeeTime);
  $("#addGuest").submit(addGuest);
  $("#removeGuest").submit(removeGuest);
  $("#LeaveTeeTime").submit(leaveTeeTime);
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
    $("#leaveDiv").data("id", data.id);
  });


}

const addGuest = (e) => {
  e.preventDefault();
  alert ("adding!");
}

const removeGuest = (e) => {
  e.preventDefault();
  alert ("removing!");
}

const leaveTeeTime = (e) => {
  // e.preventDefault();
  // $.ajax({
  //   url: "/user_tee_times/"
  // })

}
