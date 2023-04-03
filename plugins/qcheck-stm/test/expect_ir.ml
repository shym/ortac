open Ortac_qcheck_stm

let () =
  let pp = Fmt.(Reserr.pp (list Ir.pp_value)) in
  Ir_of_gospel.run "lib.mli" "good_init" "sut" |> pp Fmt.stdout
