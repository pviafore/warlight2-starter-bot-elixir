defmodule GameStateTest do
   use ExUnit.Case

   test "should have correct initial state" do
       assert %{:timebank => 0, :time_per_move => 0,
                :max_rounds => 0, :bot_name =>""} == GameState.initial()
   end
   test "should set timebank" do
       assert %{GameState.initial | :timebank => 1000} == GameState.initial() |> GameState.set_timebank 1000
       assert %{GameState.initial | :timebank => 100} == GameState.initial |> GameState.set_timebank(1000) |> GameState.set_timebank 100
   end

   test "should set time per move" do
       assert %{GameState.initial | :time_per_move=> 500} == GameState.initial() |> GameState.set_time_per_move 500
       assert %{GameState.initial | :time_per_move=> 50} == GameState.initial() |> GameState.set_time_per_move(500) |> GameState.set_time_per_move(50)
   end

   test "should set max rounds" do
      assert %{GameState.initial | :max_rounds => 100} == GameState.initial() |> GameState.set_max_rounds 100
      assert %{GameState.initial | :max_rounds => 200} == GameState.initial() |> GameState.set_max_rounds(100) |> GameState.set_max_rounds(200)
   end
end
