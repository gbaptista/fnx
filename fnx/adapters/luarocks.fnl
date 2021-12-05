(local adapter {})

(fn adapter.show->version [raw]
  (let [version (string.match raw "%d+%.%d+.%d+%-%d")]
    (if version version false)))

(fn adapter.dependency->show [dependency arguments]
  (if (and (. arguments :present) (. arguments.present :--global))
    (.. "luarocks show " dependency.identifier " --global 2>/dev/null")
    (.. "luarocks show " dependency.identifier " --local 2>/dev/null")))

adapter
