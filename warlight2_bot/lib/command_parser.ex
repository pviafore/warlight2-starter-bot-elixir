defmodule CommandParser do

  def start(game_engine, logger) do
      {:ok, parser} = Task.start_link(fn->parse(game_engine, logger) end)
      parser
  end

  def send_message(parser, m) do
      send parser, {:message, m}
  end

  def send_int(engine, regex, msg, atom) do
    matches = Regex.run(regex, msg)
    send engine, {atom, String.to_integer List.last(matches)}
  end

  def send_string(engine, regex, msg, atom) do
    matches = Regex.run(regex, msg)
    send engine, {atom, List.last(matches)}
  end

  def send_list(engine, regex, msg, atom) do
     matches = Regex.run(regex, msg)
     send engine, {atom, String.split(List.last(matches))}
  end

  def handle(game_engine, _, ["pick_starting_region", _time | regions] ), do: send(game_engine, {:starting_region_choice, regions})
  def handle(game_engine, _, ["go", "attack/transfer" | _]), do: send(game_engine, {:attack_transfer, ""})
  def handle(game_engine, _, ["go", "place_armies" | _]), do: send(game_engine, {:place_armies, ""})
  def handle(game_engine, _, ["opponent_moves"  | msg]) do
     moves = msg |> Enum.chunk(5) |> Enum.map(fn [a,b,c,d,e] -> {a,b, c, d, String.to_integer e} end)
     send game_engine, {:last_opponent_moves, moves}
  end
  def handle(game_engine, _, ["update_map" | msg]) do
    send game_engine, {:update_map, msg |> Enum.chunk(3) |> Enum.map(fn [a, b, c] -> {a, b, String.to_integer c} end)}
  end

  def handle(game_engine, logger, msg) do
      CustomLogger.write(logger, "Command Parser didn't know how to parse message: " <> Enum.join msg, ",")
      send game_engine, {:error, "Invalid Message Received"}
  end

  def parse(game_engine, logger) do
     receive do
        {:message, msg} ->
            CustomLogger.write(logger, msg)
            split_msg = String.split msg
            cond do
            Regex.match?(~r/settings timebank (\d+)/, msg) ->
                 send_int game_engine, ~r/settings timebank (\d+)/, msg, :initial_timebank
            Regex.match?(~r/settings time_per_move (\d+)/, msg) ->
                 send_int game_engine, ~r/settings time_per_move (\d+)/, msg, :time_per_move
            Regex.match?(~r/settings max_rounds (\d+)/, msg) ->
                send_int game_engine, ~r/settings max_rounds (\d+)/, msg, :max_rounds
            Regex.match?(~r/settings your_bot (\w+)/, msg) ->
                send_string game_engine, ~r/settings your_bot (\w+)/, msg, :bot_name
            Regex.match?(~r/settings opponent_bot (\w+)/, msg) ->
                send_string game_engine, ~r/settings opponent_bot (\w+)/, msg, :opponent_bot_name
            Regex.match?(~r/settings starting_armies (\d+)/, msg) ->
                 send_int game_engine, ~r/settings starting_armies (\d+)/, msg, :starting_armies
            Regex.match?(~r/settings starting_regions ((?:\d+\s*)+)/, msg) ->
                 send_list game_engine, ~r/settings starting_regions ((?:\d+\s*)+)/, msg, :starting_regions
            Regex.match?(~r/settings starting_pick_amount (\d+)/, msg) ->
                 send_int game_engine, ~r/settings starting_pick_amount (\d+)/, msg, :starting_pick_amount
            Regex.match?(~r/setup_map super_regions ((?:\d+ \d+\s*)+)/, msg) ->
                 matches = Regex.run(~r/setup_map super_regions ((?:\d+ \d+\s*)+)/, msg)
                 convert_second_to_integer = fn([a,b]) -> [a, String.to_integer b] end
                 send game_engine, {:super_regions, matches |> List.last |> String.split |> Enum.chunk(2) |> Enum.map(convert_second_to_integer)}
            Regex.match?(~r/setup_map regions ((?:\d+ \d+\s*)+)/, msg) ->
                 matches = Regex.run(~r/setup_map regions ((?:\d+ \d+\s*)+)/, msg)
                 send game_engine, {:regions, matches |> List.last |> String.split |> Enum.chunk(2) |> Enum.map(&Enum.reverse/1) |> Enum.group_by(&List.first/1) |> Enum.map(fn { a, b} -> { a, Enum.sort(Enum.map(b, &List.last/1))} end) }
            Regex.match?(~r/setup_map neighbors ((?:\d+ (?:\d+,?)+\s*)+)/ ,msg) ->
                  matches = Regex.run(~r/setup_map neighbors ((?:\d+ (?:\d+,?)+\s*)+)/ ,msg)
                  neighbors = List.last(matches) |> String.split |> Enum.chunk(2) |> Enum.map(fn [a,b] -> {a, String.split( b, ",")} end)
                  send game_engine, {:neighbors, (for {key,val} <- neighbors, into: %{}, do: {key,val})}
            Regex.match?(~r/setup_map wastelands ((?:\d+\s*)+)/, msg) ->
                  send_list game_engine, ~r/setup_map wastelands ((?:\d+\s*)+)/, msg, :wastelands
            Regex.match?(~r/setup_map opponent_starting_regions ((?:\d+\s*)+)/, msg) ->
                  send_list game_engine, ~r/setup_map opponent_starting_regions ((?:\d+\s*)+)/, msg, :opponent_starting_regions
            true->
              handle game_engine, logger, split_msg
            end
        _ -> CustomLogger.write(logger, "Command Parser received invalid command ")
             send game_engine, {:error, "Invalid Message Received"}
     end
     parse(game_engine, logger)
  end

end
