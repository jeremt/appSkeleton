
#
# Module dependencies
#

gulp        = require "gulp"
path        = require "path"
browserSync = require "browser-sync"

# Utils
notify      = require "gulp-notify"
clean       = require "gulp-clean"

# Scripts
watchify    = require "watchify"
source      = require "vinyl-source-stream"
coffee      = require "gulp-coffee"
sourcemaps  = require "gulp-sourcemaps"

# Markup
jade        = require "gulp-jade"

# Style
stylus      = require "gulp-stylus"
prefix      = require "gulp-autoprefixer"

# Utility to make easier building tasks for a web application. It provides
# features to build:
#
# - coffeescript scripts (with browserify)
# - stylus stylesheets
# - fonts & images
#
class AppBuilder

  DEFAULT_ASSETS_EXTENSIONS = [
    "png", "jpg", "jpeg", "gif" # images
    "eot", "svg", "ttf", "woff" # fonts
    "json", "xml", "cson"       # config
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
    @options = Object.create(DEFAULT_OPTIONS)
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
  buildBrowserify: (entry = "scripts/index.coffee") ->
    bundler = watchify(
      transform: ['coffeeify']
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

  # Build scripts without using browserify.
  #
  # @param {Array<String>} scripts all the scripts files to compile
  #
  buildScripts: (scripts = ["scripts/**/*.coffee"]) ->
    scripts = @addFiles('Scripts', scripts)
    gulp.src(scripts)
      .pipe(sourcemaps.init())
      .pipe(coffee(bare: true).on('error', @handleError))
      .pipe(sourcemaps.write())
      .pipe(gulp.dest(@options.dest))

  # Build css from the given stylus files.
  #
  # @param {String} entry the entry point of the stylesheets
  # @param {Array<String>} styles the list of stylesheets to watch
  #
  buildStyles: (entry = "styles/index.styl", styles = ["styles/**/*.styl"]) ->
    @addFiles('Styles', styles)
    gulp.src(path.join(@options.src, entry))
      .pipe(stylus().on('error', @handleError))
      .pipe(prefix())
      .pipe(gulp.dest(@options.dest))
      .pipe(browserSync.reload(stream: true))

  # Move the assets of the application into the build folder.
  #
  # @param {String} folder application's folder which contains all assets
  # @param {Array<String>} ext the allowed extensions to copy
  #
  buildAssets: (folder = "assets/", {include, exclude} = {}) ->
    # TODO handle include and exclude extensions...
    ext = DEFAULT_ASSETS_EXTENSIONS
    assets = @addFiles('Assets', ["#{folder}/**/*.{#{ext.join(',')}}"])
    gulp.src(assets)
      .pipe(gulp.dest(path.join(@options.dest, folder)))

  build: ->
    @buildMarkup()
    @buildBrowserify()
    @buildStyles()
    @buildAssets()

  # Remove the build folder and all the files inside recursively.
  #
  clean: ->
    gulp.src(path.join(@options.dest, "**/*"), read: false)
      .pipe(clean())

  # Add the root paths to the given `files`, and add them to the watchList.
  #
  # @param rule {String> the watchlist's rule name to update
  # @param files {Array<String>} the files to add
  #
  addFiles: (rule, files) ->
    throw new Error "Please, provide files to add." if not files?
    files = (path.join(@options.src, f) for f in files)
    @watchList["build#{rule}"] = (@watchList["build#{rule}"] ? [])
      .concat(files)
    files

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

module.exports = AppBuilder
