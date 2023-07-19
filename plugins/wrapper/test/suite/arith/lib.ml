let test_forall _i _j = 42
let double_forall _i _j = 42

let rec power x n =
  if n = 0 then 1
  else
    let y = power x (n / 2) in
    if n mod 2 = 1 then x * y * y else y * y
