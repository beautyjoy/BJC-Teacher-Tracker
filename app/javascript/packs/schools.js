
import '../styles/selectize.scss';
//= require turbolinks
require("turbolinks")
require("selectize")
require ("bootstrap")
require ("jquery")





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
  selectizeCallback = callback;
  window.Selectize = require('selectize');
  $('#school_form').show();
  $(".btn-primary").show();
  var form = $("#school_form").find("#inner_form").find("#innest_form").find("#close_button");
  var name_input = $("#school_form").find("#inner_form").find("#name_input").find("#school_name");
  name_input.val(input);
  var selectizeCallback = null;
  form.click(function(e) {
    if (selectizeCallback != null) {
    selectizeCallback();
    selecitzeCallback = null;
  }
  //var $select = $('.select').selectize();
 //var control = $select[0].selectize;
 //control.clear();
 //location.reload();
 $('.select').selectize()[0].selectize.clear();
 selectize.load();
  $('#school_form').hide();
  });
}
let loading_funct = function(query,callback){
        $.ajax({
            url: '/school/search',
            type: 'GET',
            dataType: 'json',
            data: {

            },
            error: function () {
                callback();
            },
            success: function (res) {
              byebug
                callback(res);
            }
})
};
var selecting = $(".select").selectize({
create: create_school, load: loading_funct
, createOnBlur: true,
 highlight: true});
