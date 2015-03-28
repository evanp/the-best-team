express = require('express')
router = express.Router()

### GET home page. ###

router.get '/', (req, res) ->
  res.render 'index', title: 'The Best Team in Baseball'
  return

module.exports = router
