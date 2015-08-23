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
        {:message, _} ->
            send sender, {:error, "Invalid Message Received"}
     end
     parse(sender)
  end

end
