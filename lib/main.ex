defmodule RandomexDemo.Main do
	@output_dir "./output"
	@index_file "./output/index.txt"
	@max32bit_int (round(:math.pow 2, 32) - 1)
	@sample2write 1000000

	#
	#	here parse params
	#
	def main(args) do
		# 4 debug
		#spawn(fn() -> :observer.start end)
		_ = File.mkdir(@output_dir)
		case OptionParser.parse(args) do
			{new_args, [], []} ->
				case Enum.reduce_while(new_args, %{}, &parse_proc/2)  do
					{:error, bin} when is_binary(bin) -> IO.puts(bin)
					resmap = %{diehard: n} when ((n > 0) and is_integer(n)) -> generate(resmap, &generate_diehard/2)
					resmap = %{ranges: _, samples: _, sets: _} -> generate(resmap, &generate_main/2)
					resmap = %{decks: _, cards: cards} when (cards in [24, 32, 36, 52, 54]) -> generate(resmap, &generate_cards/2)
					resmap = %{ball_min: min, ball_max: max, ball_num: num, spin_num: _} when (min <= max) and (num <= (max - min + 1)) -> generate(resmap, &generate_balls/2)
					some -> IO.puts("ERROR , wrong arguments #{inspect some}")
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
	defp parse_proc({key, bin}, acc) when is_binary(bin) and (key in [:diehard, :sets, :decks, :cards, :ball_min, :ball_max, :ball_num, :spin_num]) do
		case Maybe.to_integer(bin) do
			int when (is_integer(int) and (int > 0)) -> {:cont, Map.put(acc, key, int)}
			_ -> {:halt, {:error, "ERROR , sets must be int > 0 , incorrect arg #{bin}"}}
		end
	end
	defp parse_proc({k,v}, _), do: {:halt, {:error, "ERROR , unknown argument #{k} #{v}"}}

	#
	#	here generate numbers and write 2 files
	#

	defp now do
		{a, b, c} = :os.timestamp
		a*1000000000000 + b*1000000 + c
	end
	defp generate(fullopts = %{}, lambda) when is_function(lambda,2) do
		unixtime = now |> Integer.to_string
		filename = "#{@output_dir}/#{unixtime}.txt"
		File.touch!(filename)
		{:ok, io} = :file.open(filename, [:write, :append])
		lambda.(fullopts, io)
		:ok = :file.sync(io)
		:ok = :file.close(io)
		File.write!(@index_file, "#{unixtime} : #{Jazz.encode!(fullopts)}\n", [:append])
	end

	#
	#	functions for different input cases
	#

	defp generate_main(%{ranges: ranges, samples: samples, sets: sets}, io) do
		Enum.each(ranges, fn(this_range) ->
			Enum.each(samples, fn(this_sample) ->
				Enum.each(1..sets, fn(_) ->
					Enum.each(1..this_sample, fn(_) ->
						bin = Randomex.range(0, this_range) |> Integer.to_string
						:ok = :file.write(io, "#{bin}\n")
						:ok = IO.puts(bin)
					end)
				end)
			end)
		end)
	end

	defp generate_diehard(%{diehard: n}, io) when (is_integer(n) and (n > 0)) do
		case div(n,@sample2write) do
			0 -> Enum.each(1..n, fn(_) -> :ok = :file.write(io, <<Randomex.uniform(@max32bit_int)::32>>) end)
			s ->
				:ok = :file.write(io,	Enum.to_list(1..s)
										|> Exutils.pmap(1, fn(_) -> Enum.reduce(1..@sample2write, <<>>, fn(_,acc) -> acc<><<Randomex.uniform(@max32bit_int)::32>> end) end)
										|> Enum.join)
				case rem(n,@sample2write) do
					0 -> :ok
					n -> Enum.each(1..n, fn(_) -> :ok = :file.write(io, <<Randomex.uniform(@max32bit_int)::32>>) end)
				end
		end
		IO.puts("DONE")
	end

	defp generate_cards(%{decks: decks, cards: cards}, io) do
		this_deck = Excards.Deck.new(cards)
		Enum.each(1..decks, fn(_) ->
			bin =	Excards.Deck.shuffle(this_deck)
					|> Stream.map(fn(%Excards{suit: suit, value: value}) -> inspect(suit)<>"_"<>inspect(value) end)
					|> Enum.join(" ")
			:ok = :file.write(io, bin<>"\n")
			:ok = IO.puts(bin)
		end)
	end

	defp generate_balls(%{ball_min: min, ball_max: max, ball_num: num, spin_num: spin_num}, io) do
		Enum.each(1..spin_num, fn(_) ->
			bin = 	Enum.reduce(1..num, {Enum.to_list(min..max), []}, fn(_, {from,to}) ->
						[el|rest_from] = Enum.shuffle(from)
						{rest_from, [el|to]}
					end)
					|> elem(1)
					|> Enum.join(" ")
			:ok = :file.write(io, bin<>"\n")
			:ok = IO.puts(bin)
		end)
	end

end
