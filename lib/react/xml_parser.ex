defmodule React.XMLParser do

  defmodule State do
    defstruct element: []
  end

  defp handle_event({:startElement,_,element_name,_,attrs}, state) do
    element_name = to_string(element_name)
    attrs = handle_attrs(attrs, state)
    %State{ state | element: [%React.Element{name: element_name, attributes: Enum.into(attrs, %{})}|state.element]}
  end
  defp handle_event({:endElement,_,_element_name,_}, %State{ element: [element] } = state) do
    %State{state | element: element}
  end
  defp handle_event({:endElement,_,_element_name,_}, %State{ element: [final|tail] } = state) do
    [head|rest] = tail
    el =
    cond do
      is_nil(head.children) ->
        %React.Element{head | children: final}
      is_binary(head.children) ->
        %React.Element{head | children: [head.children, final]}
      is_list(head.children) ->
        %React.Element{head | children: head.children ++ [final]}
    end
    %State{state | element: [el|rest]}
  end
  defp handle_event({:characters, chars}, %State{ element: [head|tail] } = state) do
    string = to_string(chars)
    el =
    cond do
      is_nil(head.children) ->
        %React.Element{head | children: string}
      is_binary(head.children) ->
        %React.Element{head | children: head.children <> string}
      is_list(head.children) ->
        %React.Element{head | children: head.children ++ [string]}
    end
    %State{state | element: [el|tail]}
  end
  defp handle_event(_event, state) do
    state
  end

  defp handle_attrs([], _state) do
    []
  end
  defp handle_attrs(attrs, state) do
    for attr <- attrs do
      handle_attr(attr, state)
    end
  end
  defp handle_attr({:attribute,name,a,b,value}, state) when is_list(value) do
    handle_attr({:attribute,name,a,b,to_string(value)}, state)
  end
  defp handle_attr({:attribute,name,_,_,value}, _state) do
    {to_string(name), value}
  end

  def parse(xml) do
    {:ok, state, _rest} = :erlsom.parse_sax(xml, %State{}, &handle_event/2)
    state.element
  end

end
