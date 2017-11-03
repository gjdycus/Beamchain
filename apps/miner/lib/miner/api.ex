defmodule Miner.API do
  alias Miner.Server

  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :worker,
      restart: :permanent
    }
  end

  def start_link do
    case GenServer.start_link(Server, empty_problem(), [name: Server]) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} ->
        Process.link(pid)
        {:ok, pid}
    end
  end

  def set_problem(problem) do
    GenServer.call(Server, {:set, problem})
  end

  def current_problem do
    GenServer.call(Server, {:get})
  end

  def clear_problem do
    GenServer.call(Server, {:set, empty_problem()})
  end

  defp empty_problem, do: {:empty}
end
