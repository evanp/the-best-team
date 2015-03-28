var startSpinner = function() {}

var stopSpinner = function() {}

var updateTable = function(data) {
  $("table#t01").empty();
  $("table#t01").append("<tr><th>Team Name</th><th>Score</th>");
  var pairs = _.pairs(data);
  pairs.sort(function(a, b) {
    if (a[1] < b[1]) {
      return 1;
    } else if (a[1] > b[1]) {
      return -1;
    } else {
      return 0;
    }
  });
  _.each(pairs, function(pair) {
    $("table#t01").append("<tr><td>"+pair[0]+"</td><td>"+pair[1]+"</td>");
  });
}

var getSliderValues = function() {
  var values = {
    "K-BB%": $("input:radio[name='kbb']:checked").val(),
    "WHIP": $("input:radio[name='whip']:checked").val(),
    "ERA": $("input:radio[name='era']:checked").val(),
    "RA9-WAR": $("input:radio[name='ra9war']:checked").val(),
    "OPS": $("input:radio[name='ops']:checked").val(),
    "Spd": $("input:radio[name='spd']:checked").val(),
    "R-diff": $("input:radio[name='rdiff']:checked").val()
  };
  return values;
};

$(document).ready(function() {
  $("input[type='radio']").on("click", function() {
    console.log("DOING IT");
    var values = getSliderValues();
    console.log(JSON.stringify(values));
    startSpinner();
    $.post("/ranking", values, function (data) {
      stopSpinner();
      updateTable(data);
    });
  });
});
