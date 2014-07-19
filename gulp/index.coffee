
# Module dependencies

watchify    = require "watchify"
browserSync = require "browser-sync"
gulp        = require "gulp"
notify      = require "gulp-notify"
source      = require "vinyl-source-stream"
Builder     = require "./tools/builder"

# Utils

onError = (args...) ->
  notify.onError(
    title: "Compile Error",
    message: "<%= error.message %>"
  ).apply(@, args)
  @emit('end')

# Tasks

app = new Builder()

gulp.task "buildMarkup", -> app.buildMarkup()
  # gulp.src("app/index.html").pipe gulp.dest("build")

gulp.task "buildScripts", -> app.buildScripts()

gulp.task "build", ["buildScripts", "buildMarkup"]

gulp.task "serve", ["build"], ->
  browserSync.init ["build/**"],
    server:
      baseDir: "build"

gulp.task "watch", ["serve"], ->
  console.log app.watchList
  for name, list of app.watchList
    for pattern in list
      gulp.watch pattern, [name]

gulp.task 'default', ['watch']
