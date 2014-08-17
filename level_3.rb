#level 524383

require_relative 'solver.rb'

level_string = '-------oooooo--------
                -------o--ooo-------
                -------o--ooooo-----
                --Sooooo-----oooo---
                ------ooo----ooGo---
                ------ooo-----ooo---
                --------o--oo-------
                --------ooooo-------
                --------ooooo-------
                ---------ooo--------'

best_solution = solve(level_string)
puts best_solution