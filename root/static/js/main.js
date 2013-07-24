var loading = false;
$('#btn-restart-tomcat').button('reset');

$('#btn-restart-tomcat').on('click', function() {
  loading = true;
  $(this).button('loading');

  $.ajax({
    type: 'POST',
    url: '/tomcat/restart',
    complete: function() {
      loading = false;
      $('#btn-restart-tomcat').button('reset');
    }
  });
});