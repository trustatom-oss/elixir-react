defmodule ReactTest do
  use ExUnit.Case
  use React

  test "simple element definition" do
    assert %React.Element{name: "div", children: nil, attributes: %{}} = React.element("div")
    assert %React.Element{name: "div", children: nil, attributes: %{className: "panel"}} = React.element("div", className: "panel")
    assert %React.Element{name: "div", children: "test", attributes: %{className: "panel"}} = React.element("div", className: "panel", do: "test")
    assert %React.Element{name: "div", children: "test", attributes: %{className: "panel", id: "1"}} = React.element("div", className: "panel", id: "1", do: "test")
  end

  test "nested element definition" do
    assert %React.Element{name: "div", children: [%React.Element{name: "h1", children: "text", attributes: %{}}], attributes: %{}} = (React.element("div") do
      React.element("h1", do: "text")
    end)
    assert %React.Element{name: "div", children: [%React.Element{name: "h1", children: "text", attributes: %{}},
                                                  %React.Element{name: "div", children: "text2", attributes: %{}},
                                                 ], attributes: %{}} = (React.element("div") do
      React.element("h1", do: "text")
      React.element("div", do: "text2")
    end)
  end

end
