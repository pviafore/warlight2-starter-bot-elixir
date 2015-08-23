defmodule SimpleGameLogic do

  def start(sender) do
      {:ok, logic} = Task.start_link(fn->recv(sender) end)
      logic
  end

  def recv(sender) do
      receive do
         {:starting_region_choice, list} -> send sender, {:message, List.first(list)}
         _ -> send sender, {:error, "Invalid Message Received"}
      end
      recv(sender)
  end


end
