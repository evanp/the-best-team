debug = require('debug')('my-application')
csv2object = require("../lib/csv2object")

csv2object "../data/1994_combined_stats.csv", (err, map) ->
  if err
    console.error err
    process.exit -1
  else
    app = require('../app')
    app.set 'port', process.env.PORT or 3000
    app.teamData = map
    server = app.listen(app.get('port'), ->
      debug 'Express server listening on port ' + server.address().port
      return
    )
