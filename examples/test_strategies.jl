using WordleStrategies
using Statistics

function report_stats(guesses)
    println("Mean: $(mean(guesses)), Min/Max: $(minimum(guesses))/$(maximum(guesses)), Std: $(std(guesses))")
end

@time guesses1 = play_n_games(WordleStrategies.game_words, () -> ExcludeStrategy(), repeats=1)
report_stats(guesses1)
@time guesses2 = play_n_games(WordleStrategies.game_words, () -> IncludeExcludeStrategy(), repeats=1)
report_stats(guesses2)
@time guesses3 = play_n_games(WordleStrategies.game_words, () -> IncludeExcludeFreqStrategy(), repeats=1)
report_stats(guesses3)
@time guesses4 = play_n_games(WordleStrategies.game_words, () -> IncludeExcludeFreqStrategy(position=true), repeats=1)
report_stats(guesses4)

