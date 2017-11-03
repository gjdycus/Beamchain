defmodule Network.Node do
  def connect(name) do
    current_nodes = [Node.self() | Node.list()]
    Node.connect(name)
      && compare_blockchains()
      && get_current_mining_problem(name, current_nodes)
  end

  defp compare_blockchains do
    {all_blockchains, _} = :rpc.multicall(Blockchain, :read_blocks, [])

    blockchain = Enum.max_by(all_blockchains, fn blockchain ->
      length(blockchain)
    end)

    :rpc.multicall(Blockchain, :set_blocks, [blockchain])
  end

  defp get_current_mining_problem(name, current_nodes) do
    case :rpc.call(name, Miner, :current_problem, []) do
      {:empty} -> nil
      problem ->
        :rpc.multicall(current_nodes, Miner, :set_problem, [problem])
        :rpc.multicall(current_nodes, Miner, :start_mining, [])
    end
  end
end
