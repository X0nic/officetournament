defmodule Officetournament.Form do
  alias Phoenix.HTML.Form

  def bootstrap_form_for(form_data, action, options \\ [], fun) when is_function(fun, 1) do
    Phoenix.HTML.Form.form_for(form_data, action, options, fun)
  end

  def bootstrap_text_input(form, field, opts \\ []) do
    Phoenix.HTML.Tag.content_tag :div, class: "form-group" do
      Form.text_input(form, field, opts)
    end
  end
end
