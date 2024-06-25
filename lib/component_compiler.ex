defmodule TamnoonWebTest.ComponentCompiler do

  def build_from_root(ws_address \\ "ws://localhost:4000/ws/", root \\ "root.html.heex") do
    compiled_html = render_component(root, %{ws_address: ws_address})
    |> TamnoonWebTest.Component.parse_tmnn_heex()
    File.write("out/out.html", compiled_html)
  end

  def render_component(component, assigns \\ %{}) when is_binary(component) do
    "lib/components/" <> component
    |> EEx.eval_file([r: &render_component/1, assigns: assigns])
  end

  def render_component(component, assigns) do
    component.heex()
    |> EEx.eval_string([r: &render_component/1, assigns: assigns]) # compile component heex
    #|> TamnoonWebTest.Component.parse_tmnn_heex() # add attribute classes and events
  end
end
