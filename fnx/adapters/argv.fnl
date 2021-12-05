(local helper/string (require :fnx.helpers.string))

(local adapter {})

(fn adapter.parse [arguments ?after]
  (let [after (or ?after 0)]
    {:present (adapter.input->presences (adapter.input->list arguments after))
     :list    (adapter.input->list arguments (+ after 1))
     :smart   (adapter.input->smart (adapter.input->list arguments (+ after 2)))
     :command (. arguments (+ after 1))}))

(fn adapter.input->presences [arguments]
  (local result {})
  (each [_ value (ipairs arguments)]
    (tset result value true))
  result)

(fn adapter.input->list [arguments after]
  (local result [])
  (each [i value (ipairs arguments)]
    (when (> i after)
      (table.insert result value)))
  result)

(fn adapter.input->smart [arguments]
  (local result {})
  (var key nil)

  (each [_ fragment (pairs arguments)]
    (if (string.find fragment "=")
      (let [parts (helper/string.split "=" fragment)
            key   (. parts 1)
            value (. parts 2)]
        (tset result (helper/string.strip-dash key) value))
      (do
        (if (= key nil)
          (set key fragment)
          (do
            (tset result (helper/string.strip-dash key) fragment)
            (set key nil))))))

  (if (not= key nil)
    (tset result :dangling key))

  result)

adapter
