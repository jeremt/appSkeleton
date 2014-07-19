
# Module dependencies

watchify    = require "watchify"
browserSync = require "browser-sync"
gulp        = require "gulp"
notify      = require "gulp-notify"
source      = require "vinyl-source-stream"

# Utility to make easier building tasks for a web application. It provides
# features to build:
#
# - coffeescript scripts (with browserify)
# - stylus stylesheets
# - fonts & images
#
class Builder

  # Create the builder.
  #
  # @param {String} folder contains all the source files
  # @param {Object} options optional settings for building
  #
  constructor: (@folder = "app", @options = {}) ->

  # Build scripts from the given root script.
  #
  # @param {String} root the entry point to create browserify module
  #
  buildScripts: (@root = "scripts/index.coffee") ->
    bundler = watchify(
      entries: ["./app/scripts/index.coffee"]
      extensions: [".coffee"]
    )
    bundle = =>
      bundler
        .bundle(debug: true)
        .on("error", @handleError)
        .pipe(source("all.js"))
        .pipe(gulp.dest("./build/"))
    bundler.on("update", bundle)
    bundle()

  # Notify the error and end the current task.
  #
  # @param {Any...} args the arguments of the notification callback
  #
  handleError: (args...) ->
    notify.onError(
      title: "Compile Error",
      message: "<%= error.message %>"
    ).apply(@, args)
    @emit('end')

module.exports = Builder
