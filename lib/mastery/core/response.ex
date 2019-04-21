defmodule Mastery.Core.Response do
  defstruct ~w[quiz_title template_name to email answer correct timestamp]a

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
    iex> quiz = %{title: "Doc Test Quiz", current_question: question}
    iex> response = Mastery.Core.Response.new(quiz, "me@example.com", "3")
    iex> response.correct
    true
    iex> response = Mastery.Core.Response.new(quiz, "me@example.com", "4")
    iex> response.correct
    false
  """
  def new(quiz, email, answer) do
    question = quiz.current_question
    template = question.template

    %__MODULE__{
      quiz_title: quiz.title,
      template_name: template.name,
      to: question.asked,
      email: email,
      answer: answer,
      correct: template.checker.(question.substitutions, answer),
      timestamp: DateTime.utc_now()
    }
  end
end
