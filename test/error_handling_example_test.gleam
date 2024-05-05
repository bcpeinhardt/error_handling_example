import error_handling_example.{get_package_name}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  get_package_name()
  |> should.equal(Ok("error_handling_example"))
}
