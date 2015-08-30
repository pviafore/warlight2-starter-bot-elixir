defmodule RandomStrategy do

    def start(outputter) do
        {:ok, logic} = Task.start_link(fn->recv(outputter) end)
        logic
    end

    defp get_own_areas(state) do
       Enum.map (Enum.filter state.ownership, (fn {area, {player_name, armies}} -> player_name == state.bot_name end)), &(elem(&1, 0))
    end

    defp place_armies_randomly_at_one_location(state) do
        {:message, state.bot_name <> " " <> List.first(get_own_areas state) <> " " <> state.starting_armies}
    end

    def recv outputter do
        :random.seed(:erlang.now)
        receive do
           {:pick_starting, {areas, state}} ->
                send outputter, {:message, Enum.at(areas, :random.uniform(length(areas)) - 1)}
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
