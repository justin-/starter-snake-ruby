# This function is called on every turn of a game. It's how your Battlesnake decides where to move.
# Valid moves are "up", "down", "left", or "right".
# TODO: Use the information in board to decide your next move.
def move(board)
  @board = board.with_indifferent_access
  puts board

  # Choose a random direction to move in
  possible_moves = ["up", "down", "left", "right"]
  move = possible_moves.sample

  puts "My snake: " + @my_snake

  @last_move = move
  puts "MOVE: " + move
  { "move": move }
end

def my_snake
  @my_snake ||= find_my_snake
end

def find_my_snake
  @board[:snakes].each do |snake|
    return snake if snake[:id] == @my_snake_id
  end
end
