gulp        = require('gulp')
compass     = require('gulp-compass')
browserSync = require('browser-sync')
plumber     = require('gulp-plumber')
cmq         = require('gulp-combine-media-queries')
watch       = require('gulp-watch')
coffee      = require('gulp-coffee')
config      = require('./gulpconfig')

#compass
gulp.task 'compile-compass', ->
  gulp
    .src config.paths.src.scss
    .pipe plumber
      errorHandler: (err) ->
        console.log(err.messageFormatted)
        this.emit('end')
    .pipe compass
      config_file:config.compass.configrb

# CoffeeScript
gulp.task 'compile-coffee', ->
  gulp
    .src config.paths.src.coffee
    .pipe plumber
      errorHandler: (err) ->
        console.log(err.messageFormatted)
        this.emit('end')
    .pipe coffee()
    .pipe gulp.dest(config.paths.dist.js)


# browser-sync
gulp.task 'browser-sync', ->
  browserSync.init
    server:
      baseDir: config.paths.base
    startPath: config.browsersync.startPath
    port: config.browsersync.port
    open: config.browsersync.open

# ブラウザリロード
gulp.task 'bs-reload', ->
  browserSync.reload()


# CSSの仕上げ
gulp.task 'cmq',->
  gulp
    .src config.paths.src.css
    .pipe cmq
      log: true
    .pipe gulp.dest(config.paths.cmq.distcss)


# Watch
gulp.task 'watch',['browser-sync'],->
  watch [config.paths.src.scss], (event)->
    gulp.start 'compile-compass'
  watch [config.paths.src.coffee], (event)->
    gulp.start 'compile-coffee'
  watch [config.paths.src.html,config.paths.src.css], (event)->
    gulp.start 'bs-reload'
  watch [config.paths.src.js,config.paths.src.php], (event)->
    gulp.start 'bs-reload'

# デフォルトタスク
gulp.task 'default', ->
  gulp.run 'watch'
