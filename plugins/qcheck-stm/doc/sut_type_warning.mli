type 'a t
(*@ model size : int
    mutable model contents : 'a list *)

val make : int -> 'a -> 'a t
(*@ t = make i a
    checks i >= 0
    ensures t.size = i
    ensures t.contents = List.init i (fun j -> a) *)

(* $MDX part-begin=fun-decl *)

val no_sut_argument : int -> int -> bool
(*@ b = no_sut_argument x y *)

(* $MDX part-end *)
