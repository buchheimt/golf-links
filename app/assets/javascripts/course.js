$(function() {
  $("#prevBtn").click(getPrev);
  $("#nextBtn").click(getNext);
});

const updateCourseShow = (course) => {
  setField("location", course);
  setField("par", course);
  setField("length", course);
  setField("price", course);
  setField("name", course);
  setField("description", course);

  if (course.image.indexOf("course-default.jpg") != 0) {
    $("#coursePic").attr("src", course.image);
  }

  loadTeeTimes(course.tee_times);

  $("#prevBtn").data("id", course.id);
  $("#nextBtn").data("id", course.id);
}

const getPrev = () => {
  const currId = $("#prevBtn").data("id");
  $.get("/courses/" + currId + "/prev", function(course) {
    updateCourseShow(course);
  });
}

const getNext = () => {
  const currId = $("#nextBtn").data("id");
  $.get("/courses/" + currId + "/next", function(course) {
    updateCourseShow(course);
  });
}

const setField = (field, course) => {
  value = course[field]
  if (value == null) {
    value = "";
  } else {
    $("#" + field).text(value);
  }
}

const loadTeeTimes = (teeTimes) => {
  const templateSource = $("#tee-time-template").html();
  const template = Handlebars.compile(templateSource);
  $("#teeTimeCards").empty();
  teeTimes.forEach(function(teeTime) {
    console.log(teeTime.time)
    console.log(teeTime.time >= Date.now())
    if (teeTime.active) {
      const $teeTimeDiv = $(template(teeTime));
      $("#teeTimeCards").append($teeTimeDiv);
    }
  })
}
