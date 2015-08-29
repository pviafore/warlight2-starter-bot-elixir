defmodule CommandParserTest do
    use ExUnit.Case

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

    test "sending invalid message sends out error code" do
        assert_command_parser_communication("INVALID MESSAGE", :error, "Invalid Message Received")
    end

    test "Returns starting region list given a list" do
       assert_command_parser_communication("pick_starting_region 10000 2 6 10 19 20 26 32 33 38 45 55 62",
                                                  :starting_region_choice,
                                                  ["2", "6", "10", "19", "20", "26","32", "33", "38", "45", "55", "62"])
    end

    test "Returns armies to place" do
      assert_command_parser_communication("go place_armies 10000", :place_armies, "")
    end

    test "Returns attack/transfer" do
      assert_command_parser_communication("go attack/transfer 10000", :attack_transfer, "")
    end

    test "updates timebank" do
      assert_command_parser_communication("settings timebank 1000", :initial_timebank, 1000)
    end

    test "updates time_per_move" do
       assert_command_parser_communication("settings time_per_move 500", :time_per_move, 500)
    end

    test "updates max_round" do
       assert_command_parser_communication("settings max_rounds 100", :max_rounds, 100)
    end
end
