require 'ostruct'
require 'hamster'



def solve(level_string)

    ##### Setup ######

    level_array = level_array(level_string)
    start_pos = find_char(level_array, 'S')
    goal_pos = find_char(level_array, 'G')

    ##### Functions ######

    is_on_board_func = is_on_board(level_array)
    is_goal_func = ->(block){ block.a == goal_pos && standing?(block) }

    start_block = block(start_pos, start_pos)
    starting_move_lists = Hamster.list(Hamster.list(move(nil, start_block)))

    #puts 'sequencing'
    sequence = move_sequence(starting_move_lists, is_on_board_func)

    # puts 'filtering'
    solutions = sequence.filter { |move_list| is_goal_func.call(move_list.head.block)}

    #puts 'taking first'
    best_solution = solutions.first

    raise 'Level has no solution' if(best_solution.nil?)

    best_solution.map(&:direction).reverse.remove { |item| item.nil? }
end

def move_sequence(move_lists, is_on_board_func)
    if(move_lists.any?)
        next_tier_of_moves = move_lists.flat_map { |move_list| legal_new_next_moves_list(move_list, is_on_board_func) }
        move_lists.concat( Hamster::Stream.new { move_sequence(next_tier_of_moves, is_on_board_func) })
    else
        Hamster.list
    end
end

######################## Position functions ###########################

def pos(row, column)
    OpenStruct.new({ row: row, column: column })
end

def is_on_board(level_array)
    ->(pos) {
        return false if (level_array.length == 0)
        return false if (level_array[0].length == 0)
        return false if (pos.row < 0 || pos.row >= level_array.length)
        return false if (pos.column < 0 || pos.column >= level_array[0].length)
        level_array[pos.row][pos.column] != '-'
    }
end

def infinite_board
    ->(pos){ true }
end

def left(pos)
    pos(pos.row, pos.column - 1)
end

def right(pos)
    pos(pos.row, pos.column + 1)
end

def up(pos)
    pos(pos.row - 1, pos.column)
end

def down(pos)
    pos(pos.row + 1, pos.column)
end

############ Block Functions ########

def block(posA, posB)
    OpenStruct.new({ a: posA, b: posB })
end

def standing?(block)
    block.a == block.b
end

def lying_vertically?(block)
    block.a.row < block.b.row
end

def lying_horizontally?(block)
    block.a.column < block.b.column
end

def move_left(block)
    if lying_horizontally?(block)
        block( left(block.a), left(left(block.b)) )
    elsif lying_vertically?(block)
        block( left(block.a), left(block.b) )
    elsif standing?(block)
        block( left(left(block.a)), left(block.b))
    end
end

def move_right(block)
    if lying_horizontally?(block)
        block( right(right(block.a)), right(block.b) )
    elsif lying_vertically?(block)
        block( right(block.a), right(block.b) )
    elsif standing?(block)
        block( right(block.a), right(right(block.b)) )
    end
end

def move_up(block)
    if lying_horizontally?(block)
        block( up(block.a), up(block.b) )
    elsif lying_vertically?(block)
        block( up(block.a), up(up(block.b)) )
    elsif standing?(block)
        block( up(up(block.a)), up(block.b) )
    end
end

def move_down(block)
    if lying_horizontally?(block)
        block( down(block.a), down(block.b) )
    elsif lying_vertically?(block)
        block( down(down(block.a)), down(block.b) )
    elsif standing?(block)
        block( down(block.a), down(down(block.b)) )
    end
end


############ SOLVER #############

def move(direction, new_block)
    OpenStruct.new({
                    direction: direction,
                    block: new_block
                   })
end

def moves(block)
    Hamster.list(
        move(:left, move_left(block)),
        move(:right, move_right(block)),
        move(:up, move_up(block)),
        move(:down, move_down(block))
    )
end

def legal_moves(block, is_on_board_func)
    moves(block).filter { |move| is_on_board_func.call(move.block.a) && is_on_board_func.call(move.block.b) }
end

def legal_new_next_moves_list(move_list, is_on_board_func)
    #puts 'new moves'
    legal_moves = legal_moves(move_list.head.block, is_on_board_func)
    already_visited_blocks = move_list.map(&:block)
    new_legal_moves = legal_moves.filter { |move| !already_visited_blocks.include? move.block }
    new_legal_moves.map { |move| move_list.cons(move) }
end


############ SETUP ###############

def level_array(level_string)
    level_string.split(/\r?\n/).map { |row| row.scan /-|\w/ }
end

def find_char(level_array, char)
    row_num = level_array.index { |row| row.include?(char) }
    column_num = level_array[row_num].index { |letter| letter == char }
    pos(row_num, column_num)
end

