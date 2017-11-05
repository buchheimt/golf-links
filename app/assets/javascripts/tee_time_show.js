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
    const newCard = template(data);
    $("div.user-list > div.row").append($(newCard));
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
  e.preventDefault();
  alert ("leaving!");
}
