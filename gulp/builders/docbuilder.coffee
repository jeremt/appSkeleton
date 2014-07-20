
#
# Module dependencies
#
gulp        = require 'gulp'
fs          = require 'fs'
path        = require 'path'
markdown    = require 'gulp-markdown'
codo        = require '../tools/codohelper'

# This builder take care of the generation of all documentation files.
# It will generate coffeescript code documentation as well as building the
# tutorials which are written in markdown.
#
class DocBuilder

  DEFAULT_OPTIONS =
    codo:
      theme: 'default'
    tutorials:
      src: "./tutorials/"
      dest: "./build/documentation/tutorials"
    api:
      src: "./app/scripts"
      dest: "./build/documentation/api"

  # Instanciate the builder and set its options.
  #
  # @param {Object} options various options to configure the builder
  #
  constructor: (options) ->
    @options = DEFAULT_OPTIONS
    for key, value of options
      @options[key] = value

  # Build the tutorials files from markdown into html.
  #
  # @param {String} src the source markdown files to build
  # @param {String} dest the destination folder of the files
  #
  buildTutorials: ({src, dest} = {}) ->
    src ?= DEFAULT_OPTIONS.tutorials.src
    dest ?= DEFAULT_OPTIONS.tutorials.dest
    console.log fs.readdirSync(src)
    gulp.src(path.join(src, "**/*.md"))
      .pipe(markdown())
      .pipe(gulp.dest(dest))

  # Build the api documentation from the documented source code.
  #
  # @param {String} src the folder in which all source files are stored
  # @param {String} dest the destination folder of the generated documentation
  #
  buildApi: ({src, dest} = {}) ->
    src ?= DEFAULT_OPTIONS.api.src
    dest ?= DEFAULT_OPTIONS.api.dest
    codo(src: src, output: dest)

module.exports = DocBuilder