# RandomexDemo

[![Build Status](https://travis-ci.org/timCF/randomex_demo.svg?branch=master)](https://travis-ci.org/timCF/randomex_demo)

Demo for [randomex](https://github.com/timCF/randomex) generator. This console application gives output to stdout and to files. Indexed files are in ./output dir. Some flags to generate specific output :

```
--ranges --samples --sets : generates output (text file or stdout) with given params

--diehard : generates output (binary file or stdout) for diehard tests with given number of integers (diehard > 0)
--decks --cards : generates output (text file or stdout) for card games (decks > 0 , cards = 24 | 32 | 36 | 52 | 54)
--ball-min --ball-max --ball-num --spin-num : generates output (text file or stdout) for bingo/keno-like games
```

Some mandatory output options :

```
--write-to-file : true | false
--stdout : true | false
```

Example for dieharder tests

```
mix run -e "" --no-halt console --diehard 100000000 --write-to-file true --stdout false
dieharder -f ./output/1452697128384077.txt -g 201 -a
```

There are few ways to run randomex_demo.

Use pre-builded release
-----------------------

This way you can run it without elixir / erlang in your system. [Here](https://yadi.sk/d/wunDCfMjo5SmK) is pre-builded release for 64-bit linux called 'randomex_demo_release_linux.tar.gz'. Download this package and then :

```
~ $ tar zxfv ./randomex_demo_release_linux.tar.gz
~ $ cd ./randomex_demo_release_linux
~ $ ./bin/randomex_demo console --ranges 32,111 --samples 500,1000,1500 --sets 1 --write-to-file true --stdout false
~ $ ./bin/randomex_demo console --diehard 10000000 --write-to-file true --stdout false
~ $ ./bin/randomex_demo console --decks 1000 --cards 36 --write-to-file true --stdout false
~ $ ./bin/randomex_demo console --ball-min 1 --ball-max 80 --ball-num 20 --spin-num 1000 --write-to-file true --stdout false
~ $ ls ./output/
1452701335999535.txt  1452701387010760.txt  1452701420327234.txt  1452701450936883.txt  index.txt
~ $ cat ./output/index.txt
1452701335999535 : {"ranges":[32,111],"samples":[500,1000,1500],"sets":1,"stdout":false,"write_to_file":true}
1452701387010760 : {"diehard":10000000,"stdout":false,"write_to_file":true}
1452701420327234 : {"cards":36,"decks":1000,"stdout":false,"write_to_file":true}
1452701450936883 : {"ball_max":80,"ball_min":1,"ball_num":20,"spin_num":1000,"stdout":false,"write_to_file":true}
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
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix run -e "" --no-halt console --ranges 32,111 --samples 500,1000,1500 --sets 1 --write-to-file true --stdout false
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix run -e "" --no-halt console --diehard 10000000 --write-to-file true --stdout false
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
tim@tim-VirtualBox:~/tmp/randomex_demo$ rel/randomex_demo/bin/randomex_demo console --ranges 32,111 --samples 500,1000,1500 --sets 1 --write-to-file true --stdout false
tim@tim-VirtualBox:~/tmp/randomex_demo$ rel/randomex_demo/bin/randomex_demo console --diehard 10000000 --write-to-file true --stdout false
tim@tim-VirtualBox:~/tmp/randomex_demo$ ls ./rel/randomex_demo/output/
1446760892646954.txt  1446760892786954.txt  index.txt
```
