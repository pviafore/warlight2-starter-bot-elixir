defmodule GameStateTest do
   use ExUnit.Case

   test "should set timebank" do
       assert %{:timebank => 1000} == GameState.set_timebank(%{}, 1000)

   end
end
