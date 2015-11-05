defmodule RandomexDemo.Mixfile do
  use Mix.Project

  def project do
    [app: :randomex_demo,
     version: "0.0.1",
     #elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
	 escript: [main_module: RandomexDemo.Main, embed_elixir: true],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: 	[
						:logger,
						:randomex,
						:maybe,
						:exrm,
						:crypto,
						:jazz
					],
     mod: {RandomexDemo, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
		{:randomex, github: "veryevilzed/randomex"},
		{:maybe, github: "timCF/maybe"},
		{:exrm, github: "bitwalker/exrm"},
		{:jazz, github: "meh/jazz"}
	]
  end
end
