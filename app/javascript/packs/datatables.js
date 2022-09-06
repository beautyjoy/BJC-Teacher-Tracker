$(function() {
  // Filtering for the Admin Teachers Index
  $.fn.dataTable.ext.search.push((_, searchData) => {
    let enabled = $('input:checkbox[name="statusFilter"]:checked').map((_i, el) => el.value).get();
    console.log(enabled)
    // Include all rows when no checkboxes are selected.
    return enabled.length === 0 || enabled.includes(searchData[6]);
  });

  let $tables = $('.js-dataTable').DataTable({
      dom: "<'row form-row'<'col-9 form-inline'i><'col-3 form-inline'lf>>" +
      "<'row'<'col-12'tr>>" +
      "<'row'<'col-sm-12 col-md-5'B><'col-sm-12 col-md-7'p>>",
      pageLength: 100,
      lengthMenu: [ [25, 50, 100, 250, -1], [25, 50, 100, 250, "All"] ],
      buttons: [ 'copy', 'csv' ],
      language: {
        search: '_INPUT_',
        searchPlaceholder: 'Search'
      }
  });

  $tables.draw();
  $(".custom-checkbox").on("change", () => $tables.draw());
});
