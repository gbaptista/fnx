(local t (require :fspec))

(local adapter (require :fnx.adapters.shell))

(t.eq (adapter.item->string {:text "ab"}) "ab")
(t.eq (adapter.item->string {:text "ab" :size 4 :alignment :right}) "  ab")
(t.eq (adapter.item->string {:text "ab" :f #(.. ":" $1 ":") :size 4 :alignment :right}) ":  ab:")

(t.eq (adapter.item->string {:text "a" :size 5 :alignment :center}) "  a  ")

(t.eq
  (adapter.table->string
    [[["a" :right]]
     ["lorem"]
     [["b" :right]]])
  "    a\nlorem\n    b")

(t.eq
  (adapter.smk->string
    [[:fragment "-a b"]])
  "-a b")

(let [f #(.. $1 "-")]
  (t.eq
    (adapter.build-item ["ab" f :right])
    {:text "ab" :alignment "right" :f f}))

(t.eq
  (adapter.smk->string
    [[:line ["Lorem" #(.. ":" $1) :right]]])
  ":Lorem")

(t.eq
  (adapter.smk->string
    [[:line ["Lorem" :left #(.. "-" $1)]]
     [:line "ipsum!"]])
  "-Lorem\nipsum!")

(t.eq
  (adapter.smk->string
    [[:table [
       [["pack-a" :right #(.. $1 ":")]
        "2.5"]
       ["package-b" :left
        "3.8"]]]])
  "   pack-a: 2.5 \npackage-b left 3.8")

(t.eq
  (adapter.smk->string
   [[:line "Lorem"]
    [:line ["Lorem" #(.. $1 ">")]]
    [:table [
      [["a" :right] "b" "c"]
      [["sit" #(.. "<" $1) :right] "lorem" "ipsum"]]]])
  "Lorem\nLorem>\n  a b     c    \n<sit lorem ipsum")

(t.eq (adapter.ensure-size "ab" 3) "ab ")
(t.eq (adapter.ensure-size "ab" 5 :right "-") "---ab")
(t.eq (adapter.ensure-size "ab" 5 :left "?") "ab???")
(t.eq (adapter.ensure-size "ab" 5 :right "") "   ab")
(t.eq (adapter.ensure-size "ab" 5) "ab   ")
(t.eq (adapter.ensure-size "ab" 1) "ab")

(t.eq (adapter.build-item "ab") {:text "ab"})
(t.eq (adapter.build-item ["ab"]) {:text "ab"})
(t.eq (adapter.build-item ["ab" :right]) {:text "ab" :alignment "right"})

(t.run!)
