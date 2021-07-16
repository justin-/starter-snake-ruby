def move(params)
  @board    = params[:board]
  @my_snake = params[:you]
  @my_head  = @my_snake[:head]

  move =
    avoid_wall(@board, @my_snake, @my_head)

  puts "MOVE: " + move
  { "move": move }
end

def avoid_wall(board, my_snake, my_head)
  possible_moves = {
    left:  { x: my_head[:x] - 1 },
    right: { x: my_head[:x] + 1 },
    up:    { y: my_head[:y] + 1 },
    down:  { y: my_head[:y] - 1 }
  }

  board_boundaries = {
    x: { min: 0, max: board[:width] - 1 },
    y: { min: 0, max: board[:height] - 1 }
  }

  possible_moves.each do |direction, delta|
    proposed_position = my_head.merge(delta)

    if ((proposed_position[:x] < board_boundaries[:x][:max]) && (proposed_position[:y] < board_boundaries[:y][:max])) &&
        ((proposed_position[:x] > board_boundaries[:x][:min]) && (proposed_position[:y] > board_boundaries[:y][:min])) &&
        !my_snake[:body].include?(proposed_position)
      return direction.to_s
    end
  end
end
