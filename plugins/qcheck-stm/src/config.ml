open Gospel
open Ortac_core
open Ppxlib

type t = {
  context : Context.t;
  sut_core_type : Ppxlib.core_type;
  init_sut : Ppxlib.expression;
}

let get_sut_type_name config =
  let open Ppxlib in
  match config.sut_core_type.ptyp_desc with
  | Ppxlib.Ptyp_constr (lid, _) -> lid.txt
  | _ -> failwith "unreachable case in get_sut_type_name"

let get_sut_type_name_str config =
  let open Ppxlib in
  match get_sut_type_name config with
  | Longident.Lident s | Longident.Ldot (_, s) -> s
  | Longident.Lapply (_, _) -> failwith "not supported"

let is_sut config ty =
  let sut_type_name = get_sut_type_name config in
  let open Ppxlib in
  match ty.ptyp_desc with
  | Ptyp_constr (lid, _) -> lid.txt = sut_type_name
  | _ -> false

let is_sut_gospel_ty config ty =
  let sut_type_unqualified_name = get_sut_type_name_str config in
  let open Gospel.Ttypes in
  match ty.ty_node with
  | Tyvar _ -> false
  | Tyapp (ts, _) ->
      Fmt.str "%a" Gospel.Identifier.Ident.pp ts.ts_ident
      = sut_type_unqualified_name

let dump ppf t =
  Fmt.(
    pf ppf "sut_core_type: %a; init_sut: %a@." Ppxlib_ast.Pprintast.expression
      t.init_sut Ppxlib_ast.Pprintast.core_type t.sut_core_type)

let core_type_of_string t =
  let open Reserr in
  try Ppxlib.Parse.core_type (Lexing.from_string t) |> ok
  with _ -> error (Syntax_error_in_type t, Location.none)

let rec acceptable_type_parameter param =
  let open Ppxlib in
  let open Reserr in
  let str = Fmt.str "%a" Ppxlib_ast.Pprintast.core_type param in
  match param.ptyp_desc with
  | Ptyp_constr (_, cts) ->
      let* _ = map acceptable_type_parameter cts in
      ok ()
  | Ptyp_tuple args ->
      let* _ = map acceptable_type_parameter args in
      ok ()
  | Ptyp_var _ | Ptyp_any ->
      error (Type_parameter_not_instantiated str, Location.none)
  | _ -> error (Type_not_supported_for_sut_parameter str, Location.none)

let core_type_is_a_well_formed_sut (core_type : Ppxlib.core_type) =
  let open Ppxlib in
  let open Reserr in
  match core_type.ptyp_desc with
  | Ptyp_constr (lid, cts) ->
      let* _ = map acceptable_type_parameter cts in
      ok (lid, cts)
  | _ ->
      let str = Fmt.str "%a" Ppxlib_ast.Pprintast.core_type core_type in
      error (Sut_type_not_supported str, Location.none)

let sut_core_type str =
  let open Reserr in
  let* sut_core_type = core_type_of_string str in
  let* _ = core_type_is_a_well_formed_sut sut_core_type in
  ok sut_core_type

let init_sut_from_string str =
  let open Ppxlib in
  try Parse.expression (Lexing.from_string str) |> Reserr.ok
  with _ -> Reserr.(error (Syntax_error_in_init_sut str, Location.none))

let init path init_sut sut_str =
  let open Reserr in
  try
    let module_name = Utils.module_name_of_path path in
    Parser_frontend.parse_ocaml_gospel path |> Utils.type_check [] path
    |> fun (env, sigs) ->
    assert (List.length env = 1);
    let namespace = List.hd env in
    let context = Context.init module_name namespace in
    let* sut_core_type = sut_core_type sut_str
    and* init_sut = init_sut_from_string init_sut in
    ok (sigs, { context; sut_core_type; init_sut })
  with Gospel.Warnings.Error (l, k) ->
    error (Ortac_core.Warnings.GospelError k, l)
