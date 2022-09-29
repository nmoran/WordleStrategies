module WordleStrategies

using TimerOutputs
using Statistics
using Base.Threads
using StaticArrays

export load_wods, score_guess, guess, process_score
export play_game, play_n_games

const to = TimerOutput()

const n_letters = 5
const Wordle = SVector{n_letters, Char}

include("strategies/strategies.jl")
include("base.jl")
include("interactive.jl")

end # module
