defmodule TamnoonWebTest.Components.TestComponent do
  @behaviour TamnoonWebTest.Component

  @impl true
  def heex do
    ~s(<div attr=@val>
      <p class="myclass another-class
      yay-class"> this is a p </p>
      <p> @val </p>
      <div attr2=@val2 attr2=@val2 attr1=@val2
      otherattr=@otherval class="classofdiv"> other div </div>
    </div>)

  end
end
