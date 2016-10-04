defmodule Arena.Queue do
  use Supervisor

  def push(conn, contest) do
    Supervisor.start_child(__MODULE__, [Arena.Match, :start, [conn, contest]])
  end

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(Task, [], restart: :temporary)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

end
