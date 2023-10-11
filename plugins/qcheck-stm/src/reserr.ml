module W = Ortac_core.Warnings

type init_state_error =
  | Not_a_function_call of string
  | No_specification of string
  | No_appropriate_specifications of string * string list
  | No_translatable_specification of string
  | Not_returning_sut of string
  | Qualified_name of string
  | Mismatch_number_of_arguments of string

type W.kind +=
  | Constant_value of string
  | Returning_sut of string
  | No_sut_argument of string
  | Multiple_sut_arguments of string
  | No_sut_type of string
  | No_init_function of string
  | Syntax_error_in_type of string
  | Syntax_error_in_init_sut of string
  | Sut_type_not_supported of string
  | Type_parameter_not_instantiated of string
  | Type_not_supported_for_sut_parameter of string
  | Incompatible_type of (string * string)
  | Sut_type_not_specified of string
  | No_models of string
  | No_spec of string
  | Impossible_term_substitution of [ `New | `Old | `NotModel ]
  | Ignored_modifies
  | Ensures_not_found_for_next_state of (string * string)
  | Type_not_supported of string
  | Impossible_init_state_generation of init_state_error
  | Functional_argument of string
  | Ghost_values of (string * [ `Arg | `Ret ])
  | Incompatible_sut of string

let level kind =
  match kind with
  | Constant_value _ | Returning_sut _ | No_sut_argument _
  | Multiple_sut_arguments _ | Incompatible_type _ | No_spec _
  | Impossible_term_substitution _ | Ignored_modifies
  | Ensures_not_found_for_next_state _ | Type_not_supported _
  | Functional_argument _ | Ghost_values _ ->
      W.Warning
  | No_sut_type _ | No_init_function _ | Syntax_error_in_type _
  | Sut_type_not_supported _ | Type_not_supported_for_sut_parameter _
  | Syntax_error_in_init_sut _ | Type_parameter_not_instantiated _
  | Sut_type_not_specified _ | No_models _ | Impossible_init_state_generation _
  | Incompatible_sut _ ->
      W.Error
  | _ -> W.level kind

type 'a reserr = ('a, W.t list) result * W.t list

let ok x = (Result.ok x, [])
let error e = (Result.error [ e ], [])
let warns ws = (Result.ok (), ws)
let warn w = warns [ w ]

let ( let* ) x f =
  match x with
  | Ok v, warns1 ->
      let res, warns2 = f v in
      (res, warns1 @ warns2)
  | (Error _, _) as x -> x

let ( >>= ) = ( let* )

let ( and* ) (a, aw) (b, bw) =
  let r =
    match (a, b) with
    | Error e0, Error e1 -> Error (e0 @ e1)
    | Error e, _ | _, Error e -> Error e
    | Ok a, Ok b -> Ok (a, b)
  in
  (r, aw @ bw)

let fmap f r =
  let* r = r in
  ok (f r)

let ( <$> ) = fmap

let app f r =
  let* f = f and* r = r in
  ok (f r)

let ( <*> ) = app

let pp_kind ppf kind =
  let open Fmt in
  match kind with
  (* Warnings *)
  | Constant_value id ->
      pf ppf "Skipping %s:@ %a" id text "constants cannot be tested"
  | Returning_sut id ->
      pf ppf "Skipping %s:@ %a" id text
        "functions returning a SUT value cannot be tested"
  | No_sut_argument id ->
      pf ppf "Skipping %s:@ %a" id text
        "functions with no SUT argument cannot be tested"
  | Multiple_sut_arguments id ->
      pf ppf "Skipping %s:@ %a" id text
        "functions with multiple SUT arguments cannot be tested"
  | Incompatible_type (v, t) ->
      pf ppf "Skipping %s:@ %a%s" v text
        "the type of its SUT-type argument is incompatible with the configured \
         SUT type: "
        t
  | No_spec fct ->
      pf ppf "Skipping %s:@ %a" fct text
        "functions without specifications cannot be tested"
  | Impossible_term_substitution why ->
      let msg =
        match why with
        | `NotModel ->
            "occurrences of the SUT in clauses are only supported to access \
             its model fields"
        (* The following cases should not be reported to the user at the moment
           (because they should be caught at some other points) *)
        | `Old ->
            "occurrences of the SUT in clauses are not supported under old \
             operator"
        | `New ->
            "occurrences of the SUT in clauses are not supported above old \
             operator"
      in
      pf ppf "Skipping clause:@ %a" text msg
  | Ignored_modifies ->
      pf ppf "Skipping unsupported modifies clause:@ %a" text
        "expected \"modifies x\" or \"modifies x.model\" where x is the SUT"
  | Ensures_not_found_for_next_state (f, m) ->
      pf ppf "@[Skipping %s:@ model@ %s@ %a@]@ @[%a@]@ @[%s = f (old %s)@]" f m
        text
        "is declared as modified by the function but no suitable ensures \
         clause was found."
        text
        "Specifications should contain at least one ensures clause of the form"
        m m
  | Functional_argument f ->
      pf ppf "Skipping %s:@ %a" f text
        "functions are not supported yet as arguments"
  | Ghost_values (id, k) ->
      pf ppf "Skipping %s:@ %a%a%a" id text "functions with a ghost " text
        (match k with `Arg -> "argument" | `Ret -> "returned value")
        text " are not supported"
  (* This following message is broad and used in seemingly different contexts
     but in fact we support all the types that the Gospel type-checker supports,
     so that error message should never get reported to the end user *)
  | Type_not_supported ty -> pf ppf "Type %s not supported" ty
  (* Errors *)
  | No_sut_type ty -> pf ppf "Type %s not declared in the module" ty
  | No_init_function f -> pf ppf "Function %s not declared in the module" f
  | Syntax_error_in_type t -> pf ppf "Syntax error in type %s" t
  | Syntax_error_in_init_sut s -> pf ppf "Syntax error in OCaml expression %s" s
  | Sut_type_not_supported ty ->
      pf ppf "Unsupported SUT type %s:@ %a" ty text
        "SUT type must be a type constructor, possibly applied to type \
         arguments"
  | Type_parameter_not_instantiated ty ->
      pf ppf "Unsupported type parameter %s:@ %a" ty text
        "SUT type should be fully instantiated"
  | Type_not_supported_for_sut_parameter ty ->
      pf ppf "Unsupported type parameter %s:@ %a" ty text
        "only constructors and tuples are supported in arguments for the SUT \
         type"
  | Sut_type_not_specified ty ->
      pf ppf "Missing specification for the SUT type %s" ty
  | No_models ty -> pf ppf "Missing model(s) for the SUT type %s" ty
  | Impossible_init_state_generation (Not_a_function_call fct) ->
      pf ppf "Unsupported INIT expression %s:@ %a" fct text
        "the INIT expression is expected to be a function call (the \
         specification of that function is required to initialize the model \
         state)"
  | Impossible_init_state_generation (No_specification fct) ->
      pf ppf "Unsupported INIT function %s:@ %a" fct text
        "the function called in the INIT expression must be specified to \
         initialize the model state"
  | Impossible_init_state_generation
      (No_appropriate_specifications (fct, models)) ->
      pf ppf "Unsupported INIT function %s:@ %a:@ %a" fct text
        "the specification of the function called in the INIT expression does \
         not specify the following fields of the model"
        (Fmt.list ~sep:(Fmt.any ",@ ") Fmt.string)
        models
  | Impossible_init_state_generation (No_translatable_specification model) ->
      pf ppf "Unsupported INIT function:@ %a:@ %s" text
        "the specification of the function called in the INIT expression does \
         not provide a translatable specification for the following field of \
         the model"
        model
  | Impossible_init_state_generation (Not_returning_sut fct) ->
      pf ppf "Unsupported INIT expression %s:@ %a" fct text
        "the function called in the INIT expression must return a value of SUT \
         type"
  | Impossible_init_state_generation (Qualified_name fct) ->
      pf ppf "Unsupported INIT function %s:@ %a" fct text
        "qualified names are not yet supported"
  | Impossible_init_state_generation (Mismatch_number_of_arguments fct) ->
      pf ppf "Error in INIT expression %s:@ %a" fct text
        "mismatch in the number of arguments between the INIT expression and \
         the function specification"
  | Incompatible_sut t ->
      pf ppf "Incompatible declaration of SUT type:@ %a%s" text
        "the declaration of the SUT type is incompatible with the configured \
         one: "
        t
  | _ -> W.pp_kind ppf kind

let pp_errors = W.pp_param pp_kind level |> Fmt.list

let pp pp_ok ppf r =
  let open Fmt in
  match r with
  | Ok a, warns -> (
      pf ppf "%a@." pp_ok a;
      match warns with [] -> () | warns -> pf stderr "%a@." pp_errors warns)
  | Error errs, warns -> pf stderr "%a@." pp_errors (errs @ warns)

let sequence r =
  let rec aux = function
    | [] -> ok []
    | ((Ok _, _) as x) :: xs ->
        let* y = x and* ys = aux xs in
        ok (y :: ys)
    | ((Error _, _) as x) :: _ -> x
  in
  aux r

let rec filter_errs = function
  | [] -> ok ()
  | ((k, _) as e) :: es -> (
      match level k with
      | W.Warning ->
          let* _ = warn e in
          filter_errs es
      | W.Error -> error e)

let rec promote = function
  | [] -> ok []
  | ((Ok _, _) as x) :: xs ->
      let* y = x and* ys = promote xs in
      ok (y :: ys)
  | (Error errs, ws) :: xs ->
      let* _ = warns ws and* _ = filter_errs errs in
      promote xs

let promote_opt r =
  match r with
  | (Ok _, _) as x ->
      let* y = x in
      ok (Some y)
  | Error errs, ws ->
      let* _ = warns ws and* _ = filter_errs errs in
      ok None

let of_option ~default = Option.fold ~none:(error default) ~some:ok
let to_option = function Ok x, _ -> Some x | _ -> None
let map f l = List.map f l |> promote
let concat_map f l = fmap List.concat (map f l)
