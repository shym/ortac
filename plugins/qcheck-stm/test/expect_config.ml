open Ortac_qcheck_stm

let underline str =
  print_endline str;
  print_endline (String.map (Fun.const '=') str)

let pp = Reserr.pp (Fmt.pair Fmt.nop Config.dump) Fmt.stdout
let () = underline "test with existing sut type:"
let () = Config.init "lib.mli" "good_init" "sut" |> pp
let () = print_newline ()
let () = underline "test with non-existing sut type:"
let () = Config.init "lib.mli" "good_init" "absent" |> pp
let () = print_newline ()
let () = underline "test with a wrong type for init function:"
let () = Config.init "lib.mli" "bad_init" "sut" |> pp
let () = print_newline ()
let () = underline "test with an absent init function:"
let () = Config.init "lib.mli" "absent" "sut" |> pp
let () = print_newline ()
let () = underline "test with not well formed type expression:"
let () = Config.init "lib.mli" "" "a-t" |> pp
let () = print_newline ()
let () = underline "test with non instantiated sut type parameter:"
let () = Config.init "lib.mli" "" "'a t" |> pp
let () = print_newline ()
let () = underline "test with arrow type as sut:"
let () = Config.init "lib.mli" "" "int -> int" |> pp
