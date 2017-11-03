defmodule Miner.Server do
  use GenServer

  def init(state) do
    {:ok, state}
  end

  def handle_call({:get}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:set, state}, _from, _state) do
    {:reply, state, state}
  end
end
