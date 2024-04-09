let () =
  match Sys.getenv_opt "ORTAC_ONLY_PLUGIN" with
  | None -> Sites.Plugins.Plugins.load_all ()
  | Some plug -> Sites.Plugins.Plugins.load plug

open Cmdliner

let () =
  let doc = "Run ORTAC."
  and version =
    Printf.sprintf "ortac version: %s"
      (match Build_info.V1.version () with
      | None -> "n/a"
      | Some v -> Build_info.V1.Version.to_string v)
  in
  let info = Cmd.info "ortac" ~doc ~version
  and default = Term.(ret (const (`Help (`Pager, None))))
  and cmds =
    Registration.fold (fun acc cmd -> cmd :: acc) [] Registration.plugins
  in
  let group = Cmd.group info ~default cmds in
  Stdlib.exit (Cmd.eval group)
