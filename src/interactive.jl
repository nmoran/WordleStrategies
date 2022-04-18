using REPL.TerminalMenus

export wordle

strategy_names = ["Exclude", "Include Exclude", "Include Exclude Frequency"]
strategy_menu = RadioMenu(strategy_names, pagesize=3)

function wordle()
    i = request("Strategy to use:", strategy_menu)
    strategy_name = strategy_names[i]
    @info("Picked $(strategy_name)")
    if strategy_name == "Exclude"
        s = ExcludeStrategy()
    elseif strategy_name == "Include Exclude"
        s = IncludeExcludeStrategy()
    elseif strategy_name == "Include Exclude Frequency"
        s = IncludeExcludeFreqStrategy()
    end
    playing = true
    iter = 1
    while playing
        g = guess(s)
        println("Guess $(iter): $(g)")
        println("Print scores returned by game ('0' gray, '1' yellow, '2' green):")
        result = get_result()
        if all(result .== 2)
            playing = false
        end
        process_score(s, g, result)
        iter += 1
    end
    println("Finished in $(iter) guesses")
end

function get_result()
    while true
        result = readline()
        try
            result = [parse(Int, l) for l in result]
            if !all([x in [0, 1, 2] for x in result]) || length(result) != n_letters
                println("Must only enter 0, 1 or 2 (no commas or spaces) and must be $(n_letters) entries")
            else
                return result
            end
        catch
            println("Could not convert input to numbers, ensure entry was valid")
        end
    end
end