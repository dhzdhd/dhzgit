import filepath
import gleam/result
import models/error.{type AppError}
import models/repository.{type Repository, Repository}
import simplifile as fs

pub fn cmd_init(raw_path: String, force: Bool) -> Result(Repository, AppError) {
  let path = filepath.join(raw_path, ".git")

  use is_dir <- result.try(
    fs.is_directory(path)
    |> result.map_error(fn(err) {
      error.FileSystemError(case err {
        fs.Eacces -> ""
        _ -> ""
      })
    }),
  )

  Ok(Repository("", "", ""))
}
