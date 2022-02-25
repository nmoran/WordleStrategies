module WordleStrategies

using TimerOutputs
using Statistics
using Base.Threads

export load_words, score_guess, guess, process_score
export play_game, play_n_games

const to = TimerOutput()

include("base.jl")
include("exclude_strategy.jl")
include("include_exclude_strategy.jl")
include("include_exclude_freq.jl")

end # module
