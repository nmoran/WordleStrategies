using WordleStrategies
using Statistics

function report_stats(guesses)
    println("Mean: $(mean(guesses)), Median: $(median(guesses)), Min/Max: $(minimum(guesses))/$(maximum(guesses)), Std: $(std(guesses))")
end

@info "Test each strategy with game words"
@info "Test exclude strategy"
guesses1 = play_n_games(WordleStrategies.game_words, () -> ExcludeStrategy(), repeats=1);
@info "Test include exclude strategy"
guesses2 = play_n_games(WordleStrategies.game_words, () -> IncludeExcludeStrategy(), repeats=1);
@info "Test include exclude frequency strategy"
guesses3 = play_n_games(WordleStrategies.game_words, () -> IncludeExcludeFreqStrategy(), repeats=1);
@info "Test fnclude exclude frequency with position strategy"
guesses4 = play_n_games(WordleStrategies.game_words, () -> IncludeExcludeFreqStrategy(position=true), repeats=1);
report_stats(guesses1)
report_stats(guesses2)
report_stats(guesses3)
report_stats(guesses4)

@info "Test each strategy with full word list"
@info "Test exclude strategy"
guesses1 = play_n_games(WordleStrategies.valid_words, () -> ExcludeStrategy(), repeats=1);
@info "Test include exclude strategy"
guesses2 = play_n_games(WordleStrategies.valid_words, () -> IncludeExcludeStrategy(), repeats=1);
@info "Test include exclude frequency strategy"
guesses3 = play_n_games(WordleStrategies.valid_words, () -> IncludeExcludeFreqStrategy(), repeats=1);
@info "Test fnclude exclude frequency with position strategy"
guesses4 = play_n_games(WordleStrategies.valid_words, () -> IncludeExcludeFreqStrategy(position=true), repeats=1);
report_stats(guesses1)
report_stats(guesses2)
report_stats(guesses3)
report_stats(guesses4)

