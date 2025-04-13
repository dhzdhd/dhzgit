import argv
import commands/init.{cmd_init}
import gleam/io
import glint
import models/error

fn index() {
  use <- glint.command_help("Provides brief info about the program.")

  use _, _, _ <- glint.command()
  io.println("dhzgit")
}

fn force_flag() -> glint.Flag(Bool) {
  glint.bool_flag("force")
  |> glint.flag_default(False)
  |> glint.flag_help("Ignore all checks and force the operation")
}

fn init() {
  use <- glint.command_help(
    "Initializes a git repository in the current directory.",
  )
  use <- glint.unnamed_args(glint.EqArgs(1))
  use force_fn <- glint.flag(force_flag())

  use _, unnamed, flags <- glint.command()

  let assert Ok(force) = force_fn(flags)
  let path = case unnamed {
    [path] -> path
    _ -> "."
  }

  case cmd_init(path, force) {
    Ok(repo) -> io.println("Initialized a git repository at " <> repo.worktree)
    Error(err) -> err |> error.stringify_error |> io.println_error
  }
}

pub fn main() {
  glint.new()
  |> glint.with_name("dhzgit")
  |> glint.pretty_help(glint.default_pretty_help())
  |> glint.add(at: [], do: index())
  |> glint.add(at: ["init"], do: init())
  |> glint.run(argv.load().arguments)
}
