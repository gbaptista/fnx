(local helper/list (require :fnx.helpers/list))

(local logic {})

(fn logic.build [config ?fennel-path]
  (let [fennel-path (or ?fennel-path "")]
    (local variables [(.. "FNX_DATA_DIRECTORY=" (. config :fnx-data-directory))])
    (table.insert
      variables
      (if (or (= fennel-path "") (= (string.sub fennel-path -1) ";"))
        (.. "FENNEL_PATH=" fennel-path (. config :fnx-core-path) "?.fnl")
        (.. "FENNEL_PATH=" fennel-path ";" (. config :fnx-core-path) "?.fnl")))
    (helper/list.sort variables)))

logic
