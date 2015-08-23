defmodule CommandParserTest do
    use ExUnit.Case

    test "sending invalid message sends out error code" do
        command_parser = CommandParser.start(self())
        CommandParser.send_message(command_parser, "INVALID MESSAGE")
        receive do
           {:error, msg} -> assert msg == "Invalid Message Received"
           _ -> assert false, "Did not receive message as expected"
        end

    end

end
