
defmodule Bot do
   def start() do
      IO.puts :stderr, "Starting bot"
      {:ok, file} = File.open "hello", [:write]
      IO.binwrite file, "world"
      run_input_loop()
   end

   def run_input_loop() do
      IO.puts :stderr, "RUNNING INPUT LOOP"
      command = IO.gets ""
      IO.puts :stderr, "Command received: " <> command
      run_input_loop()
   end

end
