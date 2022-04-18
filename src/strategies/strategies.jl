abstract type AbstractStrategy end

guess(s::AbstractStrategy)::String = "aaaaa"
process_score(_::AbstractStrategy, word, result) = nothing

function load_words()
    data_path = joinpath(dirname(dirname(dirname(@__FILE__))), "data")
    valid_words = open(joinpath(data_path, "valid_words.txt"), "r") do io
        readlines(io)
    end
    game_words = open(joinpath(data_path, "game_words.txt"), "r") do io
        readlines(io)
    end
    valid_words, game_words
end

const valid_words, game_words = load_words()

include("exclude_strategy.jl")
include("include_exclude_strategy.jl")
include("include_exclude_freq_strategy.jl")
include("min_entropy_strategy.jl")


