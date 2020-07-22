# CapturePipe


[![hex.pm version](https://img.shields.io/hexpm/v/capture_pipe.svg)](https://hex.pm/packages/capture_pipe)
[![Build Status](https://travis-ci.org/Qqwy/elixir-capture_pipe.svg?branch=master)](https://travis-ci.org/Qqwy/elixir-capture_pipe)
[![Documentation](https://img.shields.io/badge/hexdocs-latest-blue.svg)](https://hexdocs.pm/capture_pipe/index.html)

CapturePipe exposes an extended pipe-operator that allows the usage of bare function captures.

This is useful to insert the pipe's results into a datastructure
such as a tuple.

What this macro does, is if it encounters a `&` capture,
it wraps the whole operand in `(...).()` which is the
anonymous-function-call syntax that Elixir's normal pipe accepts,
that (argubably) is less easy on the eyes.

For instance, `10 |> &{:ok, &1}` is turned into `10 |> (&{:ok, &1}).()`

## Examples

Still works as normal:

```elixir
iex> [1,2,3] |> Enum.map(fn x -> x + 1 end)
[2,3,4]
```

Insert the result of an operation into a tuple

```elixir
iex> 42 |> &{:ok, &1}
{:ok, 42}
```

It also works multiple times in a row.

```elixir
iex> 20 |> &{:ok, &1} |> &[&1, 2, 3]
[{:ok, 20}, 2, 3]

Besides the function-capture syntax
CapturePipe also enables you to use anonymnous functions
directly inside a pipe, performing similar wrapping:

```elixir
iex> 42 |> fn val -> to_string(val) end
"42"
```

```

Even if the pipes are nested deeply
and interspersed with 'normal' pipe calls:

```elixir
iex> (10
iex> |> &Kernel.div(20, &1)
iex> |> Kernel.-()
iex> |> to_string()
iex> |> &"The answer is: \#{&1}!"
iex> |> String.upcase()
iex> |> &{:ok, &1}
iex> )
{:ok, "THE ANSWER IS: -2!"}
```


## Installation

Capturepipe can be installed
by adding `capture_pipe` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:capture_pipe, "~> 0.1.0"}
  ]
end
```

Documentation can be found at [https://hexdocs.pm/capture_pipe](https://hexdocs.pm/capture_pipe).

