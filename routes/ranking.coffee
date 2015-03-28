express = require('express')
FuzzyIOClient = require('fuzzy.io')
_ = require("lodash")
router = express.Router()

nameToWeight = (name) ->
  switch name.toUpperCase()
    case "IGNORE":
      0
    case "LOW":
      0.25
    case "MEDIUM":
      0.5
    case "HIGH":
      1.0
    else:
      0

inverted = (parameter) ->
  switch parameter
    when "WHIP":
      true
    when "ERA":
      true
    else
      false

makeModel = (parameters) ->
  model =
    inputs:
      "K-BB%":
        veryLow: [0, 4]
        low: [0, 4, 6]
        moderate: [4, 6, 8]
        high: [6, 8, 10]
        veryHigh: [8, 10]
      "WHIP":
        veryLow: [1.2, 1.35]
        low: [1.2, 1.35, 1.4]
        moderate: [1.35, 1.4, 1.5]
        high: [1.4, 1.5, 1.6]
        veryHigh: [1.5, 1.6]
      "ERA":
        veryLow: [3.5, 4.0]
        low: [3.5, 4.0, 4.5]
        moderate: [4.0, 4.5, 5.0]
        high: [4.5, 5.0, 5.75]
        veryHigh: [5.0, 5.75]
      "RA9-WAR":
        veryLow: [-1, 5]
        low: [-1, 5, 10]
        moderate: [5, 10, 15]
        high: [10, 15, 20]
        veryHigh: [15, 20]
      "OPS":
        veryLow: [0.7, 0.73]
        low: [0.7, 0.73, 0.76]
        moderate: [0.73, 0.76, 0.79]
        high: [0.76, 0.79, 0.84]
        veryHigh: [0.79, 0.84]
      "Spd":
        veryLow: [3.5, 4.1]
        low: [3.5, 4.1, 4.7]
        moderate: [4.1, 4.7, 5.3]
        high: [4.7, 5.3, 5.9]
        veryHigh: [5.3, 5.9]
      "R-diff":
        veryLow: [-120, -55]
        low: [-120, -55, 10]
        moderate: [-55, 10, 75]
        high: [10, 75, 140]
        veryHigh: [75, 140]
    outputs:
      score:
        veryLow: [0, 2]
        low: [0, 2, 3, 5]
        moderate: [3, 5, 7]
        high: [5, 7, 8, 10]
        veryHigh: [8, 10]
    rules: []
  for parameter, weightName of parameters
    weight = nameToWeight weightName
    opposites =
      veryLow: veryHigh
      low: high
      moderate: moderate
      high: low
      veryHigh: veryLow
    for set of ["veryLow", "low", "moderate", "high", "veryHigh"]
      if inverted(parameter)
        scoreSet = opposites[set]
      else
        scoreSet = set
      rule = "IF #{parameter} IS #{set} THEN score IS #{scoreSet} WEIGHT #{weight}"
      model.rules.push rule
  model

### GET users listing. ###

router.get '/', (req, res, next) ->
  parameters = req.body
  model = makeModel parameters
  client = new FuzzyIOClient(process.env.FUZZY_IO_API_KEY)
  teamData = req.app.teamData
  teams = _.keys teamData
  client.newAgent model, (err, agent) ->
    if err
      next err
    else
      teamScore = (team, callback) ->
        inputs = teamData[team]
        client.evaluate agent.id, inputs, (err, outputs) ->
          if err
            callback err
          else
            callback null, outputs.score
      async.map teams, teamScore, (err, scores) ->
        if err
          next err
        else
          map = _.zipObject(teams, scores)
          res.json map

module.exports = router
