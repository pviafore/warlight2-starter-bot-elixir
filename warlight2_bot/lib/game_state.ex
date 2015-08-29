defmodule GameState do

def initial() do
    %{:timebank => 0, :time_per_move=>0}
end
def set_timebank(state, time) do
  %{state | :timebank => time}
end

def set_time_per_move(state, time_per_move) do
  %{state | :time_per_move=> time_per_move}
end

end
