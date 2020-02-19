#!/bin/bash
#=
exec julia --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
=#

using Pkg
Pkg.activate(@__DIR__);

using Blind

parsed_args = Blind.parse_commandline()

blind(parsed_args)
