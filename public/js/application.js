$(document).ready(function() {
  
  $('#wait').hide();

  $('form').on('submit', function(e) {
    e.preventDefault();
    $('#tweet_log').remove();
    $('#wait').show();

    var data = $('form').serialize();
    $.post('/', data, function(response){
      $('form').after(response);
      $('#wait').hide();
    });
    
  });

});
