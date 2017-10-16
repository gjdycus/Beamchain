defmodule Beamchain.API do
  alias Beamchain.Server

  def start_link(name) do
    case GenServer.start_link(Server, :ok, [name: name]) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} ->
        Process.link(pid)
        {:ok, pid}
    end
  end

  def read_blocks do
    GenServer.call({:global, Server}, {:read})
  end

  def mine_block(data) do
    GenServer.cast({:global, Server}, {:add, data})
  end
end
