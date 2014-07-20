
# Module dependencies

gulp        = require "gulp"
bower       = require "gulp-bower"
browserSync = require "browser-sync"
AppBuilder  = require "./builders/appbuilder"
DocBuilder  = require "./builders/docbuilder"

# Builders

app = new AppBuilder()
doc = new DocBuilder()

# Tasks

gulp.task "buildMarkup", -> app.buildMarkup()
gulp.task "buildBrowserify", -> app.buildBrowserify()
gulp.task "buildStyles", -> app.buildStyles()
gulp.task "buildAssets", -> app.buildAssets()
gulp.task "clean", -> app.clean()
gulp.task "buildBower", -> bower().pipe(gulp.dest('build'))

gulp.task "buildApi", -> doc.buildApi()
gulp.task "buildTutorials", -> doc.buildTutorials()
gulp.task "buildDocumentation", ["buildApi", "buildTutorials"]

gulp.task "build", [
  "buildMarkup"
  "buildBrowserify"
  "buildStyles"
  "buildAssets"
  "buildBower"
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
  # browserSync.reload()

gulp.task 'default', ['watch']
