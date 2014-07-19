
# This builder take care of the generation of all documentation files.
# It will generate coffeescript code documentation as well as building the
# tutorials which are written in markdown.
class DocBuilder

  DEFAULT_OPTIONS =
    scriptFolder: "./app/scripts"
    markdownFolder: "./documentation"

  constructor: (options) ->
    @options = DEFAULT_OPTIONS
    for key, value of options
      @options[key] = value

module.exports = DocBuilder