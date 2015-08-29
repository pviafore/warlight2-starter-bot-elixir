defmodule SimpleGameLogic do

  def start(command_outputter) do
      {:ok, logic} = Task.start_link(fn->recv(command_outputter, GameState.initial) end)
      logic
  end

  def recv(command_outputter, game_state) do
      receive do
         {:state, sender} -> send sender, {:state, game_state}
         {:initial_timebank, time} ->
            recv(command_outputter, GameState.set_timebank(game_state, time))
         {:time_per_move, time} ->
            recv(command_outputter, GameState.set_time_per_move(game_state, time))
         {:max_rounds, rounds} ->
            recv(command_outputter, GameState.set_max_rounds(game_state, rounds))
         {:bot_name, name} ->
            recv(command_outputter, GameState.set_bot_name(game_state, name))
         {:opponent_bot_name, name} ->
             recv(command_outputter, GameState.set_opponent_bot_name(game_state, name))
         {:starting_armies, num_armies} ->
             recv(command_outputter, GameState.set_starting_armies(game_state, num_armies))
         {:starting_regions, num_regions} ->
             recv(command_outputter, GameState.set_starting_regions(game_state, num_regions))
         {:starting_pick_amount, amount} ->
             recv(command_outputter, GameState.set_starting_pick_amount(game_state, amount))
         {:starting_region_choice, list} -> send command_outputter, {:message, List.first(list)}
         {:place_armies, _} -> send command_outputter, {:message, "No moves"}
         {:attack_transfer, _} -> send command_outputter, {:message, "No moves"}
         _ -> send command_outputter, {:error, "Invalid Message Received"}
      end
      recv(command_outputter, game_state)
  end


end
