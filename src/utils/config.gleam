import gleam/result
import tom
import simplifile as fs
import models/error.{type AppError}
import gleam/dict.{type Dict}

pub fn new(file: String) -> Result(Dict(String, tom.Toml), AppError) {
  use content <- result.try(fs.read(file) |> result.map_error(fn (_err) {
    error.FileSystemError("Failed to fetch config file")
  }))
  tom.parse(content) |> result.map_error(fn (_err) {
    error.FileSystemError("Failed to parse config file")
  })
}

fn get(key: List(String), config: Dict(String, tom.Toml)) -> Result(tom.Toml, AppError) {
  tom.get(config, key) |> result.map_error(fn (_err) {
    error.ConfigError("Failed to fetch config value")
  })
}

pub fn get_string(key: List(String), config: Dict(String, tom.Toml)) -> Result(String, AppError) {
  use value <- result.try(get(key, config))

  tom.as_string(value) |> result.map_error(fn (_err) {
    error.ConfigError("Failed to convert config value to string")
  })
}

pub fn get_int(key: List(String), config: Dict(String, tom.Toml)) -> Result(Int, AppError) {
  use toml <- result.try(get(key, config))

  tom.as_int(toml) |> result.map_error(fn (_err) {
    error.ConfigError("Failed to convert config value to string")
  })
}

pub fn get_float(key: List(String), config: Dict(String, tom.Toml)) -> Result(Float, AppError) {
  use toml <- result.try(get(key, config))

  tom.as_float(toml) |> result.map_error(fn (_err) {
    error.ConfigError("Failed to convert config value to string")
  })
}

pub fn update(key_list: List(String), value: tom.Toml, config: Dict(String, tom.Toml)) -> Result(Dict(String, tom.Toml), AppError) {
  case key_list {
    [] -> Error(error.ConfigError("No keys passed"))
    [key] -> Ok(dict.insert(config, key, value))
    [first, ..rest] -> {
      use toml <- result.try(dict.get(config, first) |> result.map_error(fn (_err) {error.ConfigError("Key not present in config")}))
      case toml {
        tom.Table(inner) -> {
          use updated_dict <- result.try(update(rest, value, inner))
          Ok(dict.insert(config, first, tom.Table(updated_dict)))
        }
        tom.InlineTable(inner) -> {
          use updated_dict <- result.try(update(rest, value, inner))
          Ok(dict.insert(config, first, tom.InlineTable(updated_dict)))
        }
        _ -> Error(error.ConfigError("Invalid key passed"))
      }
    }
  }
}
