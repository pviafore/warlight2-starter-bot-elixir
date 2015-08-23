defmodule Bot do
   def main(_) do
      logger = CustomLogger.start()
      outputter = CommandOutputter.start(logger)
      logic = SimpleGameLogic.start(outputter)
      command_parser = CommandParser.start(logic, logger)
      run_input_loop( command_parser)
   end

   def run_input_loop(parser) do
      command = IO.gets ""
      CommandParser.send_message parser, command

      run_input_loop( parser)
   end

end
