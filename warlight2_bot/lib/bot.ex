
defmodule Bot do
   def main(_) do
      {:ok, logger} = CustomLogger.start()
      send logger, {:init, ""}
      run_input_loop(logger)
   end

   def run_input_loop(logger) do
      IO.puts :stderr, "RUNNING INPUT LOOP"
      command = IO.gets ""
      send logger, {:write, "Command received: " <> command}
      run_input_loop(logger)
   end

end
