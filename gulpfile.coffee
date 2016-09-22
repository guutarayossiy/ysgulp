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
# path
#-----------------------
path_src_html   = config.paths.base + config.paths.src.html
path_src_css    = config.paths.base + config.paths.src.css
path_src_js     = config.paths.base + config.paths.src.js
path_src_scss   = config.paths.base + config.paths.src.scss
path_src_coffee = config.paths.base + config.paths.src.coffee
path_src_php    = config.paths.base + config.paths.src.php

path_dest_css   = config.paths.base + config.paths.dest.css
path_dest_js   = config.paths.base + config.paths.dest.js
path_dest_cmq   = config.paths.base + config.cmq.destcss


#-----------------------
#sass
#-----------------------
gulp.task 'sass', ->
  gulp
    .src path_src_scss
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
    .pipe gulp.dest(path_dest_css)

#-----------------------
# CoffeeScript
#-----------------------
gulp.task 'coffee', ->
  gulp
    .src path_src_coffee
    .pipe plumber
      errorHandler: (err) ->
        console.log(err.messageFormatted)
        this.emit('end')
    .pipe coffee()
    .pipe uglify
      preserveComments: 'some'
    .pipe rename
      suffix : '.min'
    .pipe gulp.dest(path_dest_js)

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
    .src path_src_css
    .pipe cmq
      log: true
    .pipe gulp.dest(path_dest_cmq)


#-----------------------
# Watch
#-----------------------
gulp.task 'watch',['browser-sync','sass','coffee'],->
  watch [path_src_scss], (event)->
    gulp.start 'sass'
  watch [path_src_coffee], (event)->
    gulp.start 'coffee'
  watch [path_src_html,path_src_css], (event)->
    gulp.start 'bs-reload'
  watch [path_src_js,path_src_php], (event)->
    gulp.start 'bs-reload'

#-----------------------
# デフォルトタスク
#-----------------------
gulp.task 'default', ->
  gulp.run 'watch'
