defmodule Beamchain.API do
  alias Beamchain.Server

  def start do
    GenServer.start_link(Server, :ok, [])
  end

  def read_blocks(pid) do
    GenServer.call(pid, {:read})
  end

  def add_block(pid, data) do
    GenServer.cast(pid, {:add, data})
  end
end
