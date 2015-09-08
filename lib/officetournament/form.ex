defmodule Officetournament.Form do
  alias Phoenix.HTML.Form

  def bootstrap_form_for(form_data, action, options \\ [], fun) when is_function(fun, 1) do
    Phoenix.HTML.Form.form_for(form_data, action, options, fun)
  end

  def bootstrap_text_input(form, field, text, opts \\ []) do
    Phoenix.HTML.Tag.content_tag :div, class: "form-group" do
      [
        Form.label(form, field, text),
        Form.text_input(form, field, opts)
      ]
    end
  end

  def bootstrap_password_input(form, field, text, opts \\ []) do
    Phoenix.HTML.Tag.content_tag :div, class: "form-group" do
      [
        Form.label(form, field, text),
        Form.password_input(form, field, opts)
      ]
    end
  end

  def bootstrap_submit(field, opts \\ []) do
    Phoenix.HTML.Tag.content_tag :div, class: "form-group" do
      opts =
        opts
        |> Keyword.put_new(:class, "btn btn-primary")

      Form.submit(field, opts)
    end
  end
end
