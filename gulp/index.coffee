
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

# App
gulp.task "buildMarkup", -> app.buildMarkup()
gulp.task "buildBrowserify", -> app.buildBrowserify()
gulp.task "buildStyles", -> app.buildStyles()
gulp.task "buildAssets", -> app.buildAssets()
gulp.task "buildBower", -> bower().pipe(gulp.dest('build'))
gulp.task "cleanApp", -> app.clean()
gulp.task "buildApp", [
  "buildMarkup"
  "buildBrowserify"
  "buildStyles"
  "buildAssets"
  "buildBower"
]

# Doc
gulp.task "buildApi", -> doc.buildApi()
gulp.task "buildTutorials", -> doc.buildTutorials()
gulp.task "buildDoc", ["buildApi", "buildTutorials"]

# Common
gulp.task "build", ["buildApp", "buildDoc"]

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

gulp.task 'default', ['watch']
