defmodule Beamchain.Block do
  defstruct [:index, :timestamp, :data, :previous_hash, :hash]

  def generate(index, timestamp, data, previous_hash) do
    block = %__MODULE__{
      index: index,
      timestamp: timestamp,
      data: data,
      previous_hash: previous_hash
    }
    %{ block | hash: calculate_hash(block) }
  end

  defp calculate_hash(%__MODULE__{index: index, timestamp: timestamp, data: data, previous_hash: previous_hash}) do
    str = to_string(index) <> to_string(timestamp) <> data <> previous_hash
    :crypto.hash(:sha256, str) |> Base.encode16()
  end
end
