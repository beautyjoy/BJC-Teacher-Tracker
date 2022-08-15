import "../styles/selectize.scss";
require("turbolinks");
require("selectize");
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
  window.Selectize = require("selectize");
  $("#school_form").show();
  $("#school_name").prop("required", true);
  $("#school_city").prop("required", true);
  $("#school_state").prop("required", true);
  $("#school_website").prop("required", true);
  $(".btn-primary").show();
  var form = $("#close_button");
  var name_input = $("#school_name");
  name_input.val(input);
  form.on("click", (_event) => {
    if (selectizeCallback != null) {
      selectizeCallback();
      selectizeCallback = null;
      $("#submit_button").hide();
    }
    $("#school_form").hide();
  });
};

$(".select").selectize({
  create: create_school,
  createOnBlur: true,
  highlight: true,
});
