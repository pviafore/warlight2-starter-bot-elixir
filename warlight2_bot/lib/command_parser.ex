defmodule CommandParser do

  def start(game_engine, logger) do
      {:ok, parser} = Task.start_link(fn->parse(game_engine, logger) end)
      parser
  end

  def send_message(parser, m) do
      send parser, {:message, m}
  end

  def send_single_int(engine, regex, msg, atom) do
    matches = Regex.run(regex, msg)
    send engine, {atom, String.to_integer List.last(matches)}
  end

  def send_single_string(engine, regex, msg, atom) do
    matches = Regex.run(regex, msg)
    send engine, {atom, List.last(matches)}
  end

  def send_list(engine, regex, msg, atom) do
     matches = Regex.run(regex, msg)
     send engine, {atom, String.split(List.last(matches))}
  end

  def parse(game_engine, logger) do
     receive do
        {:message, msg} ->
            CustomLogger.write(logger, "Command received: " <> msg)
            cond do
            Regex.match?(~r/settings timebank (\d+)/, msg) ->
                 send_single_int game_engine, ~r/settings timebank (\d+)/, msg, :initial_timebank
            Regex.match?(~r/settings time_per_move (\d+)/, msg) ->
                 send_single_int game_engine, ~r/settings time_per_move (\d+)/, msg, :time_per_move
            Regex.match?(~r/settings max_rounds (\d+)/, msg) ->
                send_single_int game_engine, ~r/settings max_rounds (\d+)/, msg, :max_rounds
            Regex.match?(~r/settings your_bot (\w+)/, msg) ->
                send_single_string game_engine, ~r/settings your_bot (\w+)/, msg, :bot_name
            Regex.match?(~r/settings opponent_bot (\w+)/, msg) ->
                send_single_string game_engine, ~r/settings opponent_bot (\w+)/, msg, :opponent_bot_name
            Regex.match?(~r/settings starting_armies (\d+)/, msg) ->
                 send_single_int game_engine, ~r/settings starting_armies (\d+)/, msg, :starting_armies
            Regex.match?(~r/settings starting_regions ((?:\d+\s*)+)/, msg) ->
                 send_list game_engine, ~r/settings starting_regions ((?:\d+\s*)+)/, msg, :starting_regions
            Regex.match?(~r/settings/, msg) -> nil
            Regex.match?(~r/setup_map/, msg) -> nil
            Regex.match?(~r/update_map/, msg) -> nil
            Regex.match?(~r/opponent_moves/, msg) -> nil
            Regex.match?(~r/go place_armies \d+/, msg) ->
                send game_engine, {:place_armies, ""}
            Regex.match?(~r/go attack\/transfer \d+/, msg) ->
                send game_engine, {:attack_transfer, ""}
            Regex.match?(~r/pick_starting_region \d+ ((?:\d+ )+)/, msg) ->
                send_list game_engine, ~r/pick_starting_region \d+ ((?:\d+\s*)+)/, msg, :starting_region_choice
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
