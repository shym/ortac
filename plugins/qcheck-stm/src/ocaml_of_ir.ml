open Gospel

type error = CannotSubst of Gospel.Tterm.term

exception ImpossibleSubst of error

let subst ~gos_t ~old_t ~new_t term =
  let rec aux cur_t term =
    let open Tterm in
    let next = aux cur_t in
    match term.t_node with
    | Tconst _ -> term
    | Tvar { vs_name; vs_ty } when vs_name = gos_t -> (
        match cur_t with
        | Some cur_t -> { term with t_node = Tvar { vs_name = cur_t; vs_ty } }
        | None -> raise (ImpossibleSubst (CannotSubst term)))
    | Tvar _ -> term
    | Tapp (ls, terms) -> { term with t_node = Tapp (ls, List.map next terms) }
    | Tfield (t, ls) -> { term with t_node = Tfield (next t, ls) }
    | Tif (cnd, thn, els) ->
        { term with t_node = Tif (next cnd, next thn, next els) }
    | Tlet (vs, t1, t2) -> { term with t_node = Tlet (vs, next t1, next t2) }
    | Tcase (t, brchs) ->
        {
          term with
          t_node =
            Tcase
              ( next t,
                List.map
                  (fun (p, ot, t) -> (p, Option.map next ot, next t))
                  brchs );
        }
    | Tquant (q, vs, t) -> { term with t_node = Tquant (q, vs, next t) }
    | Tbinop (o, l, r) -> { term with t_node = Tbinop (o, next l, next r) }
    | Tnot t -> { term with t_node = Tnot (next t) }
    | Told t -> aux old_t t
    | Ttrue -> term
    | Tfalse -> term
  in
  try Result.Ok (aux new_t term) with ImpossibleSubst e -> Result.Error e

