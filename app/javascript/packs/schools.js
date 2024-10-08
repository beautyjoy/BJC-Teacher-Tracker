import "../styles/selectize.scss";

// TODO: figure out why this needs to be here.
require("turbolinks");
window.Selectize = require("selectize");
require("bootstrap");
require("jquery");

$("#new_school").on("submit", function (e) {
  e.preventDefault();
  $.ajax({
    method: "POST",
    url: $(this).attr("action"),
    data: $(this).serialize(),
    success: function (response) {
      window.location = "/schools";
      selectizeCallback = null;
    },
  });
});

// TODO: This list should match the model attributes.
// These are all prefixed with schol_ on the page form.
const SCHOOL_REQUIRED_ATTRIBUTES = ['name', 'city', 'state', 'website', 'grade_level', 'type'];

let toggle_required = (fields, state) => {
  fields.forEach(s => $(`#school_${s}`).prop("required", state));
  fields.forEach(s => $(`[for=school_${s}]`).addClass('label-required'));
}

let create_school = function (input, callback) {
  var selectizeCallback = callback;
  $("#school_form").show();
  toggle_required(SCHOOL_REQUIRED_ATTRIBUTES, true);
  $(".btn-primary").show();
  let original_school_id = $('#teacher_school_id').val();
  var reset_button = $("#close_button");
  var name_input = $("#school_name");
  // Unset the existing saved school id.
  $('#teacher_school_id').val(null);
  name_input.val(input);
  reset_button.on("click", (_event) => {
    if (selectizeCallback != null) {
      selectizeCallback();
      selectizeCallback = null;
      $('#teacher_school_id').val(original_school_id);
    }
    toggle_required(SCHOOL_REQUIRED_ATTRIBUTES, true);
    $("#school_form").hide();
  });
};

let $school_selector = $(".select").selectize({
  create: create_school,
  createOnBlur: true,
  highlight: true,
});

$school_selector.on('change', () => {
  let selectedSchool = JSON.parse($("#school_selectize").val());
  $('#teacher_school_id').val(selectedSchool.id);
  toggle_required(SCHOOL_REQUIRED_ATTRIBUTES, false);
});
