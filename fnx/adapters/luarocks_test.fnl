(local t (require :fspec))

(local adapter (require :fnx.adapters.luarocks))

(t.eq
  (adapter.dependency->show
   {:identifier "supernova"
    :install-from {:mode "luarocks" :version ">= 0.0.2"}
    :language "lua"
    :provider "rock"}
    {})
  "luarocks show supernova --local 2>/dev/null")

(t.eq
  (adapter.dependency->show
    {:identifier "supernova"
     :install-from {:mode "luarocks" :version ">= 0.0.2"}
     :language "lua"
     :provider "rock"}
    {:command "list"
     :list ["--local"]
     :present {:--local true :list true}
     :smart {}})
  "luarocks show supernova --local 2>/dev/null")

(t.eq
  (adapter.dependency->show
    {:identifier "supernova"
     :install-from {:mode "luarocks" :version ">= 0.0.2"}
     :language "lua"
     :provider "rock"}
    {:command "list"
     :list ["--global"]
     :present {:--global true :list true}
     :smart {}})
  "luarocks show supernova --global 2>/dev/null")

(let [show-output
        (..
          "\nsupernova 0.0.2-1 - Terminal string styling. Put some color in your console!\n\n"
          "Terminal string styling. Put some color in your console! Support for Fennel,\n"
          "Lua, and Shell.\n\n"
          "License:        MIT\n"
          "Homepage:       https://github.com/me/supernova\n"
          "Installed in:   /home/me/.luarocks\n\n"
          "Commands:\n"
          "        /bin/supernova (/bin/supernova)\n\n"
          "Modules:\n"
          "        supernova (//lua/5.4/supernova.lua)\n\n"
          "Depends on:\n"
          "        lua >= 5.1 (using 5.4-1)")]
  (t.eq
    (adapter.show->version show-output)
    "0.0.2-1"))

(let [show-output
        (..
          "\n\ndkjson 2.5-3 - David Kolf's JSON module for Lua\n\n"
          "        lua >= 5.1, < 5.5 (using 5.4-1)\n")]
  (t.eq
    (adapter.show->version show-output)
    "2.5-3"))

(let [show-output
        (.. "\nError: cannot find package lorem"
            "Use 'list' to find installed rocks.")]
  (t.eq
    (adapter.show->version show-output)
    false))

(t.eq (adapter.show->version "") false)

(t.run!)
