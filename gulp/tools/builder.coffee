
# Module dependencies

gulp        = require "gulp"
path        = require "path"
watchify    = require "watchify"
browserSync = require "browser-sync"
source      = require "vinyl-source-stream"

jade        = require "gulp-jade"
notify      = require "gulp-notify"

# Utility to make easier building tasks for a web application. It provides
# features to build:
#
# - coffeescript scripts (with browserify)
# - stylus stylesheets
# - fonts & images
#
class Builder

  DEFAULT_OPTIONS =
    src: "./app"
    dest: "./build"

  # Create the builder.
  #
  # @param {String} folder contains all the source files
  # @param {Object} options optional settings for building
  #
  constructor: (options = {}, @locals = {}) ->
    @watchList = {}
    @options = DEFAULT_OPTIONS
    for key, opt of options
      @options[key] = opt

  buildMarkup: (kw = {}) ->
    @addFiles('Markup', kw.partials ? ["partials/**/*.jade"])
    pages = @addFiles('Markup', kw.pages ? ["index.jade", "pages/**/*.jade"])
    gulp.src(pages)
      .pipe(jade(basedir: @options.src, locals: @locals)
        .on('error', @handleError))
      .pipe(gulp.dest(@options.dest))
      .pipe(browserSync.reload(stream: true))

  # Build scripts from the given root script.
  #
  # @param {String} entry the entry point to create browserify module
  #
  buildScripts: (entry = "scripts/index.coffee") ->
    bundler = watchify(
      entries: ["./" + path.join(@options.src, entry)]
      extensions: [".coffee"]
    )
    bundle = =>
      bundler
        .bundle(debug: true)
        .on("error", @handleError)
        .pipe(source("all.js"))
        .pipe(gulp.dest(@options.dest))
    bundler.on("update", bundle)
    bundle()

  addFiles: (rule, files) ->
    @watchList["build#{rule}"] = (@watchList["build#{rule}"] ? []).concat(
      path.join(@options.src, f) for f in files
    )

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
