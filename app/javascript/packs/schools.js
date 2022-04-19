
import '../styles/selectize.scss';
//= require turbolinks
require("turbolinks")
require("selectize")
require ("bootstrap")
require ("jquery")

var selectizeCallback = null;



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
let create_school = function(input,callback){
  var selectizeCallback = callback;
  window.Selectize = require('selectize');
  $('#school_form').show();
  $(".btn-primary").show();
  var form = $("#school_form").find("#inner_form").find("#innest_form").find("#close_button");
  var name_input = $("#school_form").find("#inner_form").find("#name_input").find("#school_name");
  name_input.val(input);
  form.click(function(e) {
    if (selectizeCallback != null) {
    selectizeCallback();
    selectizeCallback = null;
    $("#submit_button").hide();
  }
  $('#school_form').hide();
  });
}
var selecting = $(".select").selectize({
create: create_school, createOnBlur: true,
 highlight: true});
