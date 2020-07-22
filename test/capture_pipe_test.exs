defmodule CapturePipeTest do
  use ExUnit.Case

  import CapturePipe
  import Kernel, except: [|>: 2]
  doctest CapturePipe
end
