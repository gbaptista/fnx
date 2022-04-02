(local helper {})

(fn helper.legacy-pack [...]
  (let [result [...]]
    (tset result :n (select "#" ...))
    result))

(fn helper.pack [...]
  (let [pack-fn (or (. table :pack) helper.legacy-pack)]
    (pack-fn ...)))

(fn helper.unpack [...]
  (let [unpack-fn (or (. table :unpack) (. _G :unpack))]
    (unpack-fn ...)))

(fn helper.insert-between-if [to-insert f list]
  (local result [])
  (var first true)
  (var previous nil)

  (each [_ value (pairs list)]
    (when (not first)
      (when (f previous value) (table.insert result to-insert)))
      (table.insert result value)
    (set previous value)
    (set first false))

  result)

(fn helper.insert-between [f-before f-after to-insert list]
  (local result list)
  (var done false)
  (var before false)

  (each [i item (pairs list)]
    (let [after (f-after item)]
      (if (and (not done) before after)
        (do
          (table.insert list i to-insert)
          (set done true))
        (set before (f-before item)))))

  result)

(fn helper.exists? [wanted list]
  (var found false)
  (each [_ candidate (pairs list)]
    (when (= candidate wanted) (set found true)))
  found)

(fn helper.sort [list]
  (table.sort list)
  list)

(fn helper.sort-by [key list]
  (table.sort list (fn [a b]
    (if (or (= (type (. a key)) :boolean) (= (type (. b key)) :boolean))
      (< (tostring (. a key)) (tostring (. b key)))
      (< (. a key) (. b key)))))
  list)

(fn helper.sort-by-f [f list]
  (table.sort list (fn [a b]
    (if (or (= (type (f a)) :boolean) (= (type (f b)) :boolean))
      (< (tostring (f a)) (tostring (f b)))
      (< (f a) (f b)))))
  list)

(fn helper.sort-by-reverse [key list]
  (table.sort list (fn [a b]
    (if (or (= (type (. a key)) :boolean) (= (type (. b key)) :boolean))
      (> (tostring (. a key)) (tostring (. b key)))
      (> (. a key) (. b key)))))
  list)

(fn helper.filter [f list]
  (local result [])
  (each [_ item (pairs list)]
    (when (f item) (table.insert result item)))
  result)

(fn helper.reduce-iterator [f iterator ?acc]
  (let [
    acc (if (= ?acc nil) 0 ?acc)
    head (iterator)]
      (if (= head nil)
        acc
        (helper.reduce-iterator
          f iterator
          (f acc head)))))

(fn helper.join [?glue list]
  (var result "")
  (let [glue (if (= ?glue nil) " " ?glue)]
    (each [index value (pairs list)]
      (if (> index 1)
        (set result (.. result glue value))
        (set result (.. result value)))))
  result)

(fn helper.reduce [f list ?acc]
  (let [
    acc (if (= ?acc nil) 0 ?acc)
    [head & tail] list]
      (if (= head nil)
        acc
        (helper.reduce f tail (f acc head)))))

(fn helper.count [list]
  (helper.reduce #(+ $1 1) list))

(fn helper.map [f list]
  (helper.reduce
    #(do (table.insert $1 (f $2)) $1) list []))

(fn helper.concat [...]
  (let [result []]
    (each [_ list (ipairs (helper.pack ...))]
      (each [_ value (pairs list)] (table.insert result value)))
    result))

(fn helper.flatten [lists]
  (helper.concat (helper.unpack lists)))

(fn helper.uniq [list]
  (local control {})
  (local result [])
  (each [_ value (pairs list)]
    (when (not (. control value))
      (table.insert result value)
      (tset control value true)))
  result)

helper
