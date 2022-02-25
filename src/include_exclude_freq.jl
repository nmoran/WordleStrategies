using DataStructures

export freq_sort_word_list, IncludeExcludeFreqStrategy

function freq_sort_word_list(words::Vector{String})
    # over all frequency
    letter_counts = DefaultDict{Char, Int}(0)
    for word in words
        for letter in word
            letter_counts[letter] += 1
        end
    end

    function word_score(w)
        occurences = counter(w)
        sum([letter_counts[c]/occurences[c] for c in w])
    end

    sort(words, by=word_score, rev=true)
end

function freq_position_sort_word_list(words::Vector{String})
    # over all frequency
    letter_counts = DefaultDict{Tuple{Char, Int}, Int}(0)
    for word in words
        for (i, letter) in enumerate(word)
            letter_counts[(letter, i)] += 1
        end
    end

    function word_score(w)
        occurences = counter(w)
        sum([letter_counts[(c, i)]/occurences[c] for (i, c) in enumerate(w)])
    end

    sort(words, by=word_score, rev=true)
end

const sorted_words = freq_sort_word_list(valid_words)
const sorted_position_words = freq_position_sort_word_list(valid_words)

struct IncludeExcludeFreqStrategy <: AbstractStrategy
    strategy::IncludeExcludeStrategy
    function IncludeExcludeFreqStrategy(;position::Bool=false)
        if !position
            stg = IncludeExcludeStrategy(sorted_words)
        else
            stg = IncludeExcludeStrategy(sorted_position_words)
        end
        new(stg)
    end
end

function guess(s::IncludeExcludeFreqStrategy)
    word = s.strategy.words[1]
    if length(s.strategy.words) > 1
        s.strategy.words = s.strategy.words[2:end]
    else
        s.strategy.words = Vector{Wordle}()
    end
    String(word)
end

process_score(s::IncludeExcludeFreqStrategy, args...) = process_score(s.strategy, args...)
