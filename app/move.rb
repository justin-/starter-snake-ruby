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

  possible_moves.each do |direction, delta|
    proposed_position = my_head.merge(delta)

    next if self?(my_snake, proposed_position)
    next if wall?(board, proposed_position)
    next if other_snake?(all_snakes, my_snake, proposed_position) && !tail?(all_snakes, proposed_position)
    next if potential_head_collision?(all_snakes, my_snake, proposed_position)
    next if hazard?(board, proposed_position)

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

def potential_head_collision?(all_snakes, my_snake, position)
  other_snakes = []

  all_snakes.each do |snake|
    next if snake[:id] == my_snake[:id]

    other_snakes << snake
  end

  other_snakes.each do |other_snake|
    other_snake_head = other_snake[:body].first
    return true if (other_snake_head[:x] + 1) == position && !other_snake[:body].include?(position) && other_snake[:length] >= my_snake[:length]
    return true if (other_snake_head[:x] - 1) == position && !other_snake[:body].include?(position) && other_snake[:length] >= my_snake[:length]
    return true if (other_snake_head[:y] + 1) == position && !other_snake[:body].include?(position) && other_snake[:length] >= my_snake[:length]
    return true if (other_snake_head[:y] - 1) == position && !other_snake[:body].include?(position) && other_snake[:length] >= my_snake[:length]
  end

  false
end

def tail?(all_snakes, position)
  all_snakes.each do |snake|
    return true if snake[:body].last == position
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
