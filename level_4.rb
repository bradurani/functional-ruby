#level 189493

require_relative 'solver.rb'

level_string = '--------oooo----
                --------oooo----
                ooo-----o--oooo-
                oSooooooo---oGo-
                ooo----ooo--ooo-
                ooo----ooo--ooo-
                -oo----o--------
                --oooooo--------
                ----------------
                ----------------'

best_solution = solve(level_string)
puts best_solution