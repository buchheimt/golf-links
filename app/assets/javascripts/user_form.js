$(function() {
  $('input[type="range"]').rangeslider({polyfill: false});
  $('input[type="range"]').on("input change", updateResult);
});

const updateResult = (e) => {
  const $range = $(e.target);
  console.log($range.val());
  console.log($range.prev());
  $range.parent().prev().val($range.val());
}
