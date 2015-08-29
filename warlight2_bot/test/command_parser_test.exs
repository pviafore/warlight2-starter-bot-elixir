defmodule CommandParserMacro do
   defmacro test_communication(desc, msg, atom, return_msg) do
      quote do
         test unquote(desc) do
             assert_command_parser_communication(unquote(msg), unquote(atom), unquote(return_msg))
         end
      end
   end
end

defmodule CommandParserTest do
    use ExUnit.Case
    require CommandParserMacro
    def empty_mailbox do
      receive do
         _ -> nil
      end
    end

    def assert_command_parser_communication(message, atom, expected) do
        command_parser = CommandParser.start(self(), spawn &empty_mailbox/0)
        CommandParser.send_message(command_parser, message)
        receive do
           {a, x} ->
                assert x == expected
                assert a == atom
           _ ->   assert false
        end

    end

    CommandParserMacro.test_communication "sending invalid message sends out error code", "INVALID MESSAGE", :error, "Invalid Message Received"
    CommandParserMacro.test_communication "Returns starting region list given a list",
                                          "pick_starting_region 10000 2 6 10 19 20 26 32 33 38 45 55 62",
                                          :starting_region_choice,
                                           ["2", "6", "10", "19", "20", "26","32", "33", "38", "45", "55", "62"]
    CommandParserMacro.test_communication "Returns armies to place", "go place_armies 10000", :place_armies, ""
    CommandParserMacro.test_communication "Returns attack/transfer", "go attack/transfer 10000", :attack_transfer, ""
    CommandParserMacro.test_communication "updates timebank", "settings timebank 1000", :initial_timebank, 1000
    CommandParserMacro.test_communication "updates time_per_move", "settings time_per_move 500", :time_per_move, 500
    CommandParserMacro.test_communication "updates max_round", "settings max_rounds 100", :max_rounds, 100

end
