defprotocol React.Javascript.Encoder do
  @fallback_to_any true
  def encode(i)
end

defimpl React.Javascript.Encoder, for: Any do
  def encode(i) do
    encoder = Application.get_env(:react, :json_encoder) || &Poison.encode!/1
    encoder.(i)
  end
end
