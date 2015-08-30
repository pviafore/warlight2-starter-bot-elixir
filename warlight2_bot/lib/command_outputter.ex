defmodule CommandOutputter do
   def start(logger) do
       {:ok, logic} = Task.start_link(fn->send_input(logger) end)
       logic
   end

   def send_input(logger) do
      receive do

         {:message, message} ->
               IO.puts message
               CustomLogger.write(logger, "Sent command to server " <> message)
         {:error, msg} -> CustomLogger.write(logger, "Error message received in Command Outputter " <> msg )
         _ -> CustomLogger.write("Command Outputter received invalid message ")
      end
      send_input(logger)
   end


end
