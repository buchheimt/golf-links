$(document).on("turbolinks:load", function() {
  $("#selectCourseBtn").click(revealCourseSelect);
  $("#newCourseBtn").click(revealCourseNew);

  const timeSlots = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18].reduce(function(output, hour) {
    output.push(hour + ":00");
    output.push(hour + ":15");
    output.push(hour + ":30");
    output.push(hour + ":45");
    return output;
  }, []);

  $("#datetimepicker").datetimepicker({
    allowTimes: timeSlots,
    mask: true,
    minDate: 0,
    maxDate: '2019/12/31',
    roundTime: 'round',
    defaultTime: '18:00',
    theme: 'dark'
  });
});

const revealCourseSelect = (e) => {
  e.preventDefault();
  $("#selectCourseBtn").blur();

  $("#newCourseForm").fadeOut(200, function() {
    $("#selectCourseForm").fadeIn();
    $("#selectCourseBtn").addClass("btn-selected");
    $("#newCourseForm input[type=text]").val("");
    $("#newCourseForm textarea").val("");
    $("#newCourseBtn").removeClass("btn-selected");
  });
}

const revealCourseNew = (e) => {
  e.preventDefault();
  $("#newCourseBtn").blur();

  $("#selectCourseForm").fadeOut(200, function() {
    $("#newCourseForm").fadeIn();
    $("#newCourseBtn").addClass("btn-selected");
    $("#tee_time_course_id").val($("#tee_time_course_id").data("default-value"));
    $("#selectCourseBtn").removeClass("btn-selected");
  });
}
