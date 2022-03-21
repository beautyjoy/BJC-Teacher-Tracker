//= require selectize
require("selectize")
require("packs/language")
$(document).on("turbolinks:load", function() {
    var selectizeCallback = null;

    $(".language-modal").on("hide.bs.modal", function(e) {
        if (selectizeCallback != null) {
            selectizeCallback();
            selectizeCallback = null;
        }

        $("#new_language").trigger("reset");
        $.rails.enableFormElements($("#new_language"));
    });

    $("#new_language").on("submit", function(e) {
        e.preventDefault();
        $.ajax({
            method: "POST",
            url: $(this).attr("action"),
            data: $(this).serialize(),
            success: function(response) {
                selectizeCallback({value: response.id, text: response.name});
                selectizeCallback = null;

                $(".language-modal").modal('toggle');
            }
        });
    });

    $(".selectize").selectize({
        create: function(input, callback) {
            selectizeCallback = callback;

            $(".language-modal").modal();
            $("#language_name").val(input);
        }
    });
});
