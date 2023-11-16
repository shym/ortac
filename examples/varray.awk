BEGIN {
  cpt = 0
}

cpt > 0 && $1 == "module"   { cpt++; print; next }
cpt > 0 && $1 == "end"      { cpt-- }
cpt > 0                     { print }
$0 == "module type S = sig" { cpt = 1 }

