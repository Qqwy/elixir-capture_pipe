defmodule CapturePipeTest do
  use ExUnit.Case

  import CapturePipe
  import Kernel, except: [|>: 2]
  doctest CapturePipe

  describe "Backwards compatibility with existing Elixir code" do
    test "We can still assign a capture containing a pipe to a variable" do
      x = & &1 |> to_string()

      assert x.(10) == "10"
    end
  end


  describe "More complicated sequences of pipes with captures" do
    def speak(name, greeting) do
      name
      # * function that requires different order
      |> &greet(greeting, &1)
      # regular function still works fine
      |> String.upcase()
      # does not disrupt adding ellipses via original method
      |> (&(&1 <> "...")).()
      # * example of adding ellipses with enhanced pipe
      # could also be &("..." <> &1) if you prefer
      |> &"...#{&1}"
      # * returning a tuple
      |> &{:ok, &1}
    end

    defp greet(greeting, name) do
      "#{greeting}, #{name}"
    end

    test "capture pipe usage" do
      assert speak("Jane", "Hello") == {:ok, "...HELLO, JANE..."}
    end
  end
end
