console.log("why")
import '../styles/selectize.scss';
//= require turbolinks
require("turbolinks")
require("selectize")
require ("bootstrap")
require ("jquery")

  //  $(".selectize").selectize(
      //  );


var selectizeCallback = null;

$(".school-modal").on("hide.bs.modal", function(e) {
if (selectizeCallback != null) {
selectizeCallback();
selecitzeCallback = null;
}

$("#new_school").trigger("reset");
$.rails.enableFormElements($("#new_school"));
});

$("#new_school").on("submit", function(e) {
e.preventDefault();
$.ajax({
method: "POST",
url: $(this).attr("action"),
data: $(this).serialize(),
success: function(response) {
  selectizeCallback({value: response.id, text: response.name});
  selectizeCallback = null;
  $(".school-modal").modal('toggle');
  window.location.replace("/schools");
  selectize.clear();
}
});
});

$(".select").selectize({
create: function(input, callback) {
selectizeCallback = callback;

$(".school-modal").modal();
$(".modal fade school-modal .modal-dialog modal-sm .modal-content .modal-body #school_name").val(input);
}
});
