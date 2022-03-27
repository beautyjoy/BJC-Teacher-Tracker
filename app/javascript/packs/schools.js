console.log("why")
import '../styles/selectize.scss';
//= require turbolinks
require("turbolinks")
require("selectize")
require ("bootstrap")
require ("jquery")

  //  $(".selectize").selectize(
      //  );

            $(".select").selectize({
                    create: true,
                    sortField: 'text',
                    searchField: 'item',
                    create: function(input) {
                        return {
                            value: input,
                            text: input
                    }
}
                });
