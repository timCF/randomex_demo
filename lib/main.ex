defmodule RandomexDemo.Main do
	@output_dir "./output"
	@index_file "./output/index.txt"

	#
	#	here parse params
	#
	def main(args) do
		File.mkdir(@output_dir)
		case OptionParser.parse(args) do
			{new_args, [], []} ->
				case Enum.reduce_while(new_args, %{}, &parse_proc/2)  do
					{:error, bin} when is_binary(bin) -> IO.puts(bin)
					resmap = %{} ->
						case Enum.filter([:ranges, :samples, :sets], &(not(Map.has_key?(resmap,&1)))) do
							[] -> generate(resmap)
							lst = [_|_] -> IO.puts("ERROR , could not find arguments #{inspect lst}")
						end
				end
			{_,some,errors} ->
				IO.puts("ERROR , got unparsed #{inspect some} and errors #{inspect errors}")
		end
	end
	defp parse_proc({key, bin}, acc) when ((key in [:ranges, :samples]) and is_binary(bin)) do
		res = String.split(bin,",") |> Enum.map(&Maybe.to_integer/1)
		case Enum.all?(res, &(is_integer(&1) and (&1 > 0))) do
			true -> {:cont, Map.put(acc, key, res)}
			false -> {:halt, {:error, "ERROR , every integer in #{key} must be > 0 , integers must be comma-separated , incorrect arg #{bin}"}}
		end
	end
	defp parse_proc({key = :sets, bin}, acc) when is_binary(bin) do
		case Maybe.to_integer(bin) do
			int when (is_integer(int) and (int > 0)) -> {:cont, Map.put(acc, key, int)}
			_ -> {:halt, {:error, "ERROR , sets must be int > 0 , incorrect arg #{bin}"}}
		end
	end
	defp parse_proc({k,v}, _), do: {:halt, {:error, "ERROR , unknown argument #{k} #{v}"}}

	#
	#	here generate numbers and write 2 files
	#
	defp generate(fullopts = %{ranges: ranges, samples: samples, sets: sets}) do
		unixtime = now |> Integer.to_string
		filename = "#{@output_dir}/#{unixtime}.txt"
		Enum.each(ranges, fn(this_range) ->
			Enum.each(1..sets, fn(_) ->
				Enum.each(samples, fn(this_sample) ->
					IO.puts("range #{ this_range } sample #{ this_sample }")
					Enum.each(1..this_sample, fn(_) ->
						File.write!(filename, "#{Randomex.range(0, this_range) |> Integer.to_string }\n", [:append])
					end)
				end)
			end)
		end)
		File.write!(@index_file, "#{unixtime} : #{inspect fullopts}\n", [:append])
		IO.puts("DONE")
	end
	defp now do
		{a, b, c} = :erlang.timestamp
		a*1000000000000 + b*1000000 + c
	end

end
