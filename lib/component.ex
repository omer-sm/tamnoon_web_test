defmodule TamnoonWebTest.Component do
  @callback heex :: String.t()

  def parse_tmnn_heex(compiled_heex) do
    Regex.replace(~r/< *\w *[^>]*> *(?:@([a-z|\d]+))?/m, compiled_heex, fn x, innerHtml ->
      attr_classes = get_component_attrs(x, innerHtml)
      |> Enum.reduce("", fn {key, attrs}, acc ->
        acc <> Enum.reduce(attrs, "", fn attr, acc ->
          if (String.starts_with?(attr, "on")) do
            acc <> " tmnnevent-" <> "#{attr}-" <> Atom.to_string(key)
          else
            acc <> " tmnn-" <> Atom.to_string(key) <> "-#{attr}"
          end
        end)
      end)
      x = Regex.replace(~r/(?<attr>[a-z|\d]+)=@(?<key>[a-z|\d]+)/m, x, "")
      x = Regex.replace(~r/>( *@[a-z|\d]+)/m, x, ">")
      IO.inspect(x)
      x = if (x =~ ~r/class="[^"]*"/ || attr_classes == "") do
        x
      else
        [a, b] = Regex.split(~r/< *\w+/, x, [parts: 2, include_captures: true, trim: true])
        a <> " class=\"\" " <> b
      end
      Regex.replace(~r/class="([^"]*)"/, x, fn _, classes ->
        "class=\"#{classes}#{attr_classes}\""
      end)

    end)
  end

  defp get_component_attrs(component, "") do
    Regex.scan(~r/(?<attr>[a-z|\d]+)=@(?<key>[a-z|\d]+)/m, component)
    |> Enum.group_by(&(String.to_atom(Enum.at(&1, 2))), &(Enum.at(&1, 1)))
  end

  defp get_component_attrs(component, innerHtml) do
    [[nil, "innerHtml", innerHtml]]
    |> Enum.concat(Regex.scan(~r/(?<attr>[a-z|\d]+)=@(?<key>[a-z|\d]+)/m, component))
    |> Enum.group_by(&(String.to_atom(Enum.at(&1, 2))), &(Enum.at(&1, 1)))
  end
end
