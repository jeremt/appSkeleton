
#
# Module dependencies
#
gulp        = require 'gulp'
gutil       = require 'gulp-util'
fs          = require 'fs'
path        = require 'path'
markdown    = require 'gulp-markdown'
spawn       = require('child_process').spawn

# This builder take care of the generation of all documentation files.
# It will generate coffeescript code documentation as well as building the
# tutorials which are written in markdown.
#
class DocBuilder

  DEFAULT_OPTIONS =
    src: "."
    dest: "./build"
    codo:
      theme: 'default'
    tutorials:
      config: "tutorials/config.json"
      src: ["tutorials/**/*.md"]
      dest: "documentation/tutorials"
    api:
      src: ["app/scripts"]
      dest: "documentation/api"

  # Instanciate the builder and set its options.
  #
  # @param {Object} options various options to configure the builder
  #
  constructor: (options = {}) ->
    @watchList = {}
    @options = Object.create(DEFAULT_OPTIONS)
    for key, value of options
      @options[key] = value

  # Build the tutorials files from markdown into html.
  #
  # @param {String} src the source markdown files to build
  # @param {String} dest the destination folder of the files
  #
  buildTutorials: ({src, dest, config} = {}) ->
    src = @addFiles('Tutorials', src ? DEFAULT_OPTIONS.tutorials.src)
    config = @addFiles('Tutorials', [config ? DEFAULT_OPTIONS.tutorials.config])
    dest ?= DEFAULT_OPTIONS.tutorials.dest
    gulp.src(config)
      .pipe(gulp.dest(path.join(@options.dest, dest)))
    gulp.src(src)
      .pipe(markdown())
      .pipe(gulp.dest(path.join(@options.dest, dest)))

  # Build the api documentation from the documented source code.
  #
  # @param {String} src the folder in which all source files are stored
  # @param {String} dest the destination folder of the generated documentation
  #
  buildApi: ({src, dest} = {}) ->
    src = @addFiles('Api', src ? DEFAULT_OPTIONS.api.src)
    dest ?= DEFAULT_OPTIONS.api.dest
    stream = spawn('codo', [src, '--output', path.join(@options.dest, dest)])
    stream.on 'close', ->
      gutil.log("Generated codo documentation to '#{dest}'")

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

module.exports = DocBuilder