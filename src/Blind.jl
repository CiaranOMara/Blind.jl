module Blind

using Random

using ArgParse
using ProgressMeter

using FileIO, CSVFiles

export blind

DEFAULT_NUMERIC = 4
DEFAULT_SETS = 3

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
        "--sets", "-s"
            help = "Number of numeric sets."
            arg_type = Int
            default = DEFAULT_SETS
        "--numeric", "-n"
            help = "Number of numeric characters."
            arg_type = Int
            default = DEFAULT_NUMERIC
        "input"
            help = "Input directory."
            required = true
        "output"
            help = "Output directory."
            required = false
        "key"
            help = "Key file (.csv)."
            required = false
    end

    return parse_args(s)
end

function generate_names(n::Int, num_sets::Int, num_numeric::Int)
    strs = Vector{String}()

    @info "Generating $n strings with $num_sets sets of $num_numeric numerics."
    while length(strs) < n

        sets = [String(rand('0':'9', num_numeric)) for i in 1:num_sets]

        str = join(sets, "-")

        if !in(str, strs)
            push!(strs, str)
        end
    end

    return strs
end

function _nt(path_original::AbstractString, path_blind::AbstractString)
    return NamedTuple{(:original, :blind),Tuple{String,String}}((path_original, path_blind))
end

function check_dir_input(dir_input::AbstractString)
    isdir(dir_input) || error("Input $dir_input is not a directory.")
end

function generate_dir_output(dir_input::AbstractString)
    check_dir_input(dir_input)
    delim = contains(splitpath(dir_input)[end], " ") ? " " : "-"
    return rstrip(abspath(dir_input), only(Base.Filesystem.path_separator)) * delim * "blind"
end

function generate_path_key(dir_input::AbstractString)
    check_dir_input(dir_input)
    # return rstrip(abspath(dir_input), only(Base.Filesystem.path_separator)) * ".csv"
    return joinpath(dir_input, "key.csv")
end

function blind(dir_input::AbstractString, dir_output::AbstractString=generate_dir_output(dir_input), path_key::AbstractString=generate_path_key(dir_input); num_sets::Int = DEFAULT_SETS, num_numeric::Int = DEFAULT_NUMERIC)

    check_dir_input(dir_input)

    mkpath(dir_output)

    @info "Reading input $dir_input."
    files_original = readdir(dir_input)

    strs = generate_names(length(files_original), num_sets, num_numeric)
    exts = files_original .|> (str) ->(splitext(str)[2])

    files_blind = string.(strs, exts)

    paths_original = joinpath.(dir_input, files_original)
    paths_blind = joinpath.(dir_output, files_blind)

    @info "Copying to output $dir_output"
    @showprogress 1 for (path_original, path_blind) in zip(paths_original, paths_blind)
        cp(path_original, path_blind)
    end

    @info "Saving key to $path_key"
    nts = _nt.(paths_original, paths_blind)

    nts |> save(path_key)
end

function blind(dict::Dict)

    if dict["key"] === nothing
        dict["key"] = generate_path_key(dict["input"])
    end

    if dict["output"] === nothing
        dict["output"] = generate_dir_output(dict["input"])
    end

    return blind(dict["input"], dict["output"], dict["key"], num_sets = dict["sets"], num_numeric = dict["numeric"])
end

end # module
