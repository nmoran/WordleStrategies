abstract type AbstractStrategy end

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

function play_n_games(word_iter, strategy_func; repeats=1, kwargs...)
    n_words = length(word_iter)
    guesses = zeros(Float32, n_words)
    Threads.@threads for i in 1:n_words
        word = word_iter[i]
        total = 0
        for _ in 1:repeats
            strategy = strategy_func()
            total += play_game(word, strategy)
        end
        guesses[i] = total/repeats
    end
    return guesses
end
