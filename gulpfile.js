const gulp = require("gulp");
const ts = require("gulp-typescript");
const fs = require("fs");
const path = require("path");
const merge = require("merge-stream");
const concat = require("gulp-concat");

let folders = ["src/[core]/[nui]"];

// [essential]/ilog -> [[]essential]/ilog
// [essential]/[essential]/ilog -> [[]essential]/[[]essential]/ilog
const escapeBracketPath = path =>
  path
    .split("[")
    .map((val, i) => (i != 0 ? `[]${val}` : val))
    .join("[");

gulp.task('build', () => {
  let tasks = [];

  // For each resource path in folder:
  folders.map(el => {
    // If there's a server folder
    console.log(escapeBracketPath(el));
    if (fs.existsSync(path.join("src", el, "server"))) {
      tasks.push(
        gulp
          .src(`src/${escapeBracketPath(el)}/server/**/*.ts`)
          .pipe(
            ts({
              noImplicitAny: true,
              module: "commonjs"
            })
          )
          .pipe(concat("main_server.js"))
          .pipe(gulp.dest(`resources/${el}/server/`))
      );
    }
    // If there's a client folder
    if (fs.existsSync(path.join("src", el, "client"))) {
      tasks.push(
        gulp
          .src(`src/${escapeBracketPath(el)}/client/**/*.ts`)
          .pipe(
            ts({
              noImplicitAny: true,
              module: "system",
              outFile: "client_main.js"
            })
          )
          .pipe(concat("main_client.js"))
          .pipe(gulp.dest(`resources/${el}/client/`))
      );
    }
    // Copy the fxmanifest.lua
    tasks.push(
      gulp
        .src(`src/${escapeBracketPath(el)}/fxmanifest.lua`)
        .pipe(gulp.dest(`resources/`))
    );
  });

  // Merge all steams together
  return merge(tasks);
});

// Make the default task run build. "gulp" does the work
gulp.task('default', gulp.series('build'));