$.extend($.fn.dataTable.defaults, {
  paging: false
});

$(document).ready(function() {
  var table = $('.js-dataTable').DataTable({
      dom: '<"row"<"col-md-9" i><"col-md-3"f>>lrt<"row"<"col-md-3"B><"col-md-3"p>>',
      buttons: [ 'copy', 'csv' ],
      language: {
        search: '_INPUT_',
        searchPlaceholder: 'Search'
      }
  });
});
