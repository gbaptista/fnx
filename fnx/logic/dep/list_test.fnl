(local t (require :fspec))

(local logic (require :fnx.logic.dep.list))

(t.eq
  (logic.prepare
    [{:identifier "demo"
      :language "lua"
      :provider "local"
      :usage-path "/home/me/personal/projects/lua-demo"}
     {:identifier "fspec"
      :language "fennel"
      :provider "local"
      :usage-path "/home/me/personal/projects/amplifier-project/fspec"}
     {:identifier "fspec2"
      :install-from {:mode "local" :path "../fspec"}
      :language "fennel"
      :provider "fnx"
      :usage-path "/home/me/.fnx/packages/fspec2/local"}
     {:identifier "inspect"
      :install-from {:mode "luarocks" :version ">= 3.1.2"}
      :language "lua"
      :provider "rock"}
     {:identifier "inv2"
      :language "lua"
      :provider "local"
      :usage-path "/home/me/personal/projects/lorem"}
     {:identifier "luafs"
      :install-from {:mode "luarocks" :version ">= 1.8.0"}
      :language "lua"
      :provider "rock"}
     {:identifier "supernova"
      :install-from {:mode "luarocks" :version ">= 0.0.2"}
      :language "lua"
      :provider "rock"}]
    {:demo true
     :fspec true
     :fspec2 false
     :inspect false
     :inv2 false
     :luafs "1.8.0-1"
     :supernova "0.0.2-1"})
  [{:available? true
    :expected "/home/me/personal/projects/lua-demo"
    :identifier "demo"
    :installable? false
    :language "lua"
    :state "ok"}
   {:available? true
    :expected "/home/me/personal/projects/amplifier-project/fspec"
    :identifier "fspec"
    :installable? false
    :language "fennel"
    :state "ok"}
   {:available? false
    :expected "../fspec"
    :identifier "fspec2"
    :installable? true
    :language "fennel"
    :state "missing"}
   {:available? false
    :expected ">= 3.1.2"
    :identifier "inspect"
    :installable? true
    :language "lua"
    :state "missing"}
   {:available? false
    :expected "/home/me/personal/projects/lorem"
    :identifier "inv2"
    :installable? false
    :language "lua"
    :state "missing"}
   {:available? true
    :expected ">= 1.8.0"
    :identifier "luafs"
    :installable? true
    :language "lua"
    :state "1.8.0-1"}
   {:available? true
    :expected ">= 0.0.2"
    :identifier "supernova"
    :installable? true
    :language "lua"
    :state "0.0.2-1"}])

(let [colors {
      :lua       #(.. $1)
      :fennel    #(.. $1)
      :-   #(.. $1)
      :available #(.. $1)
      :expected  #(.. $1)}]
  (t.eq
    (logic.build-sml-table
      [{:available? true
        :expected ">= 0.0.2"
        :identifier "supernova"
        :language "lua"
        :state "0.0.2-1"}]
      colors)
    [[["supernova" "right" colors.lua]
     ["0.0.2-1" "center" colors.available]
     [">= 0.0.2" "left" colors.expected]]]))

(t.run!)
