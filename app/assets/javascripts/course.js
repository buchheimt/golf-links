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
  } //else {
  //   $("#coursePic").attr("src", "/assets/images/course-default.jpg");
  // }


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
