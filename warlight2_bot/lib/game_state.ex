defmodule GameStateMacro do

    defmacro create_updater(setting) do
       quote do
          def unquote(:"set_#{setting}")(state, val) do
              %{state | String.to_atom(unquote(setting)) => val}
          end
       end
    end

end
defmodule GameState do

    require GameStateMacro
    def initial() do
        %{:timebank => 0, :time_per_move=>0,
          :max_rounds=> 0, :bot_name =>"", :opponent_bot_name => "",
          :starting_armies => 0}
    end

    GameStateMacro.create_updater "timebank"
    GameStateMacro.create_updater "time_per_move"
    GameStateMacro.create_updater "max_rounds"
    GameStateMacro.create_updater "bot_name"
    GameStateMacro.create_updater "opponent_bot_name"
    GameStateMacro.create_updater "starting_armies"
end
