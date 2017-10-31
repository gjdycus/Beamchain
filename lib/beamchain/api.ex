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
    GenServer.call(Server, {:read_blocks})
  end

  def set_blocks(blocks) do
    GenServer.cast(Server, {:set_blocks, blocks})
  end

  def generate_block(data) do
    GenServer.cast(Server, {:generate_block, data})
  end

  def add_block(block) do
    :rpc.multicall(GenServer, :cast, [Server, {:add_block, block}])
  end
end
