require_relative 'solver.rb'
require "hamster/list"
require 'awesome_print'

describe 'level array' do
    it 'converts level string to array' do
        expect(level_array('--SG--
                            --oo--
                            --oo--')).to eql [['-', '-', 'S', 'G', '-', '-'],
                                              ['-', '-', 'o', 'o', '-', '-'],
                                              ['-', '-', 'o', 'o', '-', '-']]
    end
end

describe ' is_on_board function' do
    it 'returns a working position valid function' do
        level_array = [['-', '-', 'S', 'G', '-', '-'],
                       ['-', '-', 'o', 'o', '-', '-'],
                       ['-', '-', 'o', 'o', '-', '-']]
        is_on_board_func = is_on_board(level_array)
        expect(is_on_board_func.call(pos(0, 1))).to be false # -
        expect(is_on_board_func.call(pos(0, 2))).to be true # S
        expect(is_on_board_func.call(pos(0, 3))).to be true # T
        expect(is_on_board_func.call(pos(1, 2))).to be true # o
    end
end

describe 'find char' do
    it 'finds S' do
        level_array = [['-', '-', 'S', 'G', '-', '-'],
                       ['-', '-', 'o', 'o', '-', '-'],
                       ['-', '-', 'o', 'o', '-', '-']]
        pos = find_char(level_array, 'S')
        expect(pos.row).to be 0
        expect(pos.column).to be 2
    end
end

describe 'Moving' do
    it 'moves around' do
        level_array = [['-', '-', 'S', 'G', '-', '-'],
                       ['-', '-', 'o', 'o', '-', '-'],
                       ['-', '-', 'o', 'o', '-', '-']]
        start_pos = find_char(level_array, 'S')
        goal_pos =  find_char(level_array, 'G')
        final_block = move_up(move_right(move_left(move_right(move_down(move_up(move_down(block(start_pos, start_pos))))))))
        expect(final_block.a == goal_pos).to be
        expect(standing?(final_block)).to be
    end

    it 'finds legal moves' do
        level_array = [['-', '-', 'S', 'G', '-', '-'],
                       ['-', '-', 'o', 'o', '-', '-'],
                       ['-', '-', 'o', 'o', '-', '-']]
        start_pos = find_char(level_array, 'S')
        is_on_board_func = is_on_board(level_array)
        expect(legal_moves(block(start_pos, start_pos), is_on_board_func))
               .to eql  Hamster.list(
                         move(:down, move_down(block(start_pos, start_pos)))
                        )
    end

    #Uses infinite board!

    it 'creates list of next moves with history' do
        starting_list = Hamster.list move(nil, block(pos(10,10),pos(10,10)) )
        moves = legal_new_next_moves_list(starting_list, infinite_board)
        ap moves
        expect(moves.length).to eql 4
        expect(moves[0].length).to eql 2 #array of array of histories
        expect(moves[0][0].direction).to eql :left
        expect(moves[0][0].block).to eql block(pos(10, 8), pos(10, 9))
    end

    it 'creates list of next moves with history' do
        starting_list = Hamster.list move(nil, block(pos(10,10),pos(10,10)) )
        moves = legal_new_next_moves_list(starting_list, infinite_board)
        moves = legal_new_next_moves_list(moves[0], infinite_board)
        expect(moves.length).to eql 3
        expect(moves[0].length).to eql 3 #array of array of histories
        expect(moves[0][0].direction).to eql :left
        expect(moves[0][0].block).to eql block(pos(10, 7), pos(10, 7))
    end
end


describe 'setup' do
    it 'does set up and first move' do
        ##### Setup ######

        level_string =  '--SG--
                         --oo--
                         --oo--'

        level_array = level_array(level_string)
        start_pos = find_char(level_array, 'S')
        goal_pos = find_char(level_array, 'G')

        ##### Functions ######

        is_on_board_func = is_on_board(level_array)
        is_goal_func = ->(block){ block.a == goal_pos && standing?(block) }

        start_block = block(start_pos, start_pos)
        starting_move_lists = Hamster.list(Hamster.list(move(nil, start_block)))
        legal = legal_new_next_moves_list(starting_move_lists[0], is_on_board_func)
        expect(legal.length).to eql 1
        expect(legal[0].length).to eql 2
        expect(legal.head.head.direction).to eql :down
    end
end



describe 'solver' do
    it 'solves' do
        level_string =  '--SG--
                         --oo--
                         --oo--'
        best_solution = solve(level_string)
        expect(best_solution).to eql Hamster.list(:down, :right, :up)
    end
end
