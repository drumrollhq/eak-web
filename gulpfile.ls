require! {
  'glob'
  'gulp'
  'gulp-html-extend'
  'gulp-livescript'
  'gulp-minify-css'
  'gulp-minify-html'
  'gulp-rev-all'
  'gulp-stylus'
  'gulp-uglify'
  'gulp-uncss'
  'gulp-usemin'
  'nib'
  'path'
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

gulp.task 'usemin' ['build'] ->
  gulp.src 'public/**/*.html'
    .pipe gulp-usemin {
      path: './public/'
      css: [gulp-minify-css!, 'concat']
      js: [gulp-uglify!, 'concat']
    }
    .pipe gulp.dest 'public/'

gulp.task 'minify-html' ->
  gulp.src 'public/**/*.html'
    .pipe gulp-minify-html!
    .pipe gulp.dest 'public/'

gulp.task 'optimize-css-landing' ->
  gulp.src 'public/landing/*.css'
    .pipe gulp-uncss {
      html: glob.sync 'public/landing/*.html'
      ignore: [/active/, /hover/]
    }
    .pipe gulp-minify-css!
    .pipe gulp.dest 'public/landing/'

gulp.task 'css' ->
  gulp.src 'src/**/*.styl'
    .pipe gulp-stylus {
      use: [nib!]
      'include css': true
    }
    .pipe gulp.dest 'public/'

gulp.task 'rev' ->
  gulp.src ['public/**', '!public/**/*.static.*']
    .pipe gulp-rev-all {
      ignore: [/.html$/]
      transform-filename: (file, hash) ->
        ext = path.extname file.path
        return "#{path.basename file.path, ext}.#{hash.substr 0, 8}.static#{ext}"
    }
    .pipe gulp.dest 'public/'

gulp.task 'livescript' ->
  gulp.src 'src/**/*.ls'
    .pipe gulp-livescript!
    .pipe gulp.dest 'public/'

gulp.task 'watch' ['default'] ->
  gulp.watch 'src/**/*.html', ['html']
  gulp.watch 'src/**/*.styl', ['css']
  gulp.watch 'src/**/*.ls', ['livescript']
  gulp.watch 'assets/**/*.*', ['assets']

gulp.task 'assets' -> gulp.src 'assets/**/*.*' .pipe gulp.dest 'public/'

gulp.task 'build' (cb) -> run-sequence 'html', 'css', 'livescript', 'assets', cb
gulp.task 'optimize' (cb) -> run-sequence 'clean', 'usemin', 'optimize-css-landing', 'rev', 'minify-html', 'rev', cb
gulp.task 'default' (cb) -> run-sequence 'clean', 'build', cb
