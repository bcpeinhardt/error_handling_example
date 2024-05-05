import gleam/bool
import gleam/result
import gleam/string
import simplifile
import tom

/// This is our custom error type for our package.
/// Functions that return a `Result` should have this as 
/// the error type.
pub type Error {
  ReadTomlError(simplifile.FileError)
  ParseTomlError(tom.ParseError)
  MissingNameError(tom.GetError)
  EmptyNameError
}

pub fn get_package_name() -> Result(String, Error) {
  // We read in the contents of the gleam.toml as a string. 
  // If it fails, we return an appropriate error which wraps
  // the simplifile error for context
  use toml_str <- result.try(
    simplifile.read("./gleam.toml")
    |> result.map_error(ReadTomlError),
  )

  // We try to parse the toml string. If it fails, we return
  // an appropriate error which wraps the tom error for context.
  use parsed_toml <- result.try(
    tom.parse(toml_str)
    |> result.map_error(ParseTomlError),
  )

  // We try to get the name field. If it's missing, we return 
  // an appropriate error, wrapping the tom error for context
  use name <- result.try(
    tom.get_string(parsed_toml, ["name"])
    |> result.map_error(MissingNameError),
  )

  // Now let's say we wanna make sure the package name isn't 
  // an empty string. In reality, the gleam compiler would catch
  // that, but we need an example constructing an error of our own
  use <- bool.guard(string.is_empty(name), Error(EmptyNameError))

  // Everything worked out, so we return the name.
  Ok(name)
}
