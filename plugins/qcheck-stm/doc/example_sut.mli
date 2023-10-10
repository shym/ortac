type 'a t
(*@ model size : int
    mutable model contents : 'a list *)

val make : int -> 'a -> 'a t
(*@ t = make i a
    checks i >= 0
    ensures t.size = i
    ensures t.contents = List.init i (fun j -> a) *)

(* $MDX part-begin=fun-decl *)

val f : int -> int -> bool
(*@ b = f x y *)

val g : 'a t -> 'a t -> bool
(*@ b = g t1 t2 *)

val h : int -> 'a t
(*@ t = h i *)

val exist : ('a -> bool) -> 'a t -> b
(*@ b = exist p t *)

(* $MDX part-end *)
