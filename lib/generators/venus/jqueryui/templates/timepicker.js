
$(document).ready(function() {
  $(".datetimepicker").each(function(){
    $(this).datetimepicker({
      dateFormat: "yy-mm-dd",
      hourGrid: 4,
      minuteGrid: 10,
      stepMinute: 10
    });
  });
});
