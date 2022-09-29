# Julia Package for Evaluating Wordle Strategies

This package makes it easy to write and test [Wordle](https://www.nytimes.com/games/wordle/index.html) strategies. The aim is to be able to compare different strategies by evaluating their performance. It can also be used interactively as an assistant to help you play wordle.

## Installing

From the [Julia](www.julialang.org) REPL, using package mode it can be installed with

```
add https://github.com/nmoran/WordleStrategies.git
```

## Simple Example

To play a game with the IncludeExclude strategy and the word "cigar" can be achieved with

```
using WordleStrategies
strategy = IncludeExcludeStrategy()
play_game("cigar", strategy)
```

This will return a single number corresponding to the number of attempts it took. To get more verbose information one can enable debugging by setting the `JULIA_DEBUG` environment variable as

```
ENV["JULIA_DEBUG"] = WordleStrategies
```

More information on the workings of the IncludeExclude strategy and other strategies is given in the strategies section below.

## Evaluating a strategy

You may have noticed in the example above, the output is not deterministic. This is because the IncludeExclude strategy uses a random number generator to select which word (from the list of remaining valid words) to select at each turn. To get an idea of the typical performance of a strategy requires applying the strategy over and over again to a range of different words and compiling statistics. This can be achieved using the `play_n_games` methods, which returns an array of the number of attempts taken for each word.

```
using Statistics
results = play_n_games(WordleStrategies.game_words, IncludeExcludeStrategy)
mean(results)
```

## Strategies

Each strategy should inherit from the `AbstractStrategy` base structure and implement the methods:
- `guess`: return next word to guess
- `process_score`: update the strategy structure with output of previous guess

Performance of the strategies implemented on the list of game words.

| Strategy                                | Mean  | Std.  | min/max |
|-----------------------------------------|-------|-------|---------|
| Exclude                                 | 16.82 | 10.2  | 2/98    |
| Include Exclude                         | 5.28  |  1.5  | 2/12    |
| Include Exclude Frequency               | 4.95  |  1.5  | 2/12    |
| Include Exclude Frequency with Position | 4.86  |  1.48 | 2/12    |

A script called `test_strategies.jl` is provided in the examples folder which will reproduce the numbers in this table. Note that because of the stochastic nature of the first two strategies the numbers will likely vary slightly.

### Exclude Strategy

The exclude strategy maintains a list of possible words and at each guess randomly selects a word from this list. After an attempt, any words containing letters known not to be in word (gray squares) are removed.

### Include Exclude Strategy

Extends the exclude strategy, but removing any words that do not contain letters that are known to be in the word (green and yellow squares).

### Include Exclude Frequency Strategy

This strategy makes an additional change of scoring each remaining word according to how likely each of the letters are to appear and using this ranking to select the next word, instead of choosing at random.

## Compare Strategies

An example script called `test_strategies.jl` is provided to compare each of the strategies that have been implemented and output some summary statistics.

## Interactive

To use a particular strategy interactively simply launch with the `wordle()` method and follows the instructions provided.
