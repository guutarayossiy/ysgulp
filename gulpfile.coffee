gulp         = require 'gulp'
sass         = require 'gulp-sass'
browserSync  = require 'browser-sync'
plumber      = require 'gulp-plumber'
cssmin       = require 'gulp-cssmin'
cmq          = require 'gulp-combine-media-queries'
watch        = require 'gulp-watch'
coffee       = require 'gulp-coffee'
autoprefixer = require 'gulp-autoprefixer'
uglify       = require 'gulp-uglify'
rename       = require 'gulp-rename'
config       = require './gulpconfig'

#-----------------------
#sass
#-----------------------
gulp.task 'sass', ->
  gulp
    .src config.paths.src.scss
    .pipe plumber
      errorHandler: (err) ->
        console.log(err.messageFormatted)
        this.emit('end')
    .pipe sass
      outputStyle: 'compressed'
    .pipe autoprefixer
      browsers: ["last 2 versions", "ie >= 9", "Android >= 4","ios_saf >= 8"],
      cascade: false
    .pipe cmq
      log: true
    .pipe cssmin()
    .pipe gulp.dest(config.paths.dest.css)

#-----------------------
# CoffeeScript
#-----------------------
gulp.task 'coffee', ->
  gulp
    .src config.paths.src.coffee
    .pipe plumber
      errorHandler: (err) ->
        console.log(err.messageFormatted)
        this.emit('end')
    .pipe coffee()
    .pipe uglify
      preserveComments: 'some'
    .pipe rename
      suffix : '.min'
    .pipe gulp.dest(config.paths.dest.js)

#-----------------------
# browser-sync
#-----------------------
gulp.task 'browser-sync', ->
  browserSync.init
    server:
      baseDir: config.paths.base
    startPath: config.browsersync.startPath
    port: config.browsersync.port
    open: config.browsersync.open

#-----------------------
# ブラウザリロード
#-----------------------
gulp.task 'bs-reload', ->
  browserSync.reload()


#-----------------------
# media query整形
#-----------------------
gulp.task 'cmq',->
  gulp
    .src config.paths.src.css
    .pipe cmq
      log: true
    .pipe gulp.dest(config.cmq.destcss)


#-----------------------
# Watch
#-----------------------
gulp.task 'watch',['browser-sync','sass','coffee'],->
  watch [config.paths.src.scss], (event)->
    gulp.start 'sass'
  watch [config.paths.src.coffee], (event)->
    gulp.start 'coffee'
  watch [config.paths.src.html,config.paths.src.css], (event)->
    gulp.start 'bs-reload'
  watch [config.paths.src.js,config.paths.src.php], (event)->
    gulp.start 'bs-reload'

#-----------------------
# デフォルトタスク
#-----------------------
gulp.task 'default', ->
  gulp.run 'watch'
