defmodule Mastery.Core.Template do
  defstruct ~w[name category instructions raw compiled generators checker]a

  @doc """
  Creates a new template.

    ## Example
    iex> generator = %{left: [1, 2], right: [1, 2]}
    iex> checker = fn(sub, answer) ->
    ...> sub[:left] + sub[:right] == String.to_integer(answer)
    ...> end
    iex> template = Mastery.Core.Template.new(
    ...> name: :single_digit_addition,
    ...> category: :addition,
    ...> instructions: "Add the numbers",
    ...> raw: "<%= @left %> + <%= @right %>",
    ...> generators: generator,
    ...> checker: checker)
    iex> template.name
    :single_digit_addition
    iex> template.generators
    %{left: [1, 2], right: [1, 2]}
    iex> template.raw
    "<%= @left %> + <%= @right %>"
  """
  def new(fields) do
    raw = Keyword.fetch!(fields, :raw)
    struct!(__MODULE__, Keyword.put(fields, :compiled, EEx.compile_string(raw)))
  end
end
