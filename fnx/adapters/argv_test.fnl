(local t (require :fspec))

(local adapter (require :fnx.adapters.argv))

(t.eq
  (adapter.parse {
   -3 "/bin/lua5.4"
   -2 "package.path=/lua/5.4/?.lua"
   -1 "/bin/fennel"

    1 "run"
    2 "file.fnl"
    3 "-a"
    4 "b"
    5 "-c=d"
    6 "--lorem"})

  {:command "run"
   :list    ["file.fnl" "-a" "b" "-c=d" "--lorem"]
   :present {:--lorem true :-a true :-c=d true :b true :file.fnl true :run true}
   :smart {:a "b" :c "d" :dangling "--lorem"}})

(t.eq
  (adapter.parse {
   -3 "/bin/lua5.4"
   -2 "package.path=/lua/5.4/?.lua"
   -1 "/bin/fennel"

    1 "dep"
    2 "run"
    3 "file.fnl"
    4 "-a"
    5 "b"
    6 "-c=d"
    7 "--lorem"} 1)

  {:command "run"
   :list    ["file.fnl" "-a" "b" "-c=d" "--lorem"]
   :present {:--lorem true :-a true :-c=d true :b true :file.fnl true :run true}
   :smart {:a "b" :c "d" :dangling "--lorem"}})

(t.run!)
