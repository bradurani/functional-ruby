#level 189493

require_relative 'solver.rb'

level_string = '--------oooo----
                --------oooo----
                ooo-----o--oooo-
                ooooooooo---oGo-
                ooo----ooS--ooo-
                ooo----ooo--ooo-
                -ooo---o--------
                --oooooo--------
                ----------------
                ----------------'

best_solution = solve(level_string)
puts best_solution