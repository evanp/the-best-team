fs = require "fs"

csv2object = (filename, callback) ->

  noFirstLine = true

  stream = fs.createReadStream filename
  pipe = stream.pipe split()
  fieldNames = null
  map = {}

  pipe.on 'error', (err) ->
    callback err

  pipe.on 'data', (line) ->

    if noFirstLine
      imFirst = true
      noFirstLine = false
    else
      imFirst = false
    csv.parse line, (err, data) ->
      if err
        callback err
      else
        fields = data[0]
        if imFirst
          fieldNames = fields
        else
          map[fields[0]] = _.zipObject(fieldNames, fields)

  pipe.on 'end', () ->
    callback null, map

module.exports = csv2object
