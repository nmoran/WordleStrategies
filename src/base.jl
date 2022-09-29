using ProgressMeter

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

function play_game(word, strategy::AbstractStrategy, max_guesses=Inf64)
    num_guesses = 1
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
    p = Progress(n_words)
    Threads.@threads for i in 1:n_words
        word = word_iter[i]
        total = 0
        for _ in 1:repeats
            strategy = strategy_func()
            total += play_game(word, strategy)
        end
        guesses[i] = total/repeats
        next!(p)
    end
    return guesses
end
