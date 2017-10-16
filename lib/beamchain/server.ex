defmodule Beamchain.Server do
  use GenServer

  alias Beamchain.Blockchain

  def init(:ok) do
    Process.flag(:trap_exit, true)
    {:ok, Blockchain.init()}
  end

  def handle_call({:read}, _from, blockchain) do
    {:reply, blockchain, blockchain}
  end

  def handle_cast({:add, data}, blockchain) do
    {:noreply, Blockchain.add_block(blockchain, data)}
  end
end
