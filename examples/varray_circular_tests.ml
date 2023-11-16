open Varray_circular_spec
let valid i s =
  try
    if
      let __t1__001_ =
        Ortac_runtime.Gospelstdlib.(<=)
          (Ortac_runtime.Gospelstdlib.integer_of_int 0) i in
      let __t2__002_ =
        Ortac_runtime.Gospelstdlib.(<=) i
          (Ortac_runtime.Gospelstdlib.Sequence.length s) in
      __t1__001_ && __t2__002_
    then true
    else false
  with
  | e ->
      raise
        (Ortac_runtime.Partial_function
           (e,
             {
               Ortac_runtime.start =
                 {
                   pos_fname = "varray_circular_spec.mli";
                   pos_lnum = 4;
                   pos_bol = 399;
                   pos_cnum = 407
                 };
               Ortac_runtime.stop =
                 {
                   pos_fname = "varray_circular_spec.mli";
                   pos_lnum = 4;
                   pos_bol = 399;
                   pos_cnum = 434
                 }
             }))
let inside i_1 s_1 =
  try
    if
      let __t1__003_ =
        Ortac_runtime.Gospelstdlib.(<=)
          (Ortac_runtime.Gospelstdlib.integer_of_int 0) i_1 in
      let __t2__004_ =
        Ortac_runtime.Gospelstdlib.(<) i_1
          (Ortac_runtime.Gospelstdlib.Sequence.length s_1) in
      __t1__003_ && __t2__004_
    then true
    else false
  with
  | e ->
      raise
        (Ortac_runtime.Partial_function
           (e,
             {
               Ortac_runtime.start =
                 {
                   pos_fname = "varray_circular_spec.mli";
                   pos_lnum = 8;
                   pos_bol = 855;
                   pos_cnum = 863
                 };
               Ortac_runtime.stop =
                 {
                   pos_fname = "varray_circular_spec.mli";
                   pos_lnum = 8;
                   pos_bol = 855;
                   pos_cnum = 889
                 }
             }))
let proj e =
  try e
  with
  | e ->
      raise
        (Ortac_runtime.Partial_function
           (e,
             {
               Ortac_runtime.start =
                 {
                   pos_fname = "varray_circular_spec.mli";
                   pos_lnum = 18;
                   pos_bol = 1611;
                   pos_cnum = 1651
                 };
               Ortac_runtime.stop =
                 {
                   pos_fname = "varray_circular_spec.mli";
                   pos_lnum = 18;
                   pos_bol = 1611;
                   pos_cnum = 1652
                 }
             }))
module Spec =
  struct
    open STM
    [@@@ocaml.warning "-26-27"]
    include Varray_incl
    type sut = char t
    type cmd =
      | Push_back of char elt 
      | Pop_back 
      | Push_front of char elt 
      | Pop_front 
      | Insert_at of int * char elt 
      | Pop_at of int 
      | Delete_at of int 
      | Get of int 
      | Set of int * char elt 
      | Length 
      | Is_empty 
      | Fill of int * int * char elt 
    let show_cmd cmd__005_ =
      match cmd__005_ with
      | Push_back x ->
          Format.asprintf "%s %a" "push_back"
            (Util.Pp.pp_elt Util.Pp.pp_char true) x
      | Pop_back -> Format.asprintf "%s" "pop_back"
      | Push_front x_1 ->
          Format.asprintf "%s %a" "push_front"
            (Util.Pp.pp_elt Util.Pp.pp_char true) x_1
      | Pop_front -> Format.asprintf "%s" "pop_front"
      | Insert_at (i_2, x_2) ->
          Format.asprintf "%s %a %a" "insert_at" (Util.Pp.pp_int true) i_2
            (Util.Pp.pp_elt Util.Pp.pp_char true) x_2
      | Pop_at i_3 ->
          Format.asprintf "%s %a" "pop_at" (Util.Pp.pp_int true) i_3
      | Delete_at i_4 ->
          Format.asprintf "%s %a" "delete_at" (Util.Pp.pp_int true) i_4
      | Get i_5 -> Format.asprintf "%s %a" "get" (Util.Pp.pp_int true) i_5
      | Set (i_6, v) ->
          Format.asprintf "%s %a %a" "set" (Util.Pp.pp_int true) i_6
            (Util.Pp.pp_elt Util.Pp.pp_char true) v
      | Length -> Format.asprintf "%s" "length"
      | Is_empty -> Format.asprintf "%s" "is_empty"
      | Fill (pos, len, x_3) ->
          Format.asprintf "%s %a %a %a" "fill" (Util.Pp.pp_int true) pos
            (Util.Pp.pp_int true) len (Util.Pp.pp_elt Util.Pp.pp_char true)
            x_3
    type nonrec state = {
      contents: char Ortac_runtime.Gospelstdlib.sequence }
    let init_state =
      let n = 42
      and x_8 = 'a' in
      {
        contents =
          (try
             Ortac_runtime.Gospelstdlib.Sequence.init
               (Ortac_runtime.Gospelstdlib.integer_of_int n)
               (fun _ -> proj x_8)
           with
           | e ->
               raise
                 (Ortac_runtime.Partial_function
                    (e,
                      {
                        Ortac_runtime.start =
                          {
                            pos_fname = "varray_circular_spec.mli";
                            pos_lnum = 158;
                            pos_bol = 9586;
                            pos_cnum = 9613
                          };
                        Ortac_runtime.stop =
                          {
                            pos_fname = "varray_circular_spec.mli";
                            pos_lnum = 158;
                            pos_bol = 9586;
                            pos_cnum = 9646
                          }
                      })))
      }
    let init_sut () = make 42 'a'
    let cleanup _ = ()
    let arb_cmd _ =
      let open QCheck in
        make ~print:show_cmd
          (let open Gen in
             oneof
               [(pure (fun x -> Push_back x)) <*> (elt char);
               pure Pop_back;
               (pure (fun x_1 -> Push_front x_1)) <*> (elt char);
               pure Pop_front;
               ((pure (fun i_2 -> fun x_2 -> Insert_at (i_2, x_2))) <*> int)
                 <*> (elt char);
               (pure (fun i_3 -> Pop_at i_3)) <*> int;
               (pure (fun i_4 -> Delete_at i_4)) <*> int;
               (pure (fun i_5 -> Get i_5)) <*> int;
               ((pure (fun i_6 -> fun v -> Set (i_6, v))) <*> int) <*>
                 (elt char);
               pure Length;
               pure Is_empty;
               (((pure
                    (fun pos -> fun len -> fun x_3 -> Fill (pos, len, x_3)))
                   <*> int)
                  <*> int)
                 <*> (elt char)])
    let next_state cmd__006_ state__007_ =
      match cmd__006_ with
      | Push_back x ->
          {
            contents =
              ((try
                  Ortac_runtime.Gospelstdlib.Sequence.snoc
                    state__007_.contents (proj x)
                with
                | e ->
                    raise
                      (Ortac_runtime.Partial_function
                         (e,
                           {
                             Ortac_runtime.start =
                               {
                                 pos_fname = "varray_circular_spec.mli";
                                 pos_lnum = 27;
                                 pos_bol = 2110;
                                 pos_cnum = 2137
                               };
                             Ortac_runtime.stop =
                               {
                                 pos_fname = "varray_circular_spec.mli";
                                 pos_lnum = 27;
                                 pos_bol = 2110;
                                 pos_cnum = 2176
                               }
                           }))))
          }
      | Pop_back ->
          {
            contents =
              ((try
                  if
                    state__007_.contents =
                      Ortac_runtime.Gospelstdlib.Sequence.empty
                  then Ortac_runtime.Gospelstdlib.Sequence.empty
                  else
                    Ortac_runtime.Gospelstdlib.__mix_Bddub
                      state__007_.contents
                      (Ortac_runtime.Gospelstdlib.(-)
                         (Ortac_runtime.Gospelstdlib.Sequence.length
                            state__007_.contents)
                         (Ortac_runtime.Gospelstdlib.integer_of_int 2))
                with
                | e ->
                    raise
                      (Ortac_runtime.Partial_function
                         (e,
                           {
                             Ortac_runtime.start =
                               {
                                 pos_fname = "varray_circular_spec.mli";
                                 pos_lnum = 34;
                                 pos_bol = 2623;
                                 pos_cnum = 2650
                               };
                             Ortac_runtime.stop =
                               {
                                 pos_fname = "varray_circular_spec.mli";
                                 pos_lnum = 36;
                                 pos_bol = 2732;
                                 pos_cnum = 2820
                               }
                           }))))
          }
      | Push_front x_1 ->
          {
            contents =
              ((try
                  Ortac_runtime.Gospelstdlib.Sequence.cons (proj x_1)
                    state__007_.contents
                with
                | e ->
                    raise
                      (Ortac_runtime.Partial_function
                         (e,
                           {
                             Ortac_runtime.start =
                               {
                                 pos_fname = "varray_circular_spec.mli";
                                 pos_lnum = 48;
                                 pos_bol = 3607;
                                 pos_cnum = 3634
                               };
                             Ortac_runtime.stop =
                               {
                                 pos_fname = "varray_circular_spec.mli";
                                 pos_lnum = 48;
                                 pos_bol = 3607;
                                 pos_cnum = 3673
                               }
                           }))))
          }
      | Pop_front ->
          {
            contents =
              ((try
                  if
                    state__007_.contents =
                      Ortac_runtime.Gospelstdlib.Sequence.empty
                  then Ortac_runtime.Gospelstdlib.Sequence.empty
                  else
                    Ortac_runtime.Gospelstdlib.Sequence.tl
                      state__007_.contents
                with
                | e ->
                    raise
                      (Ortac_runtime.Partial_function
                         (e,
                           {
                             Ortac_runtime.start =
                               {
                                 pos_fname = "varray_circular_spec.mli";
                                 pos_lnum = 57;
                                 pos_bol = 4195;
                                 pos_cnum = 4222
                               };
                             Ortac_runtime.stop =
                               {
                                 pos_fname = "varray_circular_spec.mli";
                                 pos_lnum = 59;
                                 pos_bol = 4304;
                                 pos_cnum = 4364
                               }
                           }))))
          }
      | Insert_at (i_2, x_2) ->
          if
            (try
               (valid (Ortac_runtime.Gospelstdlib.integer_of_int i_2)
                  state__007_.contents)
                 = true
             with
             | e ->
                 raise
                   (Ortac_runtime.Partial_function
                      (e,
                        {
                          Ortac_runtime.start =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 76;
                              pos_bol = 5265;
                              pos_cnum = 5278
                            };
                          Ortac_runtime.stop =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 76;
                              pos_bol = 5265;
                              pos_cnum = 5296
                            }
                        })))
          then
            {
              contents =
                ((try
                    if
                      (valid (Ortac_runtime.Gospelstdlib.integer_of_int i_2)
                         state__007_.contents)
                        = true
                    then
                      Ortac_runtime.Gospelstdlib.(++)
                        (Ortac_runtime.Gospelstdlib.__mix_Bddub
                           state__007_.contents
                           (Ortac_runtime.Gospelstdlib.(-)
                              (Ortac_runtime.Gospelstdlib.integer_of_int i_2)
                              (Ortac_runtime.Gospelstdlib.integer_of_int 1)))
                        (Ortac_runtime.Gospelstdlib.Sequence.cons (proj x_2)
                           (Ortac_runtime.Gospelstdlib.__mix_Buddb
                              state__007_.contents
                              (Ortac_runtime.Gospelstdlib.integer_of_int i_2)))
                    else state__007_.contents
                  with
                  | e ->
                      raise
                        (Ortac_runtime.Partial_function
                           (e,
                             {
                               Ortac_runtime.start =
                                 {
                                   pos_fname = "varray_circular_spec.mli";
                                   pos_lnum = 78;
                                   pos_bol = 5323;
                                   pos_cnum = 5354
                                 };
                               Ortac_runtime.stop =
                                 {
                                   pos_fname = "varray_circular_spec.mli";
                                   pos_lnum = 80;
                                   pos_bol = 5478;
                                   pos_cnum = 5526
                                 }
                             }))))
            }
          else state__007_
      | Pop_at i_3 ->
          if
            (try
               (inside (Ortac_runtime.Gospelstdlib.integer_of_int i_3)
                  state__007_.contents)
                 = true
             with
             | e ->
                 raise
                   (Ortac_runtime.Partial_function
                      (e,
                        {
                          Ortac_runtime.start =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 93;
                              pos_bol = 6172;
                              pos_cnum = 6185
                            };
                          Ortac_runtime.stop =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 93;
                              pos_bol = 6172;
                              pos_cnum = 6204
                            }
                        })))
          then
            {
              contents =
                ((try
                    Ortac_runtime.Gospelstdlib.(++)
                      (Ortac_runtime.Gospelstdlib.__mix_Bddub
                         state__007_.contents
                         (Ortac_runtime.Gospelstdlib.(-)
                            (Ortac_runtime.Gospelstdlib.integer_of_int i_3)
                            (Ortac_runtime.Gospelstdlib.integer_of_int 1)))
                      (Ortac_runtime.Gospelstdlib.__mix_Buddb
                         state__007_.contents
                         (Ortac_runtime.Gospelstdlib.(+)
                            (Ortac_runtime.Gospelstdlib.integer_of_int i_3)
                            (Ortac_runtime.Gospelstdlib.integer_of_int 1)))
                  with
                  | e ->
                      raise
                        (Ortac_runtime.Partial_function
                           (e,
                             {
                               Ortac_runtime.start =
                                 {
                                   pos_fname = "varray_circular_spec.mli";
                                   pos_lnum = 95;
                                   pos_bol = 6231;
                                   pos_cnum = 6283
                                 };
                               Ortac_runtime.stop =
                                 {
                                   pos_fname = "varray_circular_spec.mli";
                                   pos_lnum = 95;
                                   pos_bol = 6231;
                                   pos_cnum = 6285
                                 }
                             }))))
            }
          else state__007_
      | Delete_at i_4 ->
          if
            (try
               (inside (Ortac_runtime.Gospelstdlib.integer_of_int i_4)
                  state__007_.contents)
                 = true
             with
             | e ->
                 raise
                   (Ortac_runtime.Partial_function
                      (e,
                        {
                          Ortac_runtime.start =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 106;
                              pos_bol = 6871;
                              pos_cnum = 6884
                            };
                          Ortac_runtime.stop =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 106;
                              pos_bol = 6871;
                              pos_cnum = 6903
                            }
                        })))
          then
            {
              contents =
                ((try
                    Ortac_runtime.Gospelstdlib.(++)
                      (Ortac_runtime.Gospelstdlib.__mix_Bddub
                         state__007_.contents
                         (Ortac_runtime.Gospelstdlib.(-)
                            (Ortac_runtime.Gospelstdlib.integer_of_int i_4)
                            (Ortac_runtime.Gospelstdlib.integer_of_int 1)))
                      (Ortac_runtime.Gospelstdlib.__mix_Buddb
                         state__007_.contents
                         (Ortac_runtime.Gospelstdlib.(+)
                            (Ortac_runtime.Gospelstdlib.integer_of_int i_4)
                            (Ortac_runtime.Gospelstdlib.integer_of_int 1)))
                  with
                  | e ->
                      raise
                        (Ortac_runtime.Partial_function
                           (e,
                             {
                               Ortac_runtime.start =
                                 {
                                   pos_fname = "varray_circular_spec.mli";
                                   pos_lnum = 108;
                                   pos_bol = 6930;
                                   pos_cnum = 6982
                                 };
                               Ortac_runtime.stop =
                                 {
                                   pos_fname = "varray_circular_spec.mli";
                                   pos_lnum = 108;
                                   pos_bol = 6930;
                                   pos_cnum = 6984
                                 }
                             }))))
            }
          else state__007_
      | Get i_5 -> state__007_
      | Set (i_6, v) ->
          if
            (try
               (inside (Ortac_runtime.Gospelstdlib.integer_of_int i_6)
                  state__007_.contents)
                 = true
             with
             | e ->
                 raise
                   (Ortac_runtime.Partial_function
                      (e,
                        {
                          Ortac_runtime.start =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 141;
                              pos_bol = 8522;
                              pos_cnum = 8535
                            };
                          Ortac_runtime.stop =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 141;
                              pos_bol = 8522;
                              pos_cnum = 8554
                            }
                        })))
          then
            {
              contents =
                ((try
                    Ortac_runtime.Gospelstdlib.Sequence.set
                      state__007_.contents
                      (Ortac_runtime.Gospelstdlib.integer_of_int i_6)
                      (proj v)
                  with
                  | e ->
                      raise
                        (Ortac_runtime.Partial_function
                           (e,
                             {
                               Ortac_runtime.start =
                                 {
                                   pos_fname = "varray_circular_spec.mli";
                                   pos_lnum = 143;
                                   pos_bol = 8581;
                                   pos_cnum = 8608
                                 };
                               Ortac_runtime.stop =
                                 {
                                   pos_fname = "varray_circular_spec.mli";
                                   pos_lnum = 143;
                                   pos_bol = 8581;
                                   pos_cnum = 8648
                                 }
                             }))))
            }
          else state__007_
      | Length -> state__007_
      | Is_empty -> state__007_
      | Fill (pos, len, x_3) ->
          if
            (try
               let __t1__010_ =
                 Ortac_runtime.Gospelstdlib.(<=)
                   (Ortac_runtime.Gospelstdlib.integer_of_int 0)
                   (Ortac_runtime.Gospelstdlib.integer_of_int pos) in
               let __t2__011_ =
                 let __t1__012_ =
                   Ortac_runtime.Gospelstdlib.(<=)
                     (Ortac_runtime.Gospelstdlib.integer_of_int 0)
                     (Ortac_runtime.Gospelstdlib.integer_of_int len) in
                 let __t2__013_ =
                   Ortac_runtime.Gospelstdlib.(<)
                     (Ortac_runtime.Gospelstdlib.(+)
                        (Ortac_runtime.Gospelstdlib.integer_of_int pos)
                        (Ortac_runtime.Gospelstdlib.integer_of_int len))
                     (Ortac_runtime.Gospelstdlib.Sequence.length
                        state__007_.contents) in
                 __t1__012_ && __t2__013_ in
               __t1__010_ && __t2__011_
             with
             | e ->
                 raise
                   (Ortac_runtime.Partial_function
                      (e,
                        {
                          Ortac_runtime.start =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 214;
                              pos_bol = 13339;
                              pos_cnum = 13352
                            };
                          Ortac_runtime.stop =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 214;
                              pos_bol = 13339;
                              pos_cnum = 13414
                            }
                        })))
          then
            {
              contents =
                ((try
                    Ortac_runtime.Gospelstdlib.Sequence.init
                      (Ortac_runtime.Gospelstdlib.Sequence.length
                         state__007_.contents)
                      (fun i_7 ->
                         if
                           let __t1__008_ =
                             Ortac_runtime.Gospelstdlib.(<) i_7
                               (Ortac_runtime.Gospelstdlib.integer_of_int pos) in
                           let __t2__009_ =
                             Ortac_runtime.Gospelstdlib.(>=) i_7
                               (Ortac_runtime.Gospelstdlib.(+)
                                  (Ortac_runtime.Gospelstdlib.integer_of_int
                                     pos)
                                  (Ortac_runtime.Gospelstdlib.integer_of_int
                                     len)) in
                           __t1__008_ || __t2__009_
                         then
                           Ortac_runtime.Gospelstdlib.__mix_Bub
                             state__007_.contents i_7
                         else proj x_3)
                  with
                  | e ->
                      raise
                        (Ortac_runtime.Partial_function
                           (e,
                             {
                               Ortac_runtime.start =
                                 {
                                   pos_fname = "varray_circular_spec.mli";
                                   pos_lnum = 216;
                                   pos_bol = 13441;
                                   pos_cnum = 13468
                                 };
                               Ortac_runtime.stop =
                                 {
                                   pos_fname = "varray_circular_spec.mli";
                                   pos_lnum = 216;
                                   pos_bol = 13441;
                                   pos_cnum = 13593
                                 }
                             }))))
            }
          else state__007_
    let precond cmd__026_ state__027_ =
      match cmd__026_ with
      | Push_back x -> true
      | Pop_back -> true
      | Push_front x_1 -> true
      | Pop_front -> true
      | Insert_at (i_2, x_2) -> true
      | Pop_at i_3 -> true
      | Delete_at i_4 -> true
      | Get i_5 -> true
      | Set (i_6, v) -> true
      | Length -> true
      | Is_empty -> true
      | Fill (pos, len, x_3) -> true
    let postcond cmd__014_ state__015_ res__016_ =
      let new_state__017_ = lazy (next_state cmd__014_ state__015_) in
      match (cmd__014_, res__016_) with
      | (Push_back x, Res ((Unit, _), _)) -> true
      | (Pop_back, Res ((Result (Elt (Char), Exn), _), x_4)) ->
          (match x_4 with
           | Ok x_4 ->
               (try
                  if
                    state__015_.contents =
                      Ortac_runtime.Gospelstdlib.Sequence.empty
                  then false
                  else
                    (proj x_4) =
                      (Ortac_runtime.Gospelstdlib.__mix_Bub
                         state__015_.contents
                         (Ortac_runtime.Gospelstdlib.(-)
                            (Ortac_runtime.Gospelstdlib.Sequence.length
                               state__015_.contents)
                            (Ortac_runtime.Gospelstdlib.integer_of_int 1)))
                with
                | e ->
                    raise
                      (Ortac_runtime.Partial_function
                         (e,
                           {
                             Ortac_runtime.start =
                               {
                                 pos_fname = "varray_circular_spec.mli";
                                 pos_lnum = 37;
                                 pos_bol = 2821;
                                 pos_cnum = 2835
                               };
                             Ortac_runtime.stop =
                               {
                                 pos_fname = "varray_circular_spec.mli";
                                 pos_lnum = 39;
                                 pos_bol = 2895;
                                 pos_cnum = 2977
                               }
                           })))
           | Error (Not_found) ->
               (try
                  let __t1__018_ =
                    (Lazy.force new_state__017_).contents =
                      state__015_.contents in
                  let __t2__019_ =
                    state__015_.contents =
                      Ortac_runtime.Gospelstdlib.Sequence.empty in
                  __t1__018_ && __t2__019_
                with
                | e ->
                    raise
                      (Ortac_runtime.Partial_function
                         (e,
                           {
                             Ortac_runtime.start =
                               {
                                 pos_fname = "varray_circular_spec.mli";
                                 pos_lnum = 40;
                                 pos_bol = 2978;
                                 pos_cnum = 3004
                               };
                             Ortac_runtime.stop =
                               {
                                 pos_fname = "varray_circular_spec.mli";
                                 pos_lnum = 40;
                                 pos_bol = 2978;
                                 pos_cnum = 3048
                               }
                           })))
           | _ -> false)
      | (Push_front x_1, Res ((Unit, _), _)) -> true
      | (Pop_front, Res ((Result (Elt (Char), Exn), _), x_5)) ->
          (match x_5 with
           | Ok x_5 ->
               (try
                  if
                    state__015_.contents =
                      Ortac_runtime.Gospelstdlib.Sequence.empty
                  then false
                  else
                    (proj x_5) =
                      (Ortac_runtime.Gospelstdlib.Sequence.hd
                         state__015_.contents)
                with
                | e ->
                    raise
                      (Ortac_runtime.Partial_function
                         (e,
                           {
                             Ortac_runtime.start =
                               {
                                 pos_fname = "varray_circular_spec.mli";
                                 pos_lnum = 60;
                                 pos_bol = 4365;
                                 pos_cnum = 4379
                               };
                             Ortac_runtime.stop =
                               {
                                 pos_fname = "varray_circular_spec.mli";
                                 pos_lnum = 62;
                                 pos_bol = 4439;
                                 pos_cnum = 4495
                               }
                           })))
           | Error (Not_found) ->
               (try
                  let __t1__020_ =
                    (Lazy.force new_state__017_).contents =
                      state__015_.contents in
                  let __t2__021_ =
                    state__015_.contents =
                      Ortac_runtime.Gospelstdlib.Sequence.empty in
                  __t1__020_ && __t2__021_
                with
                | e ->
                    raise
                      (Ortac_runtime.Partial_function
                         (e,
                           {
                             Ortac_runtime.start =
                               {
                                 pos_fname = "varray_circular_spec.mli";
                                 pos_lnum = 63;
                                 pos_bol = 4496;
                                 pos_cnum = 4522
                               };
                             Ortac_runtime.stop =
                               {
                                 pos_fname = "varray_circular_spec.mli";
                                 pos_lnum = 63;
                                 pos_bol = 4496;
                                 pos_cnum = 4566
                               }
                           })))
           | _ -> false)
      | (Insert_at (i_2, x_2), Res ((Result (Unit, Exn), _), res)) ->
          if
            (try
               (valid (Ortac_runtime.Gospelstdlib.integer_of_int i_2)
                  state__015_.contents)
                 = true
             with
             | e ->
                 raise
                   (Ortac_runtime.Partial_function
                      (e,
                        {
                          Ortac_runtime.start =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 76;
                              pos_bol = 5265;
                              pos_cnum = 5278
                            };
                          Ortac_runtime.stop =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 76;
                              pos_bol = 5265;
                              pos_cnum = 5296
                            }
                        })))
          then (match res with | Ok _ -> true | _ -> false)
          else
            (match res with | Error (Invalid_argument _) -> true | _ -> false)
      | (Pop_at i_3, Res ((Result (Elt (Char), Exn), _), x_6)) ->
          if
            (try
               (inside (Ortac_runtime.Gospelstdlib.integer_of_int i_3)
                  state__015_.contents)
                 = true
             with
             | e ->
                 raise
                   (Ortac_runtime.Partial_function
                      (e,
                        {
                          Ortac_runtime.start =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 93;
                              pos_bol = 6172;
                              pos_cnum = 6185
                            };
                          Ortac_runtime.stop =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 93;
                              pos_bol = 6172;
                              pos_cnum = 6204
                            }
                        })))
          then
            (match x_6 with
             | Ok x_6 ->
                 (try
                    (proj x_6) =
                      (Ortac_runtime.Gospelstdlib.__mix_Bub
                         state__015_.contents
                         (Ortac_runtime.Gospelstdlib.integer_of_int i_3))
                  with
                  | e ->
                      raise
                        (Ortac_runtime.Partial_function
                           (e,
                             {
                               Ortac_runtime.start =
                                 {
                                   pos_fname = "varray_circular_spec.mli";
                                   pos_lnum = 96;
                                   pos_bol = 6309;
                                   pos_cnum = 6323
                                 };
                               Ortac_runtime.stop =
                                 {
                                   pos_fname = "varray_circular_spec.mli";
                                   pos_lnum = 96;
                                   pos_bol = 6309;
                                   pos_cnum = 6351
                                 }
                             })))
             | _ -> false)
          else
            (match x_6 with | Error (Invalid_argument _) -> true | _ -> false)
      | (Delete_at i_4, Res ((Result (Unit, Exn), _), res)) ->
          if
            (try
               (inside (Ortac_runtime.Gospelstdlib.integer_of_int i_4)
                  state__015_.contents)
                 = true
             with
             | e ->
                 raise
                   (Ortac_runtime.Partial_function
                      (e,
                        {
                          Ortac_runtime.start =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 106;
                              pos_bol = 6871;
                              pos_cnum = 6884
                            };
                          Ortac_runtime.stop =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 106;
                              pos_bol = 6871;
                              pos_cnum = 6903
                            }
                        })))
          then
            (match res with
             | Ok _ ->
                 (try
                    (Ortac_runtime.Gospelstdlib.Sequence.length
                       (Lazy.force new_state__017_).contents)
                      =
                      (Ortac_runtime.Gospelstdlib.(-)
                         (Ortac_runtime.Gospelstdlib.Sequence.length
                            state__015_.contents)
                         (Ortac_runtime.Gospelstdlib.integer_of_int 1))
                  with
                  | e ->
                      raise
                        (Ortac_runtime.Partial_function
                           (e,
                             {
                               Ortac_runtime.start =
                                 {
                                   pos_fname = "varray_circular_spec.mli";
                                   pos_lnum = 109;
                                   pos_bol = 7008;
                                   pos_cnum = 7022
                                 };
                               Ortac_runtime.stop =
                                 {
                                   pos_fname = "varray_circular_spec.mli";
                                   pos_lnum = 109;
                                   pos_bol = 7008;
                                   pos_cnum = 7087
                                 }
                             })))
             | _ -> false)
          else
            (match res with | Error (Invalid_argument _) -> true | _ -> false)
      | (Get i_5, Res ((Result (Elt (Char), Exn), _), x_7)) ->
          if
            (try
               (inside (Ortac_runtime.Gospelstdlib.integer_of_int i_5)
                  state__015_.contents)
                 = true
             with
             | e ->
                 raise
                   (Ortac_runtime.Partial_function
                      (e,
                        {
                          Ortac_runtime.start =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 132;
                              pos_bol = 8061;
                              pos_cnum = 8074
                            };
                          Ortac_runtime.stop =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 132;
                              pos_bol = 8061;
                              pos_cnum = 8093
                            }
                        })))
          then
            (match x_7 with
             | Ok x_7 ->
                 (try
                    (proj x_7) =
                      (Ortac_runtime.Gospelstdlib.__mix_Bub
                         (Lazy.force new_state__017_).contents
                         (Ortac_runtime.Gospelstdlib.integer_of_int i_5))
                  with
                  | e ->
                      raise
                        (Ortac_runtime.Partial_function
                           (e,
                             {
                               Ortac_runtime.start =
                                 {
                                   pos_fname = "varray_circular_spec.mli";
                                   pos_lnum = 131;
                                   pos_bol = 8022;
                                   pos_cnum = 8036
                                 };
                               Ortac_runtime.stop =
                                 {
                                   pos_fname = "varray_circular_spec.mli";
                                   pos_lnum = 131;
                                   pos_bol = 8022;
                                   pos_cnum = 8060
                                 }
                             })))
             | _ -> false)
          else
            (match x_7 with | Error (Invalid_argument _) -> true | _ -> false)
      | (Set (i_6, v), Res ((Result (Unit, Exn), _), res)) ->
          if
            (try
               (inside (Ortac_runtime.Gospelstdlib.integer_of_int i_6)
                  state__015_.contents)
                 = true
             with
             | e ->
                 raise
                   (Ortac_runtime.Partial_function
                      (e,
                        {
                          Ortac_runtime.start =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 141;
                              pos_bol = 8522;
                              pos_cnum = 8535
                            };
                          Ortac_runtime.stop =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 141;
                              pos_bol = 8522;
                              pos_cnum = 8554
                            }
                        })))
          then (match res with | Ok _ -> true | _ -> false)
          else
            (match res with | Error (Invalid_argument _) -> true | _ -> false)
      | (Length, Res ((Int, _), l)) ->
          (try
             (Ortac_runtime.Gospelstdlib.integer_of_int l) =
               (Ortac_runtime.Gospelstdlib.Sequence.length
                  (Lazy.force new_state__017_).contents)
           with
           | e ->
               raise
                 (Ortac_runtime.Partial_function
                    (e,
                      {
                        Ortac_runtime.start =
                          {
                            pos_fname = "varray_circular_spec.mli";
                            pos_lnum = 148;
                            pos_bol = 9079;
                            pos_cnum = 9093
                          };
                        Ortac_runtime.stop =
                          {
                            pos_fname = "varray_circular_spec.mli";
                            pos_lnum = 148;
                            pos_bol = 9079;
                            pos_cnum = 9123
                          }
                      })))
      | (Is_empty, Res ((Bool, _), b)) ->
          (try
             (b = true) =
               ((Lazy.force new_state__017_).contents =
                  Ortac_runtime.Gospelstdlib.Sequence.empty)
           with
           | e ->
               raise
                 (Ortac_runtime.Partial_function
                    (e,
                      {
                        Ortac_runtime.start =
                          {
                            pos_fname = "varray_circular_spec.mli";
                            pos_lnum = 175;
                            pos_bol = 10683;
                            pos_cnum = 10697
                          };
                        Ortac_runtime.stop =
                          {
                            pos_fname = "varray_circular_spec.mli";
                            pos_lnum = 175;
                            pos_bol = 10683;
                            pos_cnum = 10730
                          }
                      })))
      | (Fill (pos, len, x_3), Res ((Result (Unit, Exn), _), res)) ->
          if
            (try
               let __t1__022_ =
                 Ortac_runtime.Gospelstdlib.(<=)
                   (Ortac_runtime.Gospelstdlib.integer_of_int 0)
                   (Ortac_runtime.Gospelstdlib.integer_of_int pos) in
               let __t2__023_ =
                 let __t1__024_ =
                   Ortac_runtime.Gospelstdlib.(<=)
                     (Ortac_runtime.Gospelstdlib.integer_of_int 0)
                     (Ortac_runtime.Gospelstdlib.integer_of_int len) in
                 let __t2__025_ =
                   Ortac_runtime.Gospelstdlib.(<)
                     (Ortac_runtime.Gospelstdlib.(+)
                        (Ortac_runtime.Gospelstdlib.integer_of_int pos)
                        (Ortac_runtime.Gospelstdlib.integer_of_int len))
                     (Ortac_runtime.Gospelstdlib.Sequence.length
                        state__015_.contents) in
                 __t1__024_ && __t2__025_ in
               __t1__022_ && __t2__023_
             with
             | e ->
                 raise
                   (Ortac_runtime.Partial_function
                      (e,
                        {
                          Ortac_runtime.start =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 214;
                              pos_bol = 13339;
                              pos_cnum = 13352
                            };
                          Ortac_runtime.stop =
                            {
                              pos_fname = "varray_circular_spec.mli";
                              pos_lnum = 214;
                              pos_bol = 13339;
                              pos_cnum = 13414
                            }
                        })))
          then (match res with | Ok _ -> true | _ -> false)
          else
            (match res with | Error (Invalid_argument _) -> true | _ -> false)
      | _ -> true
    let run cmd__028_ sut__029_ =
      match cmd__028_ with
      | Push_back x -> Res (unit, (push_back sut__029_ x))
      | Pop_back ->
          Res
            ((result (elt char) exn),
              (protect (fun () -> pop_back sut__029_) ()))
      | Push_front x_1 -> Res (unit, (push_front sut__029_ x_1))
      | Pop_front ->
          Res
            ((result (elt char) exn),
              (protect (fun () -> pop_front sut__029_) ()))
      | Insert_at (i_2, x_2) ->
          Res
            ((result unit exn),
              (protect (fun () -> insert_at sut__029_ i_2 x_2) ()))
      | Pop_at i_3 ->
          Res
            ((result (elt char) exn),
              (protect (fun () -> pop_at sut__029_ i_3) ()))
      | Delete_at i_4 ->
          Res
            ((result unit exn),
              (protect (fun () -> delete_at sut__029_ i_4) ()))
      | Get i_5 ->
          Res
            ((result (elt char) exn),
              (protect (fun () -> get sut__029_ i_5) ()))
      | Set (i_6, v) ->
          Res
            ((result unit exn), (protect (fun () -> set sut__029_ i_6 v) ()))
      | Length -> Res (int, (length sut__029_))
      | Is_empty -> Res (bool, (is_empty sut__029_))
      | Fill (pos, len, x_3) ->
          Res
            ((result unit exn),
              (protect (fun () -> fill sut__029_ pos len x_3) ()))
  end
module STMTests = (STM_sequential.Make)(Spec)
let _ =
  QCheck_base_runner.run_tests_main
    (let count = 1000 in
     [STMTests.agree_test ~count ~name:"Varray_circular_spec STM tests"])
