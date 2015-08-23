
defmodule Bot do
   def main(_) do
      logger = CustomLogger.start()
      run_input_loop(logger)
   end

   def run_input_loop(logger) do
      IO.puts :stderr, "RUNNING INPUT LOOP"
      command = IO.gets ""
      CustomLogger.write(logger, "Command received: " <> command)
      run_input_loop(logger)
   end

end
