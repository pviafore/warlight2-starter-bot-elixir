defmodule Bot do
   def main(_) do
      logger = CustomLogger.start()
      outputter = CommandOutputter.start(logger)
      logic = SimpleGameLogic.start(outputter)
      command_parser = CommandParser.start(logic, logger)
      run_input_loop(logger, command_parser)
   end

   def run_input_loop(logger, parser) do
      command = IO.gets ""
      send parser, command

      run_input_loop(logger, parser)
   end

end
