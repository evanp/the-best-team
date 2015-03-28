var startSpinner = function() {}

var stopSpinner = function() {}

var updateTable = function(data) {
  console.log(JSON.stringify(data));
}

var getSliderValues = function() {
  var values = {
    "K-BB%": "medium",
    "WHIP": "ignore",
    "ERA": "low",
    "RA9-WAR": "high",
    "OPS": "medium",
    "Spd": "low",
    "R-diff": "high"
  };
  return values;
};

$(document).ready(function() {
    console.log("DOING IT");
    var values = getSliderValues();
    console.log(JSON.stringify(values));
    startSpinner();
    $.post("/ranking", values, function (data) {
      stopSpinner();
      updateTable(data);
    });
});
