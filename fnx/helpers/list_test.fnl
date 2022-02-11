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

(t.run!)
