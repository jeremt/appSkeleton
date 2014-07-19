
# Module dependencies

watchify    = require "watchify"
browserSync = require "browser-sync"
gulp        = require "gulp"
notify      = require "gulp-notify"
source      = require "vinyl-source-stream"

# Utils

onError = (args...) ->
  notify.onError(
    title: "Compile Error",
    message: "<%= error.message %>"
  ).apply(@, args)
  @emit('end')

# Tasks

gulp.task "buildMarkup", ->
  gulp.src("app/index.html").pipe gulp.dest("build")

gulp.task "buildScripts", ->
  bundler = watchify(
    entries: ["./app/scripts/index.coffee"]
    extensions: [".coffee"]
  )
  bundle = ->
    bundler
      .bundle(debug: true)
      .on("error", onError)
      .pipe(source("all.js"))
      .pipe(gulp.dest("./build/"))
      .pipe(browserSync.reload(stream: true))
  bundler.on("update", bundle)
  bundle()

gulp.task "build", ["buildScripts", "buildMarkup"]

gulp.task "serve", ["build"], ->
  browserSync.init ["build/**"],
    server:
      baseDir: "build"

gulp.task "watch", ["serve"], ->
  gulp.watch "app/index.html", ["buildMarkup"]

gulp.task 'default', ['watch']
