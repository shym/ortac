let () = print_endline "test with existing sut type:"
let () = Ortac_qcheck_stm.main "lib.mli" "good_init" "sut"
let () = print_newline ()
let () = print_endline "test with non-existing sut type:"
let () = Ortac_qcheck_stm.main "lib.mli" "good_init" "absent"
let () = print_newline ()
let () = print_endline "test with a wrong type for init function"
let () = Ortac_qcheck_stm.main "lib.mli" "bad_init" "sut"
let () = print_newline ()
let () = print_endline "test with an absent init function"
let () = Ortac_qcheck_stm.main "lib.mli" "absent" "sut"

