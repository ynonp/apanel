$('tr').on('click', function() {
  var name = $(this).attr('data-name');
  var url = window.location.href.replace(/\/$/,'');

  window.location.href = url + '/edit/' + name;

});