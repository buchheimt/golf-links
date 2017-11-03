$(function() {
  const timeSlots = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18].reduce(function(output, hour) {
    console.log(output, hour);
    output.push(hour + ":00");
    output.push(hour + ":15");
    output.push(hour + ":30");
    output.push(hour + ":45");
    return output;
  }, []);

  console.log(timeSlots);

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
