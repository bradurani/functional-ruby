require_relative 'solver.rb'

level_string = '--------ooooooo---
                --oooo--ooo--oo---
                --ooooooooo--oooo-
                --oSoo-------ooGo-
                --oooo-------oooo-
                --------------ooo-'

best_solution = solve(level_string)
puts best_solution