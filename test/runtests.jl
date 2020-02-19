using Test

using Blind

using FileIO, CSVFiles

function test_output(path_key)
    @test isfile(path_key)

    # Check key file.
    for (original, blind) in CSVFiles.getiterator(load(path_key))

        # Check file record.
        @test isfile(blind)

        # Check file extensions.
        @test splitext(original)[2] == splitext(blind)[2]
    end
end

@testset "Blind" begin

    @testset "Name Generation" begin
        n = 4
        num_sets = 3
        num_numerics = 4

        strs = Blind.generate_names(n, num_sets, num_numerics)

        @show strs
        @test length(strs) == n
        @test length(unique(strs)) == n
        @test all((str)-> length(str) == num_sets * num_numerics + num_sets -1, strs)
    end #testset Name Generation

    files_original = [
        "f1.tif",
        "f2.tif",
        "f3.tif",
        "f4.tif",
    ]

    dir_input = abspath(joinpath(@__DIR__, "input"))

    mkpath(dir_input)
    paths_original = joinpath.(dir_input, files_original)
    touch.(paths_original)

    path_key = joinpath(dir_input, "key.csv")

    @testset "Procedure" begin

        dir_output = joinpath(@__DIR__, "output")

        blind(dir_input, dir_output, path_key)

        @test isdir(dir_output)

        test_output(path_key)

        # Clean up.
        rm(dir_output, recursive = true)
        rm(path_key)

    end # testset Procedure

    @testset "Script" begin
        script = joinpath(@__DIR__, "..", "blind.sh")

        if Sys.iswindows()
            run(`julia $script $dir_input`)
        else
            run(`bash $script $dir_input`)
        end

        dir_output = joinpath(@__DIR__, "input-blind")

        @test isdir(dir_output)

        test_output(path_key)

        # Clean up
        rm(dir_output, recursive = true)

    end #testset Script

    # Clean up
    rm(dir_input, recursive = true)

end # testset Blind
