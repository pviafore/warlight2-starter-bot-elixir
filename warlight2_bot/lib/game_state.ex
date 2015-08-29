defmodule GameState do

def initial() do
    %{:timebank => 0, :time_per_move=>0,
      :max_rounds=> 0, :bot_name =>""}
end
def set_timebank(state, time) do
  %{state | :timebank => time}
end

def set_time_per_move(state, time_per_move) do
  %{state | :time_per_move=> time_per_move}
end

def set_max_rounds(state, max_rounds) do
  %{state | :max_rounds => max_rounds}
end

end
