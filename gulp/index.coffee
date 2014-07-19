
# Module dependencies

watchify    = require "watchify"
browserSync = require "browser-sync"
gulp        = require "gulp"
notify      = require "gulp-notify"
source      = require "vinyl-source-stream"
AppBuilder  = require "./tools/appbuilder"

# Utils

onError = (args...) ->
  notify.onError(
    title: "Compile Error",
    message: "<%= error.message %>"
  ).apply(@, args)
  @emit('end')

# Tasks

app = new AppBuilder()

gulp.task "buildMarkup", -> app.buildMarkup()
gulp.task "buildScripts", -> app.buildScripts()
gulp.task "buildStyles", -> app.buildStyles()
gulp.task "buildAssets", -> app.buildAssets()
gulp.task "clean", -> app.clean()

gulp.task "build", [
  "buildMarkup"
  "buildScripts"
  "buildStyles"
  "buildAssets"
]

gulp.task "serve", ["build"], ->
  browserSync.init null,
    notify: false
    open: false
    host: "localhost"
    server:
      baseDir: "build"

gulp.task "watch", ["serve"], ->
  for name, list of app.watchList
    for pattern in list
      gulp.watch pattern, [name]
  browserSync.reload()

gulp.task 'default', ['watch']
