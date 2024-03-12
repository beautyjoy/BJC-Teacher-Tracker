document.addEventListener('DOMContentLoaded', function() {
    var countryField = document.getElementById('school_country');
    var stateField = document.getElementById('school_state');
  
    function updateStateRequired() {
      if (countryField.value === 'US') {
        stateField.required = true;
        setOptionsForStates();
      } else {
        stateField.required = false;
        setOptionsForInternational();
      }
    }
  
    function setOptionsForStates() {
      var stateOptions = School.VALID_STATES;
      stateField.innerHTML = "";
      for (var i = 0; i < stateOptions.length; i++) {
        var option = document.createElement('option');
        option.value = stateOptions[i];
        option.text = stateOptions[i];
        stateField.add(option);
      }
    }
  
    function setOptionsForInternational() {
        var stateOptions = School.VALID_STATES;
      stateField.innerHTML = "";
      for (var i = 0; i < 1; i++) {
        var option = document.createElement('option');
        option.value = stateOptions[i];
        option.text = stateOptions[i];
        stateField.add(option);
      }
    }
  
    countryField.addEventListener('change', updateStateRequired);
    updateStateRequired();
  });