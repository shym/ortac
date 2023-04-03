module W = Ortac_core.Warnings

type W.kind +=
  | Value_is_a_constant of string
  | Value_return_sut of string
  | Value_have_no_sut_argument of string
  | Value_have_multiple_sut_arguments of string
  | Sut_type_not_present of string
  | Init_function_not_present of string
  | No_testable_values of string

let level kind =
  try W.level kind
  with W.Unkown_kind -> (
    match kind with
    | Value_is_a_constant _ | Value_return_sut _ | Value_have_no_sut_argument _
    | Value_have_multiple_sut_arguments _ ->
        W.Warning
    | Sut_type_not_present _ | Init_function_not_present _
    | No_testable_values _ ->
        W.Error
    | _ -> raise W.Unkown_kind)

type 'a reserr = ('a, W.t list) result * W.t list

let ok x = Result.ok x, []
let error e = (Result.error [ e ], [])
let warns ws = (Result.ok (), ws)
let warn w = warns [ w ]

let ( let* ) x f =
  match x with
  | Ok v, warns1 ->
      let res, warns2 = f v in
      (res, warns1 @ warns2)
  | (Error _, _) as x -> x

let ( and* ) (a, aw) (b, bw) =
  let r =
    match (a, b) with
    | Error e0, Error e1 -> Error (e0 @ e1)
    | Error e, _ | _, Error e -> Error e
    | Ok a, Ok b -> Ok (a, b)
  in
  (r, aw @ bw)


let pp_kind ppf kind =
  let open Fmt in
  try W.pp_kind ppf kind
  with W.Unkown_kind -> (
    match kind with
    | Value_is_a_constant id -> pf ppf "%a is a constant." W.quoted id
    | Value_return_sut id -> pf ppf "%a returns a sut." W.quoted id
    | Value_have_no_sut_argument id ->
        pf ppf "%a have no sut argument." W.quoted id
    | Value_have_multiple_sut_arguments id ->
        pf ppf "%a have multiple sut arguments." W.quoted id
    | Sut_type_not_present ty ->
        pf ppf "Type %a is not declared in the module." W.quoted ty
    | Init_function_not_present f ->
        pf ppf "Function %a is not declared in the module." W.quoted f
    | No_testable_values m ->
        pf ppf "Module %a does not contain any testable values." W.quoted m
    | _ -> raise W.Unkown_kind)

let pp_errors = W.pp_param pp_kind level |> Fmt.list
let pp pp_ok = Fmt.result ~ok:pp_ok ~error:pp_errors

let promote r =
  let rec aux = function
    | [] -> ok []
    | ((Ok _, _) as x) :: xs ->
        let* y = x and* ys = aux xs in
        ok (y :: ys)
    | (Error errs, ws) :: xs ->
        let* _ = warns ws and* _ = auxes errs in
        aux xs
  and auxes = function
    | [] -> ok ()
    | ((k, _) as e) :: es -> (
        match level k with
        | W.Warning ->
            let* _ = warn e in
            auxes es
        | W.Error -> error e)
  in
  aux r
