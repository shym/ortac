module type S = sig
  type location = { start : Lexing.position; stop : Lexing.position }
  type term_kind = Check | Pre | Post | XPost

  type error =
    | Violated_axiom
    | Axiom_failure of { exn : exn }
    | Violated_invariant of { term : string; position : term_kind }
    | Violated_condition of { term : string; term_kind : term_kind }
    | Specification_failure of {
        term : string;
        term_kind : term_kind;
        exn : exn;
      }
    | Unexpected_exception of { allowed_exn : string list; exn : exn }
    | Uncaught_checks of { term : string }
    | Unexpected_checks of { terms : string list }

  type error_report = {
    loc : location;
    fun_name : string;
    mutable errors : error list;
  }

  val pp_error_report : Format.formatter -> error_report -> unit

  exception Error of error_report

  module Errors : sig
    type t

    val create : location -> string -> t
    (** [empty] create a new empty error container *)

    val register : t -> error -> unit
    (** [register t a] add the element [a] to [t] *)

    val report : t -> unit
    (** [report l] prints the content of [l] *)
  end

  type integer

  module Gospelstdlib : sig
    type 'a sequence

    type 'a bag
    [@@alert not_implemented "The type [bag] is not implemented yet"]

    type 'a set
    [@@alert not_implemented "The type [set] is not implemented yet"]

    (** {1 Arithmetic} *)

    val succ : integer -> integer
    val pred : integer -> integer

    val ( ~- ) : integer -> integer
    val ( + ) : integer -> integer -> integer
    val ( - ) : integer -> integer -> integer
    val ( * ) : integer -> integer -> integer
    val ( / ) : integer -> integer -> integer
    val ( mod ) : integer -> integer -> integer

    val pow : integer -> integer -> integer
    val abs : integer -> integer

    val min : integer -> integer -> integer
    val max : integer -> integer -> integer

    (** {2 Comparisons} *)

    val ( > ) : integer -> integer -> bool
    val ( >= ) : integer -> integer -> bool
    val ( < ) : integer -> integer -> bool
    val ( <= ) : integer -> integer -> bool

    (** {2 Bitwise operations} *)

    val logand : integer -> integer -> integer
    val logor : integer -> integer -> integer
    val logxor : integer -> integer -> integer
    val lognot : integer -> integer

    val shift_left : integer -> integer -> integer
    val shift_right : integer -> integer -> integer
    val shift_right_trunc : integer -> integer -> integer

    (** {2 Machine integers} *)

    val integer_of_int : int -> integer
    val max_int : integer
    val min_int : integer

    (** {1 Couples} *)

    val fst : 'a * 'b -> 'a
    val snd : 'a * 'b -> 'b

    (** {1 References} *)

    val ( ~! ) : 'a ref -> 'a

    (** {1 Sequences} *)

    val ( ++ ) : 'a sequence -> 'a sequence -> 'a sequence

    val __mix_Bub (* [_] *) : 'a sequence -> integer -> 'a
      [@@alert not_implemented "This function is not implemented yet"]

    val __mix_Buddub (* [_.._] *) :
      'a sequence -> integer -> integer -> 'a sequence
      [@@alert not_implemented "This function is not implemented yet"]

    val __mix_Buddb (* [_..] *) : 'a sequence -> integer -> 'a sequence
      [@@alert not_implemented "This function is not implemented yet"]

    val __mix_Bddub (* [.._] *) : 'a sequence -> integer -> 'a sequence
      [@@alert not_implemented "This function is not implemented yet"]

    module Sequence : sig
      type 'a t = 'a sequence

      val length : 'a t -> integer
      val empty : 'a t
      val singleton : 'a -> 'a t
      val init : integer -> (integer -> 'a) -> 'a t
      val cons : 'a -> 'a t -> 'a t
      val snoc : 'a t -> 'a -> 'a t
      val hd : 'a t -> 'a
      val tl : 'a t -> 'a t
      val append : 'a t -> 'a t -> 'a t
      val mem : 'a t -> 'a -> bool
      val map : ('a -> 'b) -> 'a t -> 'b t
      val filter : ('a -> bool) -> 'a t -> 'a t
      val filter_map : ('a -> 'b option) -> 'a t -> 'b t
      val get : 'a t -> integer -> 'a
      val set : 'a t -> integer -> 'a -> 'a t
      val rev : 'a t -> 'a t
      val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
      val fold_right : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b
    end

    (** {1 Lists} *)

    module List : sig
      type 'a t = 'a list

      val length : 'a t -> integer
      val hd : 'a t -> 'a
      val tl : 'a t -> 'a t
      val nth : 'a t -> integer -> 'a
      val nth_opt : 'a t -> integer -> 'a option
      val rev : 'a t -> 'a t
      val init : integer -> (integer -> 'a) -> 'a t
      val map : ('a -> 'b) -> 'a t -> 'b t
      val mapi : (integer -> 'a -> 'b) -> 'a t -> 'b t
      val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
      val fold_right : ('b -> 'a -> 'a) -> 'b t -> 'a -> 'a
      val map2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
      val for_all : ('a -> bool) -> 'a t -> bool
      val _exists : ('a -> bool) -> 'a t -> bool
      val for_all2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
      val _exists2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
      val mem : 'a -> 'a t -> bool
      val to_seq : 'a t -> 'a sequence
      val of_seq : 'a sequence -> 'a t
    end

    (** {1 Arrays} *)

    module Array : sig
      type 'a t = 'a array

      val length : 'a t -> integer
      val get : 'a t -> integer -> 'a
      val make : integer -> 'a -> 'a t
      val init : integer -> (integer -> 'a) -> 'a t
      val append : 'a t -> 'a t -> 'a t
      val concat : 'a t list -> 'a t
      val sub : 'a t -> integer -> integer -> 'a t
      val map : ('a -> 'b) -> 'a t -> 'b t
      val mapi : (integer -> 'a -> 'b) -> 'a t -> 'b t
      val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
      val fold_right : ('b -> 'a -> 'a) -> 'b t -> 'a -> 'a
      val map2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
      val for_all : ('a -> bool) -> 'a t -> bool
      val _exists : ('a -> bool) -> 'a t -> bool
      val for_all2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
      val _exists2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
      val mem : 'a -> 'a t -> bool
      val to_list : 'a t -> 'a list
      val of_list : 'a list -> 'a t
      val to_seq : 'a t -> 'a sequence
      val of_seq : 'a sequence -> 'a t

      val to_bag : ('a t -> 'a bag[@alert "-not_implemented"])
        [@@alert not_implemented "This function is not implemented yet"]

      val permut : 'a t -> 'a t -> bool
        [@@alert not_implemented "This function is not implemented yet"]

      val permut_sub : 'a t -> 'a t -> integer -> integer -> bool
        [@@alert not_implemented "This function is not implemented yet"]
    end

    (** {1 Bags} *)

    module Bag : sig
      type 'a t = ('a bag[@alert "-not_implemented"])

      val occurrences : 'a -> 'a t -> integer
        [@@alert not_implemented "This function is not implemented yet"]

      val empty : 'a t
        [@@alert not_implemented "This value is not implemented yet"]

      val is_empty : 'a t -> bool
        [@@alert not_implemented "This function is not implemented yet"]

      val mem : 'a -> 'a t -> bool
        [@@alert not_implemented "This function is not implemented yet"]

      val add : 'a -> 'a t -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val singleton : 'a -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val remove : 'a -> 'a t -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val union : 'a t -> 'a t -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val sum : 'a t -> 'a t -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val inter : 'a t -> 'a t -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val disjoint : 'a t -> 'a t -> bool
        [@@alert not_implemented "This function is not implemented yet"]

      val diff : 'a t -> 'a t -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val subset : 'a t -> 'a t -> bool
        [@@alert not_implemented "This function is not implemented yet"]

      val choose : 'a t -> 'a
        [@@alert not_implemented "This function is not implemented yet"]

      val choose_opt : 'a t -> 'a option
        [@@alert not_implemented "This function is not implemented yet"]

      val map : ('a -> 'b) -> 'a t -> 'b t
        [@@alert not_implemented "This function is not implemented yet"]

      val fold : ('b -> 'a -> 'a) -> 'b t -> 'a -> 'a
        [@@alert not_implemented "This function is not implemented yet"]

      val for_all : ('a -> bool) -> 'a t -> bool
        [@@alert not_implemented "This function is not implemented yet"]

      val _exists : ('a -> bool) -> 'a t -> bool
        [@@alert not_implemented "This function is not implemented yet"]

      val filter : ('a -> bool) -> 'a t -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val filter_map : ('a -> 'b option) -> 'a t -> 'b t
        [@@alert not_implemented "This function is not implemented yet"]

      val partition : ('a -> bool) -> 'a t -> 'a t * 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val cardinal : 'a t -> integer
        [@@alert not_implemented "This function is not implemented yet"]

      val to_list : 'a t -> 'a list
        [@@alert not_implemented "This function is not implemented yet"]

      val of_list : 'a list -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val to_seq : 'a t -> 'a sequence
        [@@alert not_implemented "This function is not implemented yet"]

      val of_seq : 'a sequence -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]
    end

    (** {1 Sets} *)

    val __mix_Cc (* {} *) : ('a set[@alert "-not_implemented"])
      [@@alert not_implemented "This value is not implemented yet"]

    module Set : sig
      type 'a t = ('a set[@alert "-not_implemented"])

      val compare : 'a t -> 'a t -> int
        [@@alert not_implemented "This function is not implemented yet"]

      val empty : 'a t
        [@@alert not_implemented "This value is not implemented yet"]

      val is_empty : 'a t -> bool
        [@@alert not_implemented "This function is not implemented yet"]

      val mem : 'a -> 'a t -> bool
        [@@alert not_implemented "This function is not implemented yet"]

      val add : 'a -> 'a t -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val singleton : 'a -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val remove : 'a -> 'a t -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val union : 'a t -> 'a t -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val inter : 'a t -> 'a t -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val disjoint : 'a t -> 'a t -> bool
        [@@alert not_implemented "This function is not implemented yet"]

      val diff : 'a t -> 'a t -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val subt : 'a t -> 'a t -> bool
        [@@alert not_implemented "This function is not implemented yet"]

      val cardinal : 'a t -> int
        [@@alert not_implemented "This function is not implemented yet"]

      val choose : 'a t -> int
        [@@alert not_implemented "This function is not implemented yet"]

      val choose_opt : 'a t -> 'a option
        [@@alert not_implemented "This function is not implemented yet"]

      val map : ('a -> 'b) -> 'a t -> 'b t
        [@@alert not_implemented "This function is not implemented yet"]

      val fold : ('b -> 'a -> 'a) -> 'b t -> 'a -> 'a
        [@@alert not_implemented "This function is not implemented yet"]

      val for_all : ('a -> bool) -> 'a t -> bool
        [@@alert not_implemented "This function is not implemented yet"]

      val _exists : ('a -> bool) -> 'a t -> bool
        [@@alert not_implemented "This function is not implemented yet"]

      val filter : ('a -> bool) -> 'a t -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val filter_map : ('a -> 'b option) -> 'a t -> 'b t
        [@@alert not_implemented "This function is not implemented yet"]

      val partition : ('a -> bool) -> 'a t -> 'a t * 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val to_list : 'a t -> 'a list
        [@@alert not_implemented "This function is not implemented yet"]

      val of_list : 'a list -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]

      val to_seq : 'a t -> 'a sequence
        [@@alert not_implemented "This function is not implemented yet"]

      val of_seq : 'a sequence -> 'a t
        [@@alert not_implemented "This function is not implemented yet"]
    end

    val __mix_Bmgb (* [->] *) : ('a -> 'b) -> 'a -> 'b -> ('a -> 'b)
      [@@alert not_implemented "This function is not implemented yet"]
      (* and it is not clear how it should be implemented in Ortac *)

    module Map : sig
    end

    module Order : sig
      val is_pre_order : ('a -> 'a -> int) -> bool
        [@@alert not_implemented "This function cannot be implemented in Ortac"]
        (** This function cannot be implemented as a test in Ortac! *)
    end

    module Sys : sig
      val big_endian : bool
      val int_size : int
      val max_array_length : int
      val max_string_length : int
      val word_size : int
    end
  end

  module Z : sig
    val exists : integer -> integer -> (integer -> bool) -> bool
    (** [exists i j p] is [true] iff the predicate there exists [k] within [i]
        and [j], included, for which [p] holds. *)

    val forall : integer -> integer -> (integer -> bool) -> bool
    (** [forall i j p] is [true] iff the predicate `p` holds forall [k] within
        [i] and [j], included. *)
  end
end
