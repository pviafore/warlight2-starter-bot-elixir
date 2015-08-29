defmodule GameState do

def initial() do
    %{:timebank => 0}
end
def set_timebank(state, time) do
  %{state | :timebank => time}
end


end
