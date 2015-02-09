defmodule React.Macro do

  defmacro define_macros(name, stringified_name \\ nil) do
    quote bind_quoted: [name: name, stringified_name: stringified_name] do
      Module.register_attribute __MODULE__, :stringified_name, persist: false,
                                             accumulate: false
      @stringified_name stringified_name || to_string(name)
      defmacro unquote(name)() do
        React.__element__(__CALLER__, @stringified_name, [], nil)
      end
      defmacro unquote(name)(do: block) do
        React.__element__(__CALLER__, @stringified_name, [], block)
      end
      defmacro unquote(name)(attributes) do
        React.__element__(__CALLER__, @stringified_name, attributes, nil)
      end
      defmacro unquote(name)(attributes, do: block) do
        React.__element__(__CALLER__, @stringified_name, attributes, block)
      end
    end
  end

end
