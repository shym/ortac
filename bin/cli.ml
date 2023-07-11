let () = Sites.Plugins.Plugins.load_all ()

open Cmdliner

let usage () =
  Format.(fprintf std_formatter)
    "ortac command-line tool requires at least one plugin.@\n\
     Please install one."

let () =
  match
    Registration.fold (fun acc cmd -> cmd :: acc) [] Registration.plugins
  with
  | [] -> usage ()
  | cmds ->
      let doc = "Run ORTAC." in
      let version = "ortac version %%VERSION%%" in
      let info = Cmd.info "ortac" ~doc ~version in
      let group = Cmd.group info cmds in
      Stdlib.exit (Cmd.eval group)
