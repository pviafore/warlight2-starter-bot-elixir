defmodule GameState do

def set_timebank(state, initial_time) do
  Map.put_new state, :timebank,  initial_time
end


end
