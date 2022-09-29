using WordleStrategies

@time guesses = play_n_games(WordleStrategies.game_words, () -> RandomStrategy())

