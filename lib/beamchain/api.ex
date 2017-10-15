defmodule Beamchain.API do
  alias Beamchain.Server

  def start_link(name) do
    GenServer.start_link(Server, :ok, [name: name])
  end

  def read_blocks do
    GenServer.call({:global, Server}, {:read})
  end

  def mine_block(data) do
    GenServer.cast({:global, Server}, {:add, data})
  end
end
