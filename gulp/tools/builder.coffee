
# Module dependencies

gulp        = require "gulp"
path        = require "path"
watchify    = require "watchify"
browserSync = require "browser-sync"
source      = require "vinyl-source-stream"

jade        = require "gulp-jade"
stylus      = require "gulp-stylus"
notify      = require "gulp-notify"

# Utility to make easier building tasks for a web application. It provides
# features to build:
#
# - coffeescript scripts (with browserify)
# - stylus stylesheets
# - fonts & images
#
class Builder

  ASSETS_EXTENSIONS = [
    "png", "jpg", "jpeg", "gif" # images
    "eot", "svg", "ttf", "woff" # fonts
  ]

  DEFAULT_OPTIONS =
    src: "./app"
    dest: "./build"

  # Create the builder.
  #
  # @param {Object} options optional configuration (see DEFAUT_OPTIONS)
  # @param {Object} locals some variables to use in template files
  #
  constructor: (options = {}, @locals = {}) ->
    @watchList = {}
    @options = DEFAULT_OPTIONS
    for key, opt of options
      @options[key] = opt

  # Build the markup files and add them to the watchlist.
  #
  # @param {Object} kw some keywork arguments
  # @option kw {Array<String>} pages some pages to compiles
  # @option kw {Array<String>} partials partials files which aren't compiled
  #
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
        .pipe(source("index.js"))
        .pipe(gulp.dest(@options.dest))
        .pipe(browserSync.reload({stream:true, once: true}))
    bundler.on("update", bundle)
    bundle()

  # Build css from the given stylus files.
  #
  # @param {String} entry the entry point of the stylesheets
  # @param {Array<String>} styles the list of stylesheets to watch
  #
  buildStyles: (entry = "styles/index.styl", styles) ->
    @addFiles('Styles', styles ? ["styles/**/*.styl"])
    gulp.src(path.join(@options.src, entry))
      .pipe(stylus().on('error', @handleError))
      .pipe(gulp.dest(@options.dest))
      .pipe(browserSync.reload(stream: true))

  # Add the root paths to the given `files`, and add them to the watchList.
  #
  # @param rule {String> the watchlist's rule name to update
  # @param files {Array<String>} the files to add
  #
  addFiles: (rule, files) ->
    throw new Error "Please, provide files to add." if not files?
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
