path       = require 'path'
gulp       = require 'gulp'
# nib        = require 'nib'
CSSmin     = require 'gulp-minify-css'
uglify     = require 'gulp-uglify'
coffee     = require 'gulp-coffee'
coffeeify  = require 'coffeeify'
ecstatic   = require 'ecstatic'
livereload = require 'gulp-livereload'
prefix     = require 'gulp-autoprefixer'
lr         = require 'tiny-lr'
reloadServer = lr()
$ = require('gulp-load-plugins')()

production = process.env.NODE_ENV is 'production'

paths =
  scripts:
    source: './src/app/**/*.coffee'
    watch: './src/app/*.coffee'
    destination: './public/js/'
  templates:
    source: './src/templates/**/*.html'
    watch: './src/templates/**/*.html'
  styles:
    source: './src/stylus/style.styl'
    watch: './src/stylus/*.styl'
    destination: './public/css/'
  assets:
    source: './src/assets/**/*.*'
    watch: './src/assets/**/*.*'
    destination: './public/'

handleError = (err) ->
  $.util.log err
  $.util.beep()
  this.emit('end')

gulp.task 'scripts', ->
  scripts = gulp.src(paths.scripts.source)
    .pipe($.ngClassify(
      appName: 'ham'
    ))
    .pipe($.coffee(bare: false).on('error', handleError))
    # make sure ham app is first module initialized
    .pipe($.order(['main.js']))
    .pipe($.concat("app.js"))
  scripts = scripts.pipe($.uglify()) if production
  scripts.pipe(gulp.dest(paths.scripts.destination))
    .pipe livereload reloadServer

gulp.task 'templates', ->
  gulp
    .src paths.templates.source
    .pipe($.angularTemplatecache(
      module: 'ham'
    ))
    .on 'error', handleError
    .pipe gulp.dest paths.scripts.destination
    .pipe livereload(reloadServer)

gulp.task 'styles', ->
  styles = gulp
    .src paths.styles.source
    .pipe($.stylus({
      set: ['include css']
      use: ['nib']
    }))
    .on 'error', handleError
    .pipe prefix 'last 2 versions', 'Chrome 34', 'Firefox 28', 'iOS 7'

  styles = styles.pipe(CSSmin()) if production

  styles.pipe gulp.dest paths.styles.destination
    .pipe livereload reloadServer

gulp.task 'assets', ->
  gulp
    .src paths.assets.source
    .pipe gulp.dest paths.assets.destination
    .pipe livereload(reloadServer)

gulp.task 'server', ->
  require('http')
    .createServer ecstatic(root: __dirname + '/public')
    .listen 9001

gulp.task "watch", ->
  reloadServer.listen 35729

  gulp.watch paths.templates.watch, ['templates']
  gulp.watch paths.scripts.watch, ['scripts']
  gulp.watch paths.styles.watch, ['styles']
  gulp.watch paths.assets.watch, ['assets']

# TODO: test
gulp.task 'deploy', ->
  gulp.src("./public/**/*")
    .pipe($.ghPages())

gulp.task 'js_libs', ->
  list = [
    './bower_components/angular/angular.js'
    './bower_components/angularjs-geolocation/src/geolocation.js'
    './bower_components/angular-ui-router/release/angular-ui-router.js'
  ]
  gulp
    .src(list)
    .on 'error', handleError
    .pipe gulp.dest paths.scripts.destination + 'libs/'

gulp.task "build", ['scripts', 'templates', 'styles', 'assets', 'js_libs']
gulp.task "default", ["build", "watch", "server"]
