defmodule Ticker do
  @name :ticker
  @interval 10000

  def start do
    IO.puts "server start..."
    pid = spawn __MODULE__, :generator, [[]]
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    IO.puts "client_pid: #{inspect client_pid}"
    :global.sync()
    send :global.whereis_name(@name), {:register, client_pid}
  end

  def generator(clients) do
    receive do
      {:register, pid} ->
        generator [pid|clients]
      {:send_message, pid, msg} ->
        nodes = List.delete(clients, pid)
        Enum.each nodes, fn client ->
          send client, {:message, client, msg}
        end
        generator(clients)
    after
      @interval ->
        Enum.each clients, fn client ->
          IO.puts "send to #{inspect client} from #{inspect self}"
          send client, {:tick}
        end
        generator(clients)
    end
  end
end

defmodule Client do
  def start do
    IO.puts "client start..."
    pid = spawn __MODULE__, :receiver, []
    Agent.start(fn -> pid end, name: __MODULE__)
    Ticker.register(pid)
  end

  def receiver do
    receive do
      {:tick} ->
        IO.puts DateTime.to_iso8601(DateTime.utc_now)
        receiver
      {:message, from, msg} ->
        IO.puts "#{msg} from #{inspect from}"
        receiver
    end
  end

  def message(msg) do
    send :global.whereis_name(:ticker), {:send_message, Agent.get(__MODULE__, &(&1)), msg}
  end
end
