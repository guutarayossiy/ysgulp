(function() {
  var autoprefixer, browserSync, cmq, coffee, config, cssmin, gulp, plumber, sass, watch;

  gulp = require('gulp');

  sass = require('gulp-sass');

  browserSync = require('browser-sync');

  plumber = require('gulp-plumber');

  cssmin = require('gulp-cssmin');

  cmq = require('gulp-combine-media-queries');

  watch = require('gulp-watch');

  coffee = require('gulp-coffee');

  autoprefixer = require('gulp-autoprefixer');

  config = require('./gulpconfig');

  gulp.task('compile-sass', function() {
    return gulp.src(config.paths.src.scss).pipe(plumber({
      errorHandler: function(err) {
        console.log(err.messageFormatted);
        return this.emit('end');
      }
    })).pipe(sass({
      outputStyle: 'compressed'
    })).pipe(autoprefixer({
      browsers: ["last 2 versions", "ie >= 9", "Android >= 4", "ios_saf >= 8"],
      cascade: false
    })).pipe(cmq({
      log: true
    })).pipe(cssmin()).pipe(gulp.dest(config.paths.dest.css));
  });

  gulp.task('compile-coffee', function() {
    return gulp.src(config.paths.src.coffee).pipe(plumber({
      errorHandler: function(err) {
        console.log(err.messageFormatted);
        return this.emit('end');
      }
    })).pipe(coffee()).pipe(gulp.dest(config.paths.dest.js));
  });

  gulp.task('browser-sync', function() {
    return browserSync.init({
      server: {
        baseDir: config.paths.base
      },
      startPath: config.browsersync.startPath,
      port: config.browsersync.port,
      open: config.browsersync.open
    });
  });

  gulp.task('bs-reload', function() {
    return browserSync.reload();
  });

  gulp.task('cmq', function() {
    return gulp.src(config.paths.src.css).pipe(cmq({
      log: true
    })).pipe(gulp.dest(config.cmq.destcss));
  });

  gulp.task('watch', ['browser-sync', 'compile-sass'], function() {
    watch([config.paths.src.scss], function(event) {
      return gulp.start('compile-sass');
    });
    watch([config.paths.src.coffee], function(event) {
      return gulp.start('compile-coffee');
    });
    watch([config.paths.src.html, config.paths.src.css], function(event) {
      return gulp.start('bs-reload');
    });
    return watch([config.paths.src.js, config.paths.src.php], function(event) {
      return gulp.start('bs-reload');
    });
  });

  gulp.task('default', function() {
    return gulp.run('watch');
  });

}).call(this);
