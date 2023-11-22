# `ortac` examples

:warning: These examples use the development branch of `ortac`, you won't have
the same result with the released version. :warning:

This package centralises examples of libraries with their Gospel
specifications. `ortac` is then used to generate code with runtime assertion
checking. This is thought both as a learning ressource and a way to experiment
with the limitations of the `ortac` tool which is still quite young.

Specifications are written in a style that allows the use the `ortac` tool,
specifically the `qcheck-stm` plugin.

## `lwt_dllist` library

This is an example of relatively simple, yet not trivial, container library.
The specifications make use of the Gospel `sequence` type (for more information,
see [its documentation](https://ocaml-gospel.github.io/gospel/gospel/Gospelstdlib/Sequence/index.html).

Specifications for this library can be found in the edited copy of the
interface `lwt_dllist_spec.mli`. There is one modification of the actual
interface: the type `'a node` is not abstract anymore. This is necessary in
order to extend the `STM.ty` type with a `Node` constructor. For the
typechecker to accept this extension, the implementation of the `node` type
need to be visible.

The STM `postcond` function pattern match on the returned value encapsulated in
a `STM.ty`. As functions `add_l` and `add_r` both return the node that has been
added, we need to extend the `STM.ty` type with an encoding for
`Lwt_dllist.node`. We add this extension in the external module `Lwt_dllist_incl`
and pass it to the `--include` option of the `ortac qcheck-stm` command.

The generated code can be found in `lwt_dllist_tests.ml`. You can run the test
either with `dune runtest examples/` or by directly running the compiled
executable that you will find in your `_build` directory.

## `varray` library

This is an example of a library exposing Functor. In order to test a Functor,
it is necessary to instantiate it. The [`varray`](https://github.com/art-w/varray)
library already exposes some intantiations of its Functor. Here, we provide generated tests
for two of them.

The signature of the output of the Functor is originally placed in a `ml` file.
`varray_sig.ml` is a copy of this file with some specifications. As Gospel
doesn't process `ml` files, we extract the content of the module signature and
place a copy in two files: `varray_spec.mli` and `varray_circular_spec.mli`,
the former for the module exposed by `varray` as `Varray` and the latter for
the module exposed by `varray` as `Varray.Circular`. The corresponding `ml` files are
just the respective modules included.

Here again, as for the previous example, we need to include some code. That is the
extension of the `STM.ty` type. But also a `QCheck` generator for the `'a elt` type,
as some functions of the library take arguments of this type.

The generated code can be found in the respective `varray*tests.ml` files.
