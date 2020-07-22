defmodule CapturePipe do
  import Kernel, except: [|>: 2]
  @moduledoc """
  To use this operator in one of your modules, you need to add the following to it:

      use CapturePipe

  This does the same thing as explicitly writing:

      import Capturepipe
      import Kernel, except: [|>: 2]
  """

  defmacro __using__(_opts) do
    quote do
      import CapturePipe
      import Kernel, except: [|>: 2]
    end
  end

  @doc """
  Extended pipe-operator that allows the usage of bare function captures.

  This is useful to insert the pipe's results into a datastructure
  such as a tuple.

  What this macro does, is if it encounters a `&` capture,
  it wraps the whole operand in `(...).()` which is the
  anonymous-function-call syntax that Elixir's normal pipe accepts,
  that (argubably) is less easy on the eyes.

  For instance, `10 |> &{:ok, &1}` is turned into `10 |> (&{:ok, &1}).()`

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

  Even if the pipes are nested deeply
  and interspersed with 'normal' pipe calls:

      iex> (10
      iex> |> &Kernel.div(20, &1)
      iex> |> Kernel.-()
      iex> |> to_string()
      iex> |> &"The answer is: \#{&1}!"
      iex> |> String.upcase()
      iex> |> &{:ok, &1}
      iex> )
      {:ok, "THE ANSWER IS: -2!"}
  """
  # The implementation is identical to
  # Elixir's builtin one,
  # except that we are using our overridden
  # `pipe` and `unpipe` functions.
  # (rather than the ones in the `Macro` module)
  defmacro left |> right do
    [{h, _} | t] = unpipe({:|>, [], [left, right]})

    fun = fn {x, pos}, acc ->
      pipe(acc, x, pos)
    end

    :lists.foldl(fun, h, t)
  end

  # Implementation is _very_ similar to Elixir's builtin
  # `Macro.unpipe/1`
  defp unpipe(expr) do
    :lists.reverse(unpipe(expr, []))
  end

  defp unpipe({:|>, _, [left, right]}, acc) do
    unpipe(right, unpipe(left, acc))
  end

  # The magic happens here:
  # We rewrite `a |> (&b |> c)`
  # into `a |> (&b) |> c`
  # and then recurse
  defp unpipe({:&, meta1, [{:|>, meta2, [left, right]}]}, acc) do
    unpipe({:|>, meta2, [{:&, meta1, [left]}, right]}, acc)
  end

  defp unpipe(other, acc) do
    [{other, 0} | acc]
  end

  # Bare captures are wrapped to become
  # (&(...)).()
  defp pipe(expr, {:&, _, _} = call_args, position) do
    pipe(expr, quote do (unquote(call_args)).() end, position)
  end

  # Defer the rest of the implementation
  # to the one that already ships with Elixir
  defp pipe(expr, other, position) do
    Macro.pipe(expr, other, position)
  end
end
