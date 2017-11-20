$(document).on("turbolinks:load", () => {
  attachWarningConfirmation();
  attachMobileDropdownToggle();
  loadRangeSliders();
});

const attachWarningConfirmation = () => {
  $(".btn.warning").on('click', function() {
    if (confirm("Are you sure?")) {
      $.ajax({url: $(this).data("url"), method: "DELETE"});
    }
  });
}

const attachMobileDropdownToggle = () => {
  $("#mobileNavBtn").on('click', () => {
    const darkGreen = "rgb(54, 79, 64)";
    const $toggleIcon = $("svg.octicon-grabber");
    const newColor = $toggleIcon.css('fill') === darkGreen ? 'white' : darkGreen;
    $toggleIcon.css({fill: newColor});
    $(".mobileLinks").toggle();
  });
}

const loadRangeSliders = () => {
  $('input[type="range"]').rangeslider({polyfill: false}).on("input change", function() {
    $(this).parent().prev().val($(this).val());
  });
}
