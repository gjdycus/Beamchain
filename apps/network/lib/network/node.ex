defmodule Network.Node do
  def connect(name) do
    Node.connect(name) && compare_blockchains()
  end

  defp compare_blockchains do
    {all_blockchains, _} = :rpc.multicall(Blockchain, :read_blocks, [])

    blockchain = Enum.max_by(all_blockchains, fn blockchain ->
      length(blockchain)
    end)

    :rpc.multicall(Blockchain, :set_blocks, [blockchain])
  end
end
