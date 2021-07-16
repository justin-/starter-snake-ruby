def move(params)
  @board    = params[:board]
  @my_snake = params[:you]
  @my_head  = @my_snake[:head]
  @all_snakes = params[:board][:snakes]

  move =
    do_the_math(@board, @my_snake, @my_head, @all_snakes)

  { "move": move }
end

def do_the_math(board, my_snake, my_head, all_snakes)
  possible_moves = {
    left:  { x: my_head[:x] - 1 },
    right: { x: my_head[:x] + 1 },
    up:    { y: my_head[:y] + 1 },
    down:  { y: my_head[:y] - 1 }
  }

  possible_moves.each do |direction, delta|
    proposed_position = my_head.merge(delta)

    next if self?(my_snake, proposed_position)
    next if wall?(board, proposed_position)
    next if other_snake?(all_snakes, proposed_position)

    return direction.to_s
  end
end

def self?(my_snake, position)
  my_snake[:body].include?(position)
end

def wall?(board, position)
  board_boundaries = {
    x: { min: 0, max: board[:width] - 1 },
    y: { min: 0, max: board[:height] - 1 }
  }

  if ((position[:x] < board_boundaries[:x][:max]) && (position[:y] < board_boundaries[:y][:max])) &&
      ((position[:x] > board_boundaries[:x][:min]) && (position[:y] > board_boundaries[:y][:min]))
    false
  else
    true
  end
end

# TODO: Remove self
def other_snake?(snakes, position)
  snakes.each do |snake|
    return true if snake[:body].include?(position)
  end

  false
end
