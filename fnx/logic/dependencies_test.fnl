(local t (require :fspec))

(local logic (require :fnx.logic.dependencies))

(t.eq
  (logic.build "/" "/home/.fnx/" {
    "package-a" { :fennel/fnx { :path "/lorem" } }
    "package-b" { :fennel/local "/lorem/amet" }
    "package-c" { :lua/local "/dolor/sit" }
    "package-s" {:lua/rock ">= 0.0.2"}})

  [{:cyclic-key "fnx:/home/.fnx/packages/package-a/local"
    :dot-fnx-candidate-path "/home/.fnx/packages/package-a/local/.fnx.fnl"
    :identifier "package-a"
    :install-from {:mode "local" :path "/lorem" :version "local"}
    :language "fennel"
    :provider "fnx"
    :usage-path "/home/.fnx/packages/package-a/local"}
   {:cyclic-key "fennel:/lorem/amet"
    :dot-fnx-candidate-path "/lorem/amet/.fnx.fnl"
    :identifier "package-b"
    :language "fennel"
    :provider "local"
    :usage-path "/lorem/amet"}
   {:cyclic-key "lua:/dolor/sit"
    :dot-fnx-candidate-path "/dolor/sit/.fnx.fnl"
    :identifier "package-c"
    :language "lua"
    :provider "local"
    :usage-path "/dolor/sit"}
   {:cyclic-key "rock:package-s"
    :identifier "package-s"
    :install-from {:mode "luarocks" :version ">= 0.0.2"}
    :language "lua"
    :provider "rock"}])

(t.eq
  (logic.build-dependency
    "package-name" { :fennel/fnx { :path "/lorem" } } "/" "/home/.fnx/")

  {:cyclic-key "fnx:/home/.fnx/packages/package-name/local"
   :dot-fnx-candidate-path "/home/.fnx/packages/package-name/local/.fnx.fnl"
   :identifier "package-name"
   :install-from {:mode "local" :path "/lorem" :version "local"}
   :language "fennel"
   :provider "fnx"
   :usage-path "/home/.fnx/packages/package-name/local"})

(t.eq
  (logic.build-dependency
    "package-name" { :fennel/local "/lorem/amet" } "/" "/home/.fnx/")

  {:cyclic-key "fennel:/lorem/amet"
   :dot-fnx-candidate-path "/lorem/amet/.fnx.fnl"
   :identifier "package-name"
   :language "fennel"
   :provider "local"
   :usage-path "/lorem/amet"})

(t.eq
  (logic.build-dependency
    "package-name" { :lua/local "/dolor/sit" } "/" "/home/.fnx/")

  {:cyclic-key "lua:/dolor/sit"
   :dot-fnx-candidate-path "/dolor/sit/.fnx.fnl"
   :identifier "package-name"
   :language "lua"
   :provider "local"
   :usage-path "/dolor/sit"})

(t.eq
  (logic.build-dependency
    "supernova" {:lua/rock ">= 0.0.2"} "/" "/home/.fnx/")

  {:cyclic-key "rock:supernova"
   :identifier "supernova"
   :install-from {:mode "luarocks" :version ">= 0.0.2"}
   :language "lua"
   :provider "rock"})

(t.eq
  (logic.injection-candidates [
    {:identifier "package-a"
     :install-from {:mode "local" :path "../lorem"}
     :language "fennel"
     :provider "fnx"
     :usage-path "/home/.fnx/packages/package-a/local"
     :dot-fnx-candidate-path "/home/.fnx/packages/package-a/local/.fnx.fnl"}
    {:identifier "package-b"
     :language "fennel"
     :provider "local"
     :usage-path "/lorem/amet"
     :dot-fnx-candidate-path "/lorem/amet/.fnx.fnl"}
    {:identifier "package-c"
     :language "lua"
     :provider "local"
     :usage-path "/dolor/sit"
     :dot-fnx-candidate-path "/dolor/sit/.fnx.fnl"}
    {:identifier "package-s"
     :install-from {:mode "luarocks" :version ">= 0.0.2"}
     :language "lua"
     :provider "rock"}])

  [{:dot-fnx-candidate-path "/home/.fnx/packages/package-a/local/.fnx.fnl"
    :identifier "package-a"
    :install-from {:mode "local" :path "../lorem"}
    :language "fennel"
    :provider "fnx"
    :usage-path "/home/.fnx/packages/package-a/local"}
   {:dot-fnx-candidate-path "/lorem/amet/.fnx.fnl"
    :identifier "package-b"
    :language "fennel"
    :provider "local"
    :usage-path "/lorem/amet"}
   {:dot-fnx-candidate-path "/dolor/sit/.fnx.fnl"
    :identifier "package-c"
    :language "lua"
    :provider "local"
    :usage-path "/dolor/sit"}])

(t.eq
  (logic.to-injection [{:identifier "package-a"
    :install-from {:mode "local" :path "../lorem"}
    :language "fennel"
    :provider "fnx"
    :usage-path "/home/.fnx/packages/package-a/local"
    :dot-fnx-candidate-path "/home/.fnx/packages/package-a/local/.fnx.fnl"}
   {:identifier "package-b"
    :language "fennel"
    :provider "local"
    :usage-path "/lorem/amet"
    :dot-fnx-candidate-path "/lorem/amet/.fnx.fnl"}
   {:identifier "package-c"
    :language "lua"
    :provider "local"
    :usage-path "/dolor/sit"
    :dot-fnx-candidate-path "/dolor/sit/.fnx.fnl"}])

  (.. " --add-fennel-path /home/.fnx/packages/package-a/local/?.fnl "
      "--add-fennel-path /lorem/amet/?.fnl "
      "--add-package-path /dolor/sit/?.lua"))

(t.eq
  (logic.build "/" "/home/.fnx/" {
    "pastel_mint" {:lua/local "./radioactive/pastel_mint.lua"}})
  [{:cyclic-key "lua:/radioactive/pastel_mint.lua"
    :dot-fnx-candidate-path "/radioactive/.fnx.fnl"
    :identifier "pastel_mint"
    :language "lua"
    :provider "local"
    :usage-path "/radioactive/pastel_mint.lua"}])

(t.eq
  (logic.to-injection [
    {:identifier "pastel_mint"
     :language "lua"
     :provider "local"
     :usage-path "/radioactive/pastel_mint.lua"
     :dot-fnx-candidate-path "/radioactive/.fnx.fnl"}])
  " --add-package-path /radioactive/?.lua")

(t.eq
  (logic.to-injection [
    {:identifier "pastel-mint"
     :language "fennel"
     :provider "local"
     :usage-path "/radioactive/pastel-mint.fnl"
     :dot-fnx-candidate-path "/radioactive/.fnx.fnl"}])
  " --add-fennel-path /radioactive/?.fnl")

(t.eq
  (logic.build "/" "/home/.fnx/" {
    :hello-world {:fennel/fnx {:git/url "https://github.com/gbaptista/fnx-hello-world.git"}}})

  [{:cyclic-key "fnx:/home/.fnx/packages/hello-world/local"
    :dot-fnx-candidate-path "/home/.fnx/packages/hello-world/local/.fnx.fnl"
    :identifier "hello-world"
    :install-from {:mode "git"
                   :url "https://github.com/gbaptista/fnx-hello-world.git"
                   :version "local"}
    :language "fennel"
    :provider "fnx"
    :usage-path "/home/.fnx/packages/hello-world/local"}])

(t.eq
  (logic.build-dependency
    "hello-world" {:fennel/fnx {:git/github "gbaptista/fnx-hello-world"}}
    "/" "/home/.fnx/")

  {:cyclic-key "fnx:/home/.fnx/packages/hello-world/local"
   :dot-fnx-candidate-path "/home/.fnx/packages/hello-world/local/.fnx.fnl"
   :identifier "hello-world"
   :install-from {:mode "git"
                  :url "https://github.com/gbaptista/fnx-hello-world.git"
                  :version "local"}
   :language "fennel"
   :provider "fnx"
   :usage-path "/home/.fnx/packages/hello-world/local"})

(t.eq
  (logic.build-dependency
    "hello-world"
    { :fennel/fnx
        {:git/github "gbaptista/fnx-hello-world"
         :commit "32e81e5ada283b66710b6494638af2c9bc255195"}}
    "/" "/home/.fnx/")

  {:cyclic-key "fnx:/home/.fnx/packages/hello-world/32e81e5"
   :dot-fnx-candidate-path "/home/.fnx/packages/hello-world/32e81e5/.fnx.fnl"
   :identifier "hello-world"
   :install-from {:mode   "git"
                  :url    "https://github.com/gbaptista/fnx-hello-world.git"
                  :commit "32e81e5ada283b66710b6494638af2c9bc255195"
                  :version "32e81e5"}
   :language "fennel"
   :provider "fnx"
   :usage-path "/home/.fnx/packages/hello-world/32e81e5"})

(t.eq
  (logic.build-dependency
    "hello-world"
    { :fennel/fnx
        {:git/sourcehut "~gbaptista/fnx-hello-world"
         :commit "32e81e5ada283b66710b6494638af2c9bc255195"}}
    "/" "/home/.fnx/")

  {:cyclic-key "fnx:/home/.fnx/packages/hello-world/32e81e5"
   :dot-fnx-candidate-path "/home/.fnx/packages/hello-world/32e81e5/.fnx.fnl"
   :identifier "hello-world"
   :install-from {:commit "32e81e5ada283b66710b6494638af2c9bc255195"
                  :mode "git"
                  :url "https://git.sr.ht/~gbaptista/fnx-hello-world"
                  :version "32e81e5"}
   :language "fennel"
   :provider "fnx"
   :usage-path "/home/.fnx/packages/hello-world/32e81e5"})

(t.eq
  (logic.build-dependency
    "hello-world"
    { :fennel/fnx
        {:git/sourcehut "~gbaptista/fnx-hello-world"
         :branch "gb-triggers"}}
    "/" "/home/.fnx/")

  {:cyclic-key "fnx:/home/.fnx/packages/hello-world/gb-triggers"
   :dot-fnx-candidate-path "/home/.fnx/packages/hello-world/gb-triggers/.fnx.fnl"
   :identifier "hello-world"
   :install-from {:branch "gb-triggers"
                  :mode "git"
                  :url "https://git.sr.ht/~gbaptista/fnx-hello-world"
                  :version "gb-triggers"}
   :language "fennel"
   :provider "fnx"
   :usage-path "/home/.fnx/packages/hello-world/gb-triggers"})


(t.eq
  (logic.build-dependency
    "hello-world"
    { :fennel/fnx
        {:git/sourcehut "~gbaptista/fnx-hello-world"
         :branch "gb-triggers"
         :commit "32e81e5ada283b66710b6494638af2c9bc255195"}}
    "/" "/home/.fnx/")

  {:cyclic-key "fnx:/home/.fnx/packages/hello-world/32e81e5"
   :dot-fnx-candidate-path "/home/.fnx/packages/hello-world/32e81e5/.fnx.fnl"
   :identifier "hello-world"
   :install-from {:branch "gb-triggers"
                  :commit "32e81e5ada283b66710b6494638af2c9bc255195"
                  :mode "git"
                  :url "https://git.sr.ht/~gbaptista/fnx-hello-world"
                  :version "32e81e5"}
   :language "fennel"
   :provider "fnx"
   :usage-path "/home/.fnx/packages/hello-world/32e81e5"})

(t.eq
  (logic.build-dependency
    "hello-world"
    { :fennel/fnx
        {:git/sourcehut "~gbaptista/fnx-hello-world"
         :tag "v0.0.1"}}
    "/" "/home/.fnx/")

  {:cyclic-key "fnx:/home/.fnx/packages/hello-world/v0.0.1"
   :dot-fnx-candidate-path "/home/.fnx/packages/hello-world/v0.0.1/.fnx.fnl"
   :identifier "hello-world"
   :install-from {:mode "git"
                  :tag "v0.0.1"
                  :url "https://git.sr.ht/~gbaptista/fnx-hello-world"
                  :version "v0.0.1"}
   :language "fennel"
   :provider "fnx"
   :usage-path "/home/.fnx/packages/hello-world/v0.0.1"})

(t.eq
  (logic.build-dependency
    "hello-world"
    { :fennel/fnx
        {:git/sourcehut "~gbaptista/fnx-hello-world"
         :branch "gb-lorem"
         :tag "v0.0.1"}}
    "/" "/home/.fnx/")

  {:cyclic-key "fnx:/home/.fnx/packages/hello-world/gb-lorem"
   :dot-fnx-candidate-path "/home/.fnx/packages/hello-world/gb-lorem/.fnx.fnl"
   :identifier "hello-world"
   :install-from {:branch "gb-lorem"
                  :mode "git"
                  :tag "v0.0.1"
                  :url "https://git.sr.ht/~gbaptista/fnx-hello-world"
                  :version "gb-lorem"}
   :language "fennel"
   :provider "fnx"
   :usage-path "/home/.fnx/packages/hello-world/gb-lorem"})

(t.run!)
