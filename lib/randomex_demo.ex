defmodule RandomexDemo do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

	spawn_link(fn ->
		:timer.sleep(1000)
		try do
			[_|args] = System.argv
			RandomexDemo.Main.main(args)
		catch
			error -> IO.inspect("RUNTIME ERROR #{inspect error}")
		rescue
			error -> IO.inspect("RUNTIME ERROR #{inspect error}")
		end
		:erlang.halt
	end)

    children = [
      # Define workers and child supervisors to be supervised
      # worker(RandomexDemo.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RandomexDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
