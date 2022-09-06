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

let create_school = function (input, callback) {
  var selectizeCallback = callback;
  $("#school_form").show();
  $("#school_name").prop("required", true);
  $("#school_city").prop("required", true);
  $("#school_state").prop("required", true);
  $("#school_website").prop("required", true);
  $(".btn-primary").show();
  let oringial_school_id = $('#teacher_school_id').val();
  var reset_button = $("#close_button");
  var name_input = $("#school_name");
  // Unset the existing saved school id.
  $('#teacher_school_id').val('');
  name_input.val(input);
  reset_button.on("click", (_event) => {
    if (selectizeCallback != null) {
      selectizeCallback();
      selectizeCallback = null;
      $("#submit_button").hide();
      $('#teacher_school_id').val(oringial_school_id);
    }
    $("#school_form").hide();
  });
};

$(".select").selectize({
  create: create_school,
  createOnBlur: true,
  highlight: true,
});
