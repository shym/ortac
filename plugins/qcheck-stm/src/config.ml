open Gospel
open Tast
open Ortac_core

type t = {
  context : Context.t;
  init : Identifier.Ident.t;
  sut : Ttypes.tysymbol;
}

let dump ppf t =
  Fmt.(
    pf ppf "init: %a; sut: %a@." Identifier.Ident.pp t.init Identifier.Ident.pp
      t.sut.ts_ident)

let get_sut_ts_from_td sut td =
  let open Identifier.Ident in
  if td.td_ts.ts_ident.id_str = sut then Some td.td_ts else None

let get_sut_ts_from_sig_desc sut = function
  | Sig_type (_, tds, Nonghost) -> List.find_map (get_sut_ts_from_td sut) tds
  | _ -> None

let get_sut_ts_from_signature sut sigs =
  let f signature_item = get_sut_ts_from_sig_desc sut signature_item.sig_desc in
  Option.fold
    ~none:Reserr.(error (Sut_type_not_present sut, Location.none))
    ~some:Reserr.ok (List.find_map f sigs)

let check_init_value_type sut vd =
  match (vd.vd_args, vd.vd_ret) with
  | [ Lunit ], [ Lnone vs ] -> (
      match vs.vs_ty.ty_node with
      | Tyapp (ts, _) ->
          if Ttypes.ts_equal ts sut then Some vd.vd_name else None
      | _ -> None)
  | _, _ -> None

let get_init_from_sig_desc sut init = function
  | Sig_val (vd, Nonghost) ->
      if vd.vd_name.id_str = init then check_init_value_type sut vd else None
  | _ -> None

let get_init_id_from_signature sut init sigs =
  let f signature_item =
    get_init_from_sig_desc sut init signature_item.sig_desc
  in
  Option.fold
    ~none:Reserr.(error (Init_function_not_present init, Location.none))
    ~some:Reserr.ok (List.find_map f sigs)

let init path init sut_str =
  let module_name = Utils.module_name_of_path path in
  Parser_frontend.parse_ocaml_gospel path |> Utils.type_check [] path
  |> fun (env, sigs) ->
  assert (List.length env = 1);
  let namespace = List.hd env in
  let context = Context.init module_name namespace in
  let open Reserr in
  let* sut = get_sut_ts_from_signature sut_str sigs in
  let* init = get_init_id_from_signature sut init sigs in
  Reserr.ok (sigs, { context; init; sut })
