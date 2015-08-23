defmodule CommandParser do

  def start(game_engine, logger) do
      {:ok, parser} = Task.start_link(fn->parse(game_engine, logger) end)
      parser
  end

  def send_message(parser, m) do
      send parser, {:message, m}
  end

  def parse(game_engine, logger) do
     receive do
        {:message, msg} ->
            CustomLogger.write(logger, "Command received: " <> msg)
            cond do
            Regex.match?(~r/settings/, msg) -> nil
            Regex.match?(~r/setup_map/, msg) -> nil
            Regex.match?(~r/update_map/, msg) -> nil
            Regex.match?(~r/opponent_moves/, msg) -> nil
            Regex.match?(~r/go place_armies \d+/, msg) ->
                send game_engine, {:place_armies, ""}
            Regex.match?(~r/pick_starting_region \d+ ((?:\d+ )+)/, msg) ->
                matches = Regex.run(~r/pick_starting_region \d+ ((?:\d+\s*)+)/, msg)
                nums = String.split(List.last(matches))
                send game_engine, {:starting_region_choice, nums }
            true->
              CustomLogger.write(logger, "Command Parser didn't know how to parse message: " <> msg)
              send game_engine, {:error, "Invalid Message Received"}
            end
        _ -> CustomLogger.write(logger, "Command Parser received invalid command ")
             send game_engine, {:error, "Invalid Message Received"}
     end
     parse(game_engine, logger)
  end

end
