require_relative 'solver.rb'

level_string = '--SG--
                --oo--
                --oo--'

best_solution = solve(level_string)
puts best_solution