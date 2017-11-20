$(document).on("turbolinks:load", () => {
  $(".btn.warning").click(e => {
    if (confirm("Are you sure?")) {
      $.ajax({url: $(".btn.warning").data("url"), method: "DELETE"});
    }
  });
  $("#mobileNavBtn").on('click', () => toggleMobileDropdown());
  loadRangeSliders();
  loadTeeTimeForm();
});

const toggleMobileDropdown = () => {
  const darkGreen = "rgb(54, 79, 64)";
  const $toggleIcon = $("svg.octicon-grabber");
  const newColor = $toggleIcon.css('fill') === 'white' ? darkGreen : 'white';
  $toggleIcon.css({fill: newColor});
  $(".mobileLinks").toggle();
}

const loadRangeSliders = () => {
  $('input[type="range"]').rangeslider({polyfill: false}).on("input change", function(e) {
    $(this).parent().prev().val($(this).val());
  });
}

const loadTeeTimeForm = () => {
  $("#selectCourseBtn").click(revealCourseSelect);
  $("#newCourseBtn").click(revealCourseNew);
  loadDatetimepicker();
}

const loadDatetimepicker = () => {
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
}

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
