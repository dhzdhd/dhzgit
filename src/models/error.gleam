pub type AppError {
  FileSystemError(String)
  ConfigError(String)
  InvalidArgument(String)
}

pub fn stringify_error(err: AppError) -> String {
  case err {
    FileSystemError(msg) -> "File system error: " <> msg
    ConfigError(msg) -> "Config error: " <> msg
    InvalidArgument(msg) -> "Invalid argument: " <> msg
  }
}
