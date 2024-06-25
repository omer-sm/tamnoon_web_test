defmodule TamnoonWebTestTest do
  use ExUnit.Case
  doctest TamnoonWebTest

  test "attribute extractor" do
    assert %{val: ["hidden", "otherattr"], p: ["innerHtml"]} == TamnoonWebTest.HtmlCompiler.get_component_attrs("
    <div hidden=@val>
      <p otherattr=@val> @p </p>
    </div>
    ")
  end

  test "tmnn heex parser" do
    TamnoonWebTest.Components.TestComponent.heex()
    |> TamnoonWebTest.Component.parse_tmnn_heex()
    |> IO.inspect()
  end

  test "component renderer" do
    TamnoonWebTest.Components.TestContainer
    |> TamnoonWebTest.ComponentCompiler.render_component()
    |> IO.inspect()
  end

  test "build from root" do
    TamnoonWebTest.ComponentCompiler.build_from_root()
    |> IO.inspect()
  end
end
