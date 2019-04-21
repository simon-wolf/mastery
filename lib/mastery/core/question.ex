defmodule Mastery.Core.Question do
  alias Mastery.Core.Template

  defstruct ~w[asked substitutions template]a

  @doc """
  Generate a question from a template.

    ## Example
    iex> generator = %{left: [1, 1], right: [2, 2]}
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
    iex> question = Mastery.Core.Question.new(template)
    iex> question.asked
    "1 + 2"
    iex> question.substitutions
    [left: 1, right: 2]
  """
  def new(%Template{} = template) do
    template.generators
    |> Enum.map(&build_substitution/1)
    |> evaluate(template)
  end

  defp build_substitution({name, choices_or_generator}) do
    {name, choose(choices_or_generator)}
  end

  defp choose(choices) when is_list(choices) do
    Enum.random(choices)
  end

  defp choose(generator) when is_function(generator) do
    generator.()
  end

  defp evaluate(substitutions, template) do
    %__MODULE__{
      asked: compile(template, substitutions),
      substitutions: substitutions,
      template: template
    }
  end

  defp compile(template, substitutions) do
    template.compiled
    |> Code.eval_quoted(assigns: substitutions)
    |> elem(0)
  end

end
