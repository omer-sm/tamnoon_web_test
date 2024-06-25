defmodule TamnoonWebTest.Components.TestContainer do
  @behaviour TamnoonWebTest.Component

  @impl true
  def heex do
    ~s|<div>
      <p> hi </p>
      <%= r.("heex_component.html.heex") %>
      <%= r.(TamnoonWebTest.Components.TestComponent) %>
    </div>|
  end
end
