defmodule TamnoonWebTest.HtmlCompiler do

  def compile() do
    with components_dir <- Application.fetch_env!(:tamnoon_web, :components_dir),
      {:dir_exists?, true} <- {:dir_exists?, File.dir?(components_dir)},
      {:ok, files} <- File.ls(components_dir),
      component_modules <- Enum.filter(files, &(String.ends_with?(&1, ".ex")))
      do :ok
    else
      {:dir_exists?, false} -> raise("Error: The component directory path #{Application.fetch_env!(:tamnoon_web, :components_dir)} does not exist or is not a directory.")
    end
  end

  def compile_root(path, keys_attributes) do
    content = EEx.eval_file(path, [listeners: add_get_listeners(keys_attributes)])
    File.write!("out/out.html", content)
  end

  def add_get_listeners(keys_attributes) do
    Enum.map_reduce(keys_attributes, "", fn {key, attrs}, acc ->
      {:ok, acc <> add_key_get_listeners(key, attrs)}
    end)
    |> elem(1)
  end

  def add_key_get_listeners(key, :ignore) do
    "if ('#{key}' in field) return;\n"
  end
  def add_key_get_listeners(key, attributes) do
    listeners = Enum.map_reduce(attributes, "", fn attr, acc ->
      {:ok, acc <> "Array.from(document.getElementsByClassName('tmnn-#{key}-#{attr}')).forEach(elem => {elem.#{attr} = field.val;})\n"}
    end)
    |> elem(1)
    "if ('#{key}' in field) {
      #{listeners}
    }\n"
  end


  def get_component_attrs(component) do
    Regex.scan(~r/> *@([a-z|\d]+) *</m, component)
    |> Enum.map(fn [_, key] ->
      [nil, "innerHtml", key]
    end)
    |> Enum.concat(Regex.scan(~r/(?<attr>[a-z|\d]+)=@(?<key>[a-z|\d]+)/m, component))
    |> Enum.group_by(&(String.to_atom(Enum.at(&1, 2))), &(Enum.at(&1, 1)))
  end
end
