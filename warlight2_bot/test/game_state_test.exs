defmodule GameStateTestMacro do


  defmacro test_state desc, setting, func, first_val, first_expected, second_val, second_expected do

    quote do
       test unquote(desc) do
          assert %{GameState.initial | unquote(setting) => unquote(first_expected)} ==  apply(GameState, unquote(func), [GameState.initial(), unquote(first_val)])
          assert %{GameState.initial | unquote(setting) => unquote(second_expected)} == apply(GameState, unquote(func), [apply(GameState, unquote(func), [GameState.initial(), unquote(first_val)]), unquote(second_val)])

       end
  end
    end

  defmacro test_state desc, setting, func, first_val, second_val do
     quote do
        test unquote(desc) do
           assert %{GameState.initial | unquote(setting) => unquote(first_val)} ==  apply(GameState, unquote(func), [GameState.initial(), unquote(first_val)])
           assert %{GameState.initial | unquote(setting) => unquote(second_val)} == apply(GameState, unquote(func), [apply(GameState, unquote(func), [GameState.initial(), unquote(first_val)]), unquote(second_val)])

        end
     end
  end


end

defmodule GameStateTest do
   use ExUnit.Case
   require GameStateTestMacro
   test "should have correct initial state" do
       assert %{:timebank => 0, :time_per_move => 0,
                :max_rounds => 0, :bot_name =>"",
                :opponent_bot_name => "",
                :starting_armies => 0,
                :starting_regions => [],
                :starting_pick_amount => 0,
                :map => {} } == GameState.initial()
   end

   GameStateTestMacro.test_state "should set timebank", :timebank, :set_timebank, 1000, 100
   GameStateTestMacro.test_state "should set time per move", :time_per_move, :set_time_per_move, 500, 50
   GameStateTestMacro.test_state "should set max rounds", :max_rounds, :set_max_rounds, 100, 200
   GameStateTestMacro.test_state "should set bot name", :bot_name, :set_bot_name,"bot1", "bot2"
   GameStateTestMacro.test_state "should set opponent name", :opponent_bot_name, :set_opponent_bot_name,"bot2", "bot1"
   GameStateTestMacro.test_state "should set starting armies", :starting_armies, :set_starting_armies,3, 5
   GameStateTestMacro.test_state "should set starting regions", :starting_regions, :set_starting_regions, [4], [4,12]
   GameStateTestMacro.test_state "should set starting pick amount", :starting_pick_amount, :set_starting_pick_amount, 1, 5
   GameStateTestMacro.test_state "should set superregions", :map, :set_super_regions, [["1",2], ["3", 4]], %{"1" => %{:bonus_armies => 2}, "3" => %{:bonus_armies =>4}}, [["1",2],["3",4],["5",6]], %{"1" => %{:bonus_armies => 2}, "3" => %{:bonus_armies =>4}, "5" => %{:bonus_armies=> 6}}


end
