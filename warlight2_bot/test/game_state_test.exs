defmodule GameStateTest do
   use ExUnit.Case

   test "should have correct initial state" do
       assert %{:timebank => 0} == GameState.initial()
   end
   test "should set timebank" do
       assert %{:timebank => 1000} == GameState.initial() |> GameState.set_timebank 1000
       assert %{:timebank => 100} == GameState.initial |> GameState.set_timebank(1000) |> GameState.set_timebank 100

   end
end
