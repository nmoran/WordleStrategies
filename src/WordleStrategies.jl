module WordleStrategies

export load_words, score_guess, RandomStrategy, guess, process_score, play_game

function load_words()
    data_path = joinpath(dirname(dirname(@__FILE__)), "data")
    valid_words = open(joinpath(data_path, "valid_words.txt"), "r") do io
        readlines(io)
    end
    game_words = open(joinpath(data_path, "game_words.txt"), "r") do io
        readlines(io)
    end
    valid_words, game_words
end

const valid_words, game_words = load_words()

function score_guess(guess, hidden)
    """Score the guess on how well it matches. Returns array
    of same length with
    0: letter not in word
    1: letter in word but not right place
    2: letter in word and in the right place
    """
    n = length(hidden)
    @assert length(guess) == n "Word and guess must have same length"
    result = zeros(Int8, n)
    for (i, c) in enumerate(guess)
        positions = findall(c, hidden)
        if length(positions) > 0
            if i in positions
                result[i] = 2
            else
                result[i] = 1
            end
        end
    end
    return result
end

abstract type AbstractStrategy end

mutable struct RandomStrategy <: AbstractStrategy
    excluded_letters::Set{Char}
    words::Vector{String}
    RandomStrategy() = new(Set{Char}(), valid_words)
end

function guess(s::RandomStrategy)
    word = rand(s.words)
    s.words = filter(x -> x != word, s.words)
    return word
end

function process_score(s::RandomStrategy, word, result)
    invalid_letters = [word[i] for i in range(1, length(word)) if result[i] == 0]
    s.excluded_letters = union(s.excluded_letters, invalid_letters)
    s.words = filter(x -> length(intersect(x, s.excluded_letters)) == 0, s.words)
    @debug "$(length(s.words)) valid words left after excluding those with $(invalid_letters)"
end

function play_game(word, strategy, max_guesses=Inf64)
    num_guesses = 0
    while num_guesses < max_guesses
        w = guess(strategy)
        @debug "Guessing $(w)"
        if w == word
            break
        end
        result = score_guess(w, word)
        @debug "Result $(result)"
        process_score(strategy, w, result)
        num_guesses += 1
    end
    return num_guesses
end

end # module
