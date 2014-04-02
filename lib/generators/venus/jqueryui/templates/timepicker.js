$(document).ready(function() {
  $("[data-datetimepicker]").each(function(){
    // more options: http://trentrichardson.com/examples/timepicker/
    $(this).datetimepicker({
      dateFormat: "yy-mm-dd",
      hourGrid: 4,
      minuteGrid: 10,
      stepMinute: 10
    });
  });
});
