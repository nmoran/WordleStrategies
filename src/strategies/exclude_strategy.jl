export ExcludeStrategy

mutable struct ExcludeStrategy <: AbstractStrategy
    excluded_letters::Set{Char}
    words::Vector{String}
    ExcludeStrategy() = new(Set{Char}(), valid_words)
end

function guess(s::ExcludeStrategy)
    @assert(length(s.words) > 0)
    word = rand(s.words)
    s.words = filter(x -> x != word, s.words)
    return word
end

function process_score(s::ExcludeStrategy, word, result)
    invalid_letters = [word[i] for i in 1:length(word) if result[i] == 0]
    s.excluded_letters = union(s.excluded_letters, invalid_letters)
    s.words = filter(x -> length(intersect(x, s.excluded_letters)) == 0, s.words)
    @debug "$(length(s.words)) valid words left after excluding those with $(invalid_letters)"
end
