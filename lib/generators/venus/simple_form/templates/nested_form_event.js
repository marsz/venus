
$(document).on('nested:fieldAdded', function(event){
  // this field was just inserted into your form
  var field = event.field; 
  // it's a jQuery object already! Now you can find date input
  // var dateField = field.find('.date');
  // dateField.datepicker(); // and activate datepicker on it
})
