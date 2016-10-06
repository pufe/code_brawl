defmodule Scoreboard.MainView do
  use Scoreboard.Web, :view

  def balloon([true, attempts, time, color]) do
    {:safe, "#{balloon_svg(color)} #{attempts}/#{time}"}
  end

  def balloon([false, 0, nil, _color]) do
    ""
  end

  def balloon([false, attempts, nil, _color]) do
    {:safe, "#{attempts}/-"}
  end

  def balloon(fodase) do
    IO.inspect(fodase)
  end

  def balloon_svg(color) do
  """
<svg width="25" height="30" viewbox="0 0 100 120">
<path d="M 45 92 l -5 10 q 5 -8 10 0 q 5 -8 10 0
l -5 -10 q 30 -30 30 -50 q 0 -40 -35 -40 q -35 0 -35 40 q 0 20 30 50"
stroke-width="3" stroke="black" fill="#{color}" />
<path d="M45 92 h 10 q 0 10 10 20 q 5 5 10 5 q 10 0 10 10" stroke="black"
stroke-width="3" fill="none"/>
</svg>
"""
  end
end
