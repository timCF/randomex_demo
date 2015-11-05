# RandomexDemo

Demo for https://github.com/veryevilzed/randomex generator. Builds for mac and linux. There are few ways to run it. 

Use pre-builded release
-----------------------

This way you can run it without elixir / erlang in your system. There are builds for linux and mac.

```
tim@tim-VirtualBox:~/tmp$ git clone https://github.com/timCF/randomex_demo
tim@tim-VirtualBox:~/tmp$ cd randomex_demo/releases/linux/
tim@tim-VirtualBox:~/tmp/randomex_demo/releases/linux$ tar zxf ./randomex_demo_64bit.tar.gz
tim@tim-VirtualBox:~/tmp/randomex_demo/releases/linux$ ./bin/randomex_demo console --ranges 32,111 --samples 500,1000,1500 --sets 1
tim@tim-VirtualBox:~/tmp/randomex_demo/releases/linux$ cd output/
tim@tim-VirtualBox:~/tmp/randomex_demo/releases/linux/output$ ls
1446760892646954.txt  index.txt
```

Compile
-------

This way, you can compile app from sources and run it. Requires erlang 18.1 , elixir 1.1.1 , gcc

```
tim@tim-VirtualBox:~/tmp$ git clone https://github.com/timCF/randomex_demo
tim@tim-VirtualBox:~/tmp$ cd randomex_demo/
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix local.hex --force
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix local.rebar --force
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix deps.get && mix compile
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix run -e "" --no-halt console --ranges 32,111 --samples 500,1000,1500 --sets 1
tim@tim-VirtualBox:~/tmp/randomex_demo$ cd ./output/
tim@tim-VirtualBox:~/tmp/randomex_demo/output$ ls
1446761598803893.txt  1446761866763461.txt  index.txt
```

Compile release
---------------

Also, you can compile app standalone release. Requires erlang 18.1 , elixir 1.1.1 , gcc

```
tim@tim-VirtualBox:~/tmp$ git clone https://github.com/timCF/randomex_demo
tim@tim-VirtualBox:~/tmp$ cd randomex_demo/
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix local.hex --force
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix local.rebar --force
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix deps.get && mix compile
tim@tim-VirtualBox:~/tmp/randomex_demo$ mix release
tim@tim-VirtualBox:~/tmp/randomex_demo$ rel/randomex_demo/bin/randomex_demo console --ranges 32,111 --samples 500,1000,1500 --sets 1
tim@tim-VirtualBox:~/tmp/randomex_demo$ ls ./rel/randomex_demo/output/
1446762883160217.txt index.txt
```
