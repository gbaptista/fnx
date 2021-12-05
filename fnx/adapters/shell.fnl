(local helper/list (require :fnx.helpers.list))

(local adapter {})

(fn adapter.smk->string [smk]
  (local lines [])
  (each [_ item (pairs smk)]
    (let [(kind content) (table.unpack item)]
      (match kind
        :line     (table.insert lines (adapter.item->string (adapter.build-item content)))
        :fragment (table.insert lines (adapter.item->string (adapter.build-item content)))
        :table    (table.insert lines (adapter.table->string content)))))
   (helper/list.join "\n" lines))

(fn adapter.item->string [input]
  (var result (. input :text))
  (let [f         (. input :f)
        size      (. input :size)
        alignment (. input :alignment)]
    (if size (set result (adapter.ensure-size result size alignment)))
    (if f (set result (f result))))
  result)

(fn adapter.table->string [smk]
  (local input smk)
  (local column-sizes {})

  (each [_ line (pairs input)]
    (each [i column (pairs line)]
      (tset line i (adapter.build-item column))))

  (each [_ line (pairs input)]
    (each [i column (pairs line)]
      (let [size    (string.len (. column :text))
            current (. column-sizes i)]
        (if (or (not current) (> size current))
          (tset column-sizes i size)))))

  (local lines [])

  (each [_ line (pairs input)]
    (local columns [])
    (each [i column (pairs line)]
      (tset column :size (. column-sizes i))
      (table.insert columns (adapter.item->string column)))
    (table.insert lines (helper/list.join " " columns)))
  (helper/list.join "\n" lines))

(fn adapter.build-item [input]
  (local result {})
  (if (= (type input) "table")
    (each [i part (ipairs input)]
      (if (= i 1)
        (tset result :text part)
        (match (type part)
          :string (tset result :alignment part)
          :function (tset result :f part))))
    (tset result :text input))
  result)

(fn adapter.ensure-size [text size ?alignment ?fill]
  (var side :left)
  (let [fill      (if (and ?fill (> (string.len ?fill) 0)) ?fill " ")
        alignment (or ?alignment :left)]
    (var result text)
    (while (< (string.len result) size)
      (if (= alignment :center)
        (if (= side :left)
          (do
            (set result (.. fill result))
            (set side :right))
          (do
            (set result (.. result fill))
            (set side :left)))
      (if (= alignment :left)
        (set result (.. result fill))
        (set result (.. fill result)))))
    result))

adapter
