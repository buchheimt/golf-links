$(document).on("turbolinks:load", () => {
  $(".btn.warning").click(e => {
    if (confirm("Are you sure?")) {
      $.ajax({url: $(".btn.warning").data("url"), method: "DELETE"});
    }
  });
  $("#mobileNavBtn").on('click', () => toggleMobileDropdown());
  loadRangeSliders();
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
