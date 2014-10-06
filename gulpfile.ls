require! {
  'glob'
  'gulp'
  'gulp-html-extend'
  'gulp-minify-css'
  'gulp-minify-html'
  'gulp-rev'
  'gulp-stylus'
  'gulp-uglify'
  'gulp-uncss'
  'gulp-usemin'
  'nib'
  'rimraf'
  'run-sequence'
}

gulp.task 'clean' (cb) ->
  rimraf './public', cb

gulp.task 'html' ->
  gulp.src ['src/**/*.html', '!src/partials/*.html']
    .pipe gulp-html-extend!
    .on 'error' -> throw it
    .pipe gulp.dest 'public/'

gulp.task 'optimize-html' ['build'] ->
  gulp.src 'public/**/*.html'
    .pipe gulp-usemin {
      path: './public/'
      css: [gulp-minify-css!, 'concat', gulp-rev!]
      js: [gulp-uglify!, 'concat', gulp-rev!]
    }
    .pipe gulp-minify-html!
    .pipe gulp.dest 'public/'

gulp.task 'optimize-css-landing' ->
  gulp.src 'public/landing/*.css'
    .pipe gulp-uncss html: glob.sync 'public/landing/*.html'
    .pipe gulp-minify-css!
    .pipe gulp.dest 'public/landing/'

gulp.task 'css' ->
  gulp.src 'src/**/*.styl'
    .pipe gulp-stylus {
      use: [nib!]
      'include css': true
    }
    .pipe gulp.dest 'public/'

gulp.task 'watch' ['default'] ->
  gulp.watch 'src/**/*.html', ['html']
  gulp.watch 'src/**/*.styl', ['css']
  gulp.watch 'assets/**/*.*', ['assets']

gulp.task 'assets' -> gulp.src 'assets/**/*.*' .pipe gulp.dest 'public/'

gulp.task 'build' (cb) -> run-sequence 'html', 'css', 'assets', cb
gulp.task 'optimize' (cb) -> run-sequence 'clean', 'optimize-html', 'optimize-css-landing', cb
gulp.task 'default' (cb) -> run-sequence 'clean', 'build', cb
