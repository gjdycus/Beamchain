defmodule Beamchain.Block do
  defstruct [:index, :timestamp, :data, :previous_hash, :hash]
end
