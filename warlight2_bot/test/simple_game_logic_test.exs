defmodule SimpleGameLogicTest do
   use ExUnit.Case

   def assert_send_logic(logic, message, expected, atom) do
      send logic, message
      receive do
         {a, msg} ->
               assert msg == expected
               assert a == atom
         _ -> assert false, "Did not receive a well-formed message"
      end
      logic
   end

   def assert_send_logic(message, expected, atom) do
      logic = SimpleGameLogic.start self()
      assert_send_logic(logic, message, expected,atom)
   end


   test "should error out on invalid message" do
       assert_send_logic({:invalid, ""}, "Invalid Message Received", :error)
   end

   test "should pick first starting region" do
      assert_send_logic({:starting_region_choice, ["5", "7", "3", "1", "200", "12", "4"]}, "5", :message)
   end

   test "should pick a different first starting region" do
       assert_send_logic({:starting_region_choice, ["7", "3", "1", "200", "12", "4"]}, "7", :message)
   end

   test "placing armies should do nothing at all" do
       assert_send_logic({:place_armies, ""},  "No moves", :message)
   end

   test "attacking should do nothing at all" do
       assert_send_logic({:attack_transfer, ""},  "No moves", :message)
   end

   test "can get initial state" do
       assert_send_logic({:state, self()}, GameState.initial, :state)
   end

   test "should set timebank" do
       logic = SimpleGameLogic.start self()
       send logic, {:initial_timebank, 100}
       assert_send_logic(logic, {:state, self()},  GameState.initial |> GameState.set_timebank(100), :state)
   end

   test "should set time_per_move" do
       logic = SimpleGameLogic.start self()
       send logic, {:time_per_move, 50}
       assert_send_logic(logic, {:state, self()},  GameState.initial |> GameState.set_time_per_move(50), :state)
   end
end
