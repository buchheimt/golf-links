$(function() {
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
  $("#selectCourseForm").show();
  $("#selectCourseBtn").addClass("btn-selected");
  $("#newCourseForm").hide();
  $("#newCourseForm input[type=text]").val("");
  $("#newCourseForm textarea").val("");
  $("#newCourseBtn").removeClass("btn-selected");
}

const revealCourseNew = (e) => {
  e.preventDefault();
  $("#newCourseForm").show();
  $("#newCourseBtn").addClass("btn-selected");

  $("#selectCourseForm").hide().removeClass("btn-selected");
  $("#tee_time_course_id").val($("#tee_time_course_id").data("default-value"));
  $("#selectCourseBtn").removeClass("btn-selected");
}
