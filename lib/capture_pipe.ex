defmodule CapturePipe do
  @doc """
  A pipe-operator that extends the normal pipe
  in one tiny way:
  It allows the syntax of having a bare `&1` capture
  to exist inside a datastructure as one of the pipe results.
  This is useful to insert the pipe's results into a datastructure
  such as a tuple.
  What this pipe-macro does, is if it encounters a `&` capture,
  it wraps the whole operand in `((...)).()` which is the
  anonymous-function-call syntax that the Kernel pipe accepts,
  that (argubably) is much less easy on the eyes.
  So `10 |> &{:ok, &1}` is turned into `10 |> (&({:ok, &1})).()`
  To use this operator in one of your modules, you need to add the following to it:
  
      import Capturepipe
      import Kernel, except: [|>: 2]
  
  ## Examples
  Still works as normal:

      iex> [1,2,3] |> Enum.map(fn x -> x + 1 end)
      [2,3,4]

  Insert the result of an operation into a tuple

      iex> 42 |> &{:ok, &1}
      {:ok, 42}

  It also works multiple times in a row.

      iex> 20 |> &{:ok, &1} |> &[&1, 2, 3]
      [{:ok, 20}, 2, 3]
  """
  defmacro prev |> ({:&, meta, [{:|>, _, [pipe_lhs, pipe_rhs]}]}) do
    # Prevents pipe being wrongly nested insice `&`
    lhs_capture = {:&, meta, [pipe_lhs]}
    quote do
      unquote(prev)
      |> unquote(wrap_if_capture(lhs_capture))
      |> unquote(wrap_if_capture(pipe_rhs))
    end
  end

  defmacro prev |> (capture = {:&, _, _}) do
    prev = Macro.expand(prev, __CALLER__)
    quote do
      Kernel.|>(unquote(prev), (unquote(capture)).())
    end
  end
  defmacro prev |> other do
    quote do
      Kernel.|>(unquote(prev), unquote(other))
    end
  end

  defp wrap_if_capture(capture = {:&, _, _}) do
    quote do
      (unquote(capture)).()
    end
  end
  defp wrap_if_capture(other), do: other
end
