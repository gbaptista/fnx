(local helper/list (require :fnx.helpers/list))

(local logic {})

(fn logic.build [config ?fennel-path]
  (let [fennel-path (or ?fennel-path "")]
    (local variables [])
    (each [key value (pairs config)]
      (let [key (-> (string.gsub key "-" "_") (string.upper))]
        (table.insert variables (.. key "=" value))))
    (table.insert
      variables
      (if (or (= fennel-path "") (= (string.sub fennel-path -1) ";"))
        (.. "FENNEL_PATH=" fennel-path (. config :fnx-core-path) "?.fnl")
        (.. "FENNEL_PATH=" fennel-path ";" (. config :fnx-core-path) "?.fnl")))
    (helper/list.sort variables)))

logic
