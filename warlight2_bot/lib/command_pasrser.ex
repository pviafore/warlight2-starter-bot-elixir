defmodule CommandParser do

  def start(sender) do
      {:ok, parser} = Task.start_link(fn->parse(sender) end)
      parser
  end

  def send_message(parser, message) do
      send parser, {:message, message}
  end

  def parse(sender) do
     receive do
        {:message, msg} ->
            cond do
            Regex.match?(~r/pick_starting_region \d+ ((?:\d+ )+)/, msg) ->
                matches = Regex.run(~r/pick_starting_region \d+ ((?:\d+\s*)+)/, msg)
                nums = String.split(List.last(matches))
                send sender, {:starting_region_choice, Enum.map(nums, &(String.to_integer &1)) }
            true->
              send sender, {:error, "Invalid Message Received"}
            end
     end
     parse(sender)
  end

end
