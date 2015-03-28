$(document).ready ->
  $(".slider").change ->
    values = getSliderValues()
    startSpinner()
    $.post "/ranking", values, (data) ->
      stopSpinner()
      updateTable data
