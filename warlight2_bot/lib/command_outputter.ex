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
         invalid -> CustomLogger.write(logger, "Invalid message received in Command Outputter " <> invalid )
      end
      send_input(logger)
   end


end
