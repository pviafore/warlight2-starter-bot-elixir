defmodule CommandParser do

  def start(game_engine, logger) do
      {:ok, parser} = Task.start_link(fn->parse(game_engine, logger) end)
      parser
  end

  def send_message(parser, message) do
      send parser, {:message, message}
  end

  def parse(game_engine, logger) do
     receive do
        {:message, msg} ->
            CustomLogger.write(logger, "Command received: " <> msg)
            cond do
            Regex.match?(~r/pick_starting_region \d+ ((?:\d+ )+)/, msg) ->
                matches = Regex.run(~r/pick_starting_region \d+ ((?:\d+\s*)+)/, msg)
                nums = String.split(List.last(matches))
                send game_engine, {:starting_region_choice, Enum.map(nums, &(String.to_integer &1)) }
            true->
              send game_engine, {:error, "Invalid Message Received"}
            end
     end
     parse(game_engine, logger)
  end

end
