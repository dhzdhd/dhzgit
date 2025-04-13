pub type AppError {
  FileSystemError(String)
  InvalidArgument(String)
}

pub fn stringify_error(err: AppError) -> String {
  case err {
    FileSystemError(msg) -> "File system error: " <> msg
    InvalidArgument(msg) -> "Invalid argument: " <> msg
  }
}
