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
					resmap = %{diehard: n, write_to_file: _, stdout: _} when ((n > 0) and is_integer(n)) -> generate(resmap, &generate_diehard/2)
					resmap = %{ranges: _, samples: _, sets: _, write_to_file: _, stdout: _} -> generate(resmap, &generate_main/2)
					resmap = %{decks: _, cards: cards, write_to_file: _, stdout: _} when (cards in [24, 32, 36, 52, 54]) -> generate(resmap, &generate_cards/2)
					resmap = %{ball_min: min, ball_max: max, ball_num: num, spin_num: _, write_to_file: _, stdout: _} when (min <= max) and (num <= (max - min + 1)) -> generate(resmap, &generate_balls/2)
					some -> IO.puts("ERROR , wrong or some missing arguments, got #{inspect some}")
				end
			{_,some,errors} ->
				IO.puts("ERROR , got unparsed #{inspect some} and errors #{inspect errors}")
		end
	end
	defp parse_proc({key, bin}, acc) when ((key in [:ranges, :samples]) and is_binary(bin)) do
		res = String.split(bin,",") |> Enum.map(&Maybe.to_integer/1)
		case Enum.all?(res, &(is_integer(&1) and (&1 > 0))) do
			true -> {:cont, Map.put(acc, key, res)}
			false -> {:halt, {:error, "ERROR , every integer in #{Atom.to_string(key)} must be > 0 , integers must be comma-separated , incorrect arg #{bin}"}}
		end
	end
	defp parse_proc({key, bin}, acc) when is_binary(bin) and (key in [:diehard, :sets, :decks, :cards, :ball_min, :ball_max, :ball_num, :spin_num]) do
		case Maybe.to_integer(bin) do
			int when (is_integer(int) and (int > 0)) -> {:cont, Map.put(acc, key, int)}
			_ -> {:halt, {:error, "ERROR , sets must be int > 0 , incorrect arg #{bin}"}}
		end
	end
	defp parse_proc({key,val}, acc) when (key in [:write_to_file, :stdout]) and (val in ["true", "false"]), do: {:cont, Map.put(acc, key, String.to_atom(val))}
	defp parse_proc({k,v}, _), do: {:halt, {:error, "ERROR , unknown argument #{k} #{v}"}}

	#
	#	here generate numbers and write 2 files
	#

	defp now do
		{a, b, c} = :os.timestamp
		a*1000000000000 + b*1000000 + c
	end
	defp generate(fullopts = %{write_to_file: true}, lambda) when is_function(lambda,2) do
		unixtime = now |> Integer.to_string
		filename = "#{@output_dir}/#{unixtime}.txt"
		File.touch!(filename)
		{:ok, io} = :file.open(filename, [:write, :append])
		lambda.(fullopts, io)
		:ok = :file.sync(io)
		:ok = :file.close(io)
		File.write!(@index_file, "#{unixtime} : #{Jazz.encode!(fullopts)}\n", [:append])
	end
	defp generate(fullopts = %{write_to_file: false}, lambda) when is_function(lambda,2), do: lambda.(fullopts, nil)

	#
	#	functions for different input cases
	#

	defp generate_main(fullopts = %{ranges: ranges, samples: samples, sets: sets}, io) do
		Enum.each(ranges, fn(this_range) ->
			Enum.each(samples, fn(this_sample) ->
				Enum.each(1..sets, fn(_) ->
					Enum.each(1..this_sample, fn(_) ->
						bin = Randomex.range(0, this_range) |> Integer.to_string
						write_data(bin<>"\n", fullopts, io)
					end)
				end)
			end)
		end)
	end

	defp generate_diehard(fullopts = %{diehard: n, write_to_file: wtf, stdout: stdout}, io) when (is_integer(n) and (n > 0)) do
		case div(n,@sample2write) do
			0 -> generate_diehard_rest(n, fullopts, io)
			s ->
				bin =	Enum.to_list(1..s)
						|> Exutils.pmap(1, fn(_) ->
							Enum.reduce(1..@sample2write, <<>>, fn(_,acc) ->
								int = Randomex.uniform(@max32bit_int)
								if stdout, do: (:ok = IO.puts(int))
								acc<><<int::32>>
							end)
						end)
						|> Enum.join
				if wtf, do: (:ok = :file.write(io, bin))
				case rem(n,@sample2write) do
					0 -> :ok
					n -> generate_diehard_rest(n, fullopts, io)
				end
		end
	end
	defp generate_diehard_rest(n, %{write_to_file: wtf, stdout: stdout}, io) do
		Enum.each(1..n, fn(_) ->
			int = Randomex.uniform(@max32bit_int)
			if stdout, do: (:ok = IO.puts(int))
			if wtf, do: (:ok = :file.write(io, <<int::32>>))
		end)
	end

	defp generate_cards(fullopts = %{decks: decks, cards: cards}, io) do
		this_deck = Excards.Deck.new(cards)
		Enum.each(1..decks, fn(_) ->
			bin =	Excards.Deck.shuffle(this_deck)
					|> Stream.map(fn(%Excards{suit: suit, value: value}) -> Atom.to_string(suit)<>"_"<>Atom.to_string(value) end)
					|> Enum.join(" ")
			write_data(bin<>"\n", fullopts, io)
		end)
	end

	defp generate_balls(fullopts = %{ball_min: min, ball_max: max, ball_num: num, spin_num: spin_num}, io) do
		Enum.each(1..spin_num, fn(_) ->
			bin =	Enum.to_list(min..max)
					|> Randomex.shuffle
					|> Enum.take(num)
					|> Enum.join(" ")
			write_data(bin<>"\n", fullopts, io)
		end)
	end

	defp write_data(bin, %{write_to_file: wtf, stdout: stdout}, io) do
		if wtf, do: (:ok = :file.write(io,bin))
		if stdout, do: (:ok = IO.write(bin))
	end

end
