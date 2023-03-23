open Gospel

type error

val subst :
  gos_t:Identifier.Ident.t ->
  old_t:Identifier.Ident.t option ->
  new_t:Identifier.Ident.t option ->
  Tterm.term ->
  (Tterm.term, error) result
