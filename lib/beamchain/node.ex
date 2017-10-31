defmodule Beamchain.Node do
  def connect(name) do
    Node.connect(name) && compare_blockchains()
  end

  defp compare_blockchains do
    {all_blockchains, _} = :rpc.multicall(Beamchain, :read_blocks, [])

    blockchain = Enum.max_by(all_blockchains, fn blockchain ->
      length(blockchain)
    end)

    :rpc.multicall(Beamchain, :set_blocks, [blockchain])
  end
end
