
fs         = require 'fs'
AppBuilder = require './appbuilder'

# Handle unittests of the application and also create some demos examples
# using other buiders.
#
class TestBuilder

  DEFAULT_OPTIONS =
    examples: 

  constructor: ->

  runTests: ->

  buildExamples: ({root, builder} = {root: 'examples', builder: AppBuilder}) ->
    examples = fs.readdirSync(root)
    for example in examples
      console.log example

module.exports = TestBuilder