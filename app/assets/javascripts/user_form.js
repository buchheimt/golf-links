$(function() {
  $('input[type="range"]').rangeslider({polyfill: false});
  $('input[type="range"]').on("input change", updateResult);
});

const updateResult = (e) => {
  const $range = $(e.target);
  $range.parent().prev().val($range.val());
}
