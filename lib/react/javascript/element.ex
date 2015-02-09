defimpl React.Javascript.Encoder, for: React.Element do
  def encode(i) do
    attrs = if Map.keys(i.attributes) |> length > 0 do
        "{" <> (Enum.map(i.attributes, fn({key, value}) ->
        "\"#{key}\": #{React.Javascript.Encoder.encode(value)}"
      end) |> Enum.join(", ")) <> "}"
    else
      "null"
    end
    children = unless is_list(i.children) do
      React.Javascript.Encoder.encode(i.children)
    else
      Enum.map(i.children, &React.Javascript.Encoder.encode/1)
        |> Enum.join(", ")
    end
    tag = handle_tag(i.name)
    "React.createElement(#{tag}, #{attrs}, #{children})"
  end

  @tags React.DOM.__tags__ |> Enum.map(&to_string/1)
  defp handle_tag(tag) when tag in @tags do
    ~s|"#{tag}"|
  end
  defp handle_tag(tag) do
    "#{tag}"
  end

end
