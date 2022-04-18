export IncludeExcludeStrategy
using StaticArrays

export IncludeExcludeStrategy

function Base.convert(::Type{Wordle}, s::String)
    @assert length(s) == n_letters
    Wordle(s...)
end

function Base.show(io::IO, w::Wordle)
    write(io, join(w))
end

mutable struct IncludeExcludeStrategy <: AbstractStrategy
    words::Vector{Wordle}
    excluded_letters::Set{Char}
    included_letters::Set{Char}
    known_values::MVector{n_letters, Char} # letters we know are in a given position
    known_excludes::SVector{n_letters, Set{Char}} # letters we know aren't in each position
    IncludeExcludeStrategy(words::Vector{String}) = new(words,
                                                        Set{Char}(),
                                                        Set{Char}(),
                                                        MVector{n_letters, Char}(repeat(' ', n_letters)...),
                                                        SVector{n_letters, Set{Char}}([Set{Char}() for _ in 1:n_letters]...))
    IncludeExcludeStrategy() = new(valid_words,
                                   Set{Char}(),
                                   Set{Char}(),
                                   MVector{n_letters, Char}(repeat(' ', n_letters)...),
                                   SVector{n_letters, Set{Char}}([Set{Char}() for _ in 1:n_letters]...))
end

function guess(s::IncludeExcludeStrategy)
    word = rand(s.words)
    s.words = filter(x -> x != word, s.words)
    return String(word)
end

function process_score(s::IncludeExcludeStrategy, word, result)
    new_updates = false
    for (pos, (c, r)) in enumerate(zip(word, result))
        if r == 0 && !(c in s.excluded_letters)
            push!(s.excluded_letters, c)
            new_updates = true
        elseif r == 1 && !(c in s.included_letters)
            push!(s.included_letters, c)
            push!(s.known_excludes[pos], c)
            new_updates = true
        elseif r == 2
            push!(s.included_letters, c)
            s.known_values[pos] = c
            new_updates = true
        end
    end
    if new_updates
        s.words = filter((x) -> _is_valid_word(s, x), s.words)
    end
    @debug "$(length(s.words)) valid words left after excluding latest"
end

function _is_valid_word(s::IncludeExcludeStrategy, word)
    for i in 1:n_letters
        # ensure letters in known positions match
        if s.known_values[i] != ' ' && word[i] != s.known_values[i]
            return false
        end
        # ensure we do not know that letter should not be in current position
        if word[i] in s.known_excludes[i] return false end
        if word[i] in s.excluded_letters return false end
    end
    for c in s.included_letters
        if !(c in word)
            return false
        end
    end
    return true
end