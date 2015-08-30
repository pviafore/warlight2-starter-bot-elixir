defmodule SimpleGameLogic do

  def start(player_strategy) do
      {:ok, logic} = Task.start_link(fn->recv(player_strategy, GameState.initial) end)
      logic
  end

  def recv(player_strategy, game_state) do
      receive do
         {:state, sender} -> send sender, {:state, game_state}
         {:initial_timebank, time} ->
            recv(player_strategy, GameState.set_timebank(game_state, time))
         {:time_per_move, time} ->
            recv(player_strategy, GameState.set_time_per_move(game_state, time))
         {:max_rounds, rounds} ->
            recv(player_strategy, GameState.set_max_rounds(game_state, rounds))
         {:bot_name, name} ->
            recv(player_strategy, GameState.set_bot_name(game_state, name))
         {:opponent_bot_name, name} ->
             recv(player_strategy, GameState.set_opponent_bot_name(game_state, name))
         {:starting_armies, num_armies} ->
             recv(player_strategy, GameState.set_starting_armies(game_state, num_armies))
         {:starting_regions, num_regions} ->
             recv(player_strategy, GameState.set_starting_regions(game_state, num_regions))
         {:starting_pick_amount, amount} ->
             recv(player_strategy, GameState.set_starting_pick_amount(game_state, amount))
         {:super_regions, super_regions} ->
             recv(player_strategy, GameState.set_super_regions(game_state, super_regions))
         {:regions, regions} ->
             recv(player_strategy, GameState.set_regions(game_state, regions))
         {:neighbors, neighbors} ->
             recv(player_strategy, GameState.set_neighbors(game_state, neighbors))
         {:wastelands, wastelands} ->
             recv(player_strategy, GameState.set_wastelands(game_state, wastelands))
         {:opponent_starting_regions, regions} ->
             recv(player_strategy, GameState.set_opponent_starting_regions(game_state, regions))
         {:starting_region_choice, list} ->
             send player_strategy, {:pick_starting, {list, game_state} }
         {:update_map, regions} ->
             recv(player_strategy, GameState.update_map(game_state, regions))
         {:last_opponent_moves, moves} ->
             recv(player_strategy, GameState.set_last_opponent_moves(game_state, moves))
         {:place_armies, _} -> send player_strategy, {:place_armies, game_state}
         {:attack_transfer, _} -> send player_strategy, {:attack_transfer,game_state}
         _ -> send player_strategy, {:error, "Invalid Message Received"}
      end
      recv(player_strategy, game_state)
  end


end
