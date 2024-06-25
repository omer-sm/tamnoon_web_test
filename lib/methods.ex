defmodule TamnoonWebTest.Methods do
  use Tamnoon.Methods

  defmethod :nudge do
    key = Tamnoon.Methods.get_key(req, state)
    val = Map.get(state, key)
    new_val = if (req["direction"] == "up"), do: val + 1, else: val - 1
    new_state = Map.put(state, key, new_val)
    {%{key => new_val}, new_state}
  end

  defmethod :setval do
    new_state = Map.put(state, :val, req["val"])
    {%{val: req["val"]}, new_state}
  end
end
