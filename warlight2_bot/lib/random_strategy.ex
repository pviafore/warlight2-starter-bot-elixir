defmodule RandomStrategy do

    def start(outputter) do
        {:ok, logic} = Task.start_link(fn->recv(outputter) end)
        logic
    end

    defp pick_random list do
      Enum.at(list, :random.uniform(length(list)) - 1)
    end

    defp get_own_areas(state) do
       Enum.map (Enum.filter state.ownership, (fn {area, {player_name, armies}} -> player_name == state.bot_name end)), &(elem(&1, 0))
    end

    defp place_armies_randomly_at_one_location(state) do
        own_areas = pick_random(get_own_areas state)
        state.bot_name <> " place_armies " <> List.first(get_own_areas state) <> " " <> Integer.to_string state.starting_armies
    end

    def recv outputter do
        :random.seed(:erlang.now)
        receive do
           {:pick_starting, {areas, state}} ->
                send outputter, {:message, pick_random areas}
           {:place_armies, state} ->
                msg = place_armies_randomly_at_one_location(state)
                send outputter, {:message, msg}
           {:attack_transfer, state} ->
                send outputter, {:message, "No Moves"}
           _ ->
                send outputter, {:error, "Invalid Message Received"}
        end
        recv(outputter)
    end

end
