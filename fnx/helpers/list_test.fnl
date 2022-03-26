(local t (require :fspec))

(local helper (require :fnx.helpers.list))

(t.eq (helper.unpack ["a" "b" "c"]) "a")
(t.eq (helper.unpack [1 2]) 1)

(t.eq (helper.exists? "a" ["a" "b"]) true)
(t.eq (helper.exists? "c" ["a" "b"]) false)

(t.eq
  (helper.insert-between
    #(= (. $1 :color) "blue")
    #(= (. $1 :color) "red")
    {:custom "empty"}
    [{:color "blue"}
     {:color "blue"}
     {:color "red"}
     {:color "red"}])
  [{:color "blue"}
   {:color "blue"}
   {:custom "empty"}
   {:color "red"}
   {:color "red"}])

(t.eq (helper.legacy-pack "a" "b" "c")  {1 "a" 2 "b" 3 "c" :n 3})

(t.eq (helper.pack "a" "b" "c") {1 "a" 2 "b" 3 "c" :n 3})

(t.eq (helper.concat ["a" "b"] ["c" "d"] ["e" "f"])  ["a" "b" "c" "d" "e" "f"])

(t.eq (helper.flatten [["a" "b"] ["c" "d"] ["e" "f"]])  ["a" "b" "c" "d" "e" "f"])

(t.eq (helper.sort ["b" "d" "c" "a"]) ["a" "b" "c" "d"])

(t.eq
  (helper.sort-by :l [{:l "b"} {:l "d"} {:l "c"} {:l "a"}])
  [{:l "a"} {:l "b"} {:l "c"} {:l "d"}])

(t.eq
  (helper.filter #(= (. $1 :l) "b") [{:l "b"} {:l "d"} {:l "c"} {:l "a"}])
  [{:l "b"}])

(t.eq
  (helper.sort-by-reverse :l [{:l "b"} {:l "d"} {:l "c"} {:l "a"}])
  [{:l "d"} {:l "c"} {:l "b"} {:l "a"}])

(t.eq
  (helper.sort-by-f #(. $1 :l) [{:l "b"} {:l "d"} {:l "c"} {:l "a"}])
  [{:l "a"} {:l "b"} {:l "c"} {:l "d"}])

(t.eq
  (helper.uniq ["a" "a" "b" "c" "a"])
  ["a" "b" "c"])

(t.eq
  (helper.insert-between-if
    {:custom "empty"}
    #(not (= (. $1 :color) (. $2 :color)))
    [{:color "blue"}
     {:color "blue"}
     {:color "red"}
     {:color "red"}
     {:color "yellow"}
     {:color "yellow"}])
  [{:color "blue"}
   {:color "blue"}
   {:custom "empty"}
   {:color "red"}
   {:color "red"}
   {:custom "empty"}
   {:color "yellow"}
   {:color "yellow"}])

(t.run!)
