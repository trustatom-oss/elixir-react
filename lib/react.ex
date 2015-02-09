defmodule React do
  defmacro __using__(_) do
    quote do
      require React
    end
  end

  defmacro element(name) do
    React.__element__(__CALLER__, name, [], nil)
  end
  defmacro element(name, do: block) do
    React.__element__(__CALLER__, name, [], block)
  end
  defmacro element(name, attributes) do
    React.__element__(__CALLER__, name, attributes, nil)
  end
  defmacro element(name, attributes, do: block) do
    React.__element__(__CALLER__, name, attributes, block)
  end

  def __element__(_env, name, attributes, block) do
    {attributes, block} = cond do
      is_binary(attributes) and is_nil(block) ->
        {[], attributes}
      true ->
        {attributes, block}
    end
    block = block || attributes[:do]
    attributes = Dict.drop(attributes, [:do])
    quote do
      acc = Process.get(React) || [[]]
      acc = [[]|acc]; Process.put(React, acc) # push
      el = struct(React.Element, name: unquote(name), attributes: Enum.into(unquote(attributes), %{}), children: unquote(block))
      acc = tl(acc); Process.put(React, acc) # pop

      if Process.get(React) == [[]] do
        Process.delete(React)
        el
      else
        [head|tail] = acc
        Process.put(React, [[el|head]|tail])
        Enum.reverse([el|head])
     end
    end
  end

end
