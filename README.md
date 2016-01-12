# RandomexDemo

Demo for [randomex](https://github.com/veryevilzed/randomex) generator. This console application gives output to stdout and to files. Indexed files are in ./output dir. Some flags to generate specific output :

```
--ranges --samples --sets : generates stdout and text file with given params

--diehard : generates binary file for diehard tests with given number of integers (diehard > 0)
--decks --cards : generates stdout and text file for card games (decks > 0 , cards = 24 | 32 | 36 | 52 | 54)
--ball_min --ball_max --ball_num --spin_num : generates stdout and text file for keno games
```

Builds for mac and linux. There are few ways to run it.

Use pre-builded release
-----------------------

This way you can run it without elixir / erlang in your system. There are builds for linux and mac.

```
tim@tim-VirtualBox:~/tmp$ git clone https://github.com/timCF/randomex_demo
tim@tim-VirtualBox:~/tmp$ cd randomex_demo/releases/linux/
tim@tim-VirtualBox:~/tmp/randomex_demo/releases/linux$ tar zxf ./randomex_demo_64bit.tar.gz
tim@tim-VirtualBox:~/tmp/randomex_demo/releases/linux$ ./bin/randomex_demo console --ranges 32,111 --samples 500,1000,1500 --sets 1
tim@tim-VirtualBox:~/tmp/randomex_demo/releases/linux$ ./bin/randomex_demo console --diehard 10000000
tim@tim-VirtualBox:~/tmp/randomex_demo/releases/linux$ cd output/
tim@tim-VirtualBox:~/tmp/randomex_demo/releases/linux/output$ ls
1446760892646954.txt  1446760892786954.txt  index.txt
```

Compile
-------

This way, you can compile app from sources and run it. Requires erlang 18.2.1 , elixir 1.2.0 , gcc.

```
tim@tim-VirtualBox:~/tmp$ git clone https://github.com/timCF/randomex_demo
tim@tim-VirtualBox:~/tmp$ cd randomex_demo/
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix local.hex --force
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix local.rebar --force
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix deps.get && mix compile
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix run -e "" --no-halt console --ranges 32,111 --samples 500,1000,1500 --sets 1
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix run -e "" --no-halt console --diehard 10000000
tim@tim-VirtualBox:~/tmp/randomex_demo$ cd ./output/
tim@tim-VirtualBox:~/tmp/randomex_demo/output$ ls
1446760892646954.txt  1446760892786954.txt  index.txt
```

Compile release
---------------

Also, you can compile app standalone release. Requires erlang 18.2.1 , elixir 1.2.0 , gcc.

```
tim@tim-VirtualBox:~/tmp$ git clone https://github.com/timCF/randomex_demo
tim@tim-VirtualBox:~/tmp$ cd randomex_demo/
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix local.hex --force
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix local.rebar --force
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix deps.get && mix compile
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix release
tim@tim-VirtualBox:~/tmp/randomex_demo$ rel/randomex_demo/bin/randomex_demo console --ranges 32,111 --samples 500,1000,1500 --sets 1
tim@tim-VirtualBox:~/tmp/randomex_demo$ rel/randomex_demo/bin/randomex_demo console --diehard 10000000
tim@tim-VirtualBox:~/tmp/randomex_demo$ ls ./rel/randomex_demo/output/
1446760892646954.txt  1446760892786954.txt  index.txt
```
