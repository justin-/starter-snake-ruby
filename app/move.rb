def move(params)
  @board      = params[:board]
  @all_snakes = @board[:snakes]
  @my_snake   = params[:you]
  @my_head    = @my_snake[:head]

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

  safe_moves = []

  possible_moves.each do |direction, delta|
    proposed_position = my_head.merge(delta)

    next if self?(my_snake, proposed_position)
    next if wall?(board, proposed_position)
    next if other_snake?(all_snakes, my_snake, proposed_position)
    next if hazard?(board, proposed_position)

    safe_moves << direction.to_s
  end

  safe_moves.sample
end

def self?(my_snake, position)
  my_snake[:body].include?(position)
end

def wall?(board, position)
  board_boundaries = {
    x: { min: 0, max: board[:width] - 1 },
    y: { min: 0, max: board[:height] - 1 }
  }

  if ((position[:x] <= board_boundaries[:x][:max]) && (position[:y] <= board_boundaries[:y][:max])) &&
      ((position[:x] >= board_boundaries[:x][:min]) && (position[:y] >= board_boundaries[:y][:min]))
    false
  else
    true
  end
end

def other_snake?(all_snakes, my_snake, position)
  all_snakes.each do |snake|
    next if snake[:id] == my_snake[:id]

    return true if snake[:body].include?(position)
  end

  false
end

def hazard?(board, position)
  board[:hazards].include?(position)
end

def food?(board, position)
  # TODO: Check for other snake?
  board[:food].include?(position)
end
