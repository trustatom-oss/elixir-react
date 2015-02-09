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
    "React.createElement(\"#{i.name}\", #{attrs}, #{children})"
  end

end
