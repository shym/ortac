module W = Ortac_core.Warnings

type W.kind +=
  | Value_is_a_constant of string
  | Value_return_sut of string
  | Value_have_no_sut_argument of string
  | Value_have_multiple_sut_arguments of string
  | Sut_type_not_present of string
  | Init_function_not_present of string
  | No_testable_values of string

type 'a reserr

val ok : 'a -> 'a reserr
val error : W.t -> 'a reserr
val warns : W.t list -> unit reserr
val warn : W.t -> unit reserr
val ( let* ) : 'a reserr -> ('a -> 'b reserr) -> 'b reserr
val ( and* ) : 'a reserr -> 'b reserr -> ('a * 'b) reserr
val promote : 'a reserr list -> 'a list reserr
val pp : 'a Fmt.t -> 'a reserr Fmt.t
