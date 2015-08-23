defmodule SimpleGameLogic do

  def start(command_outputter) do
      {:ok, logic} = Task.start_link(fn->recv(command_outputter) end)
      logic
  end

  def recv(command_outputter) do
      receive do
         {:starting_region_choice, list} -> send command_outputter, {:message, List.first(list)}
         {:place_armies, _} -> send command_outputter, {:message, "No moves"}
         {:attack_transfer, _} -> send command_outputter, {:message, "No moves"}
         _ -> send command_outputter, {:error, "Invalid Message Received"}
      end
      recv(command_outputter)
  end


end
