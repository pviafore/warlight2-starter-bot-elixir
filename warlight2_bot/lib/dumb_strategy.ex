defmodule DumbStrategy do

    def start(outputter) do
        {:ok, logic} = Task.start_link(fn->recv(outputter) end)
        logic
    end

    def recv outputter do
        receive do
           {:pick_starting, {areas, state}} ->
                send outputter, {:message, List.first(areas)}
           {:place_armies, state} ->
                send outputter, {:message, "No Moves"}
           {:attack_transfer, state} ->
                send outputter, {:message, "No Moves"}
           _ ->
                send outputter, {:error, "Invalid Message Received"}
        end
        recv(outputter)
    end

end
