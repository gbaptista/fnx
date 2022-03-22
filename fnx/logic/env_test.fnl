(local t (require :fspec))

(local logic (require :fnx.logic.env))

(t.eq
  (logic.build
     {:fnx-binary-path "/home/me/.local/bin/fnx"
      :fnx-config-file-path "/home/me/.config/.fnx.config.fnl"
      :fnx-core-mode "duplicate-files"
      :fnx-core-path "/home/me/.local/share/.fnx/core/"
      :fnx-data-directory "/home/me/.local/share/.fnx/"})
  ["FENNEL_PATH=/home/me/.local/share/.fnx/core/?.fnl"
   "FNX_DATA_DIRECTORY=/home/me/.local/share/.fnx/"])

(t.eq
  (logic.build
     {:fnx-core-path "/home/me/.local/share/.fnx/core/"
      :fnx-data-directory "/home/me/.local/share/.fnx/"}
     "./?.fnl;./?/init.fnl")
  ["FENNEL_PATH=/home/me/.local/share/.fnx/core/?.fnl;./?.fnl;./?/init.fnl"
   "FNX_DATA_DIRECTORY=/home/me/.local/share/.fnx/"])

(t.eq
  (logic.build
     {:fnx-core-path "/home/me/.local/share/.fnx/core/"
      :fnx-data-directory "/home/me/.local/share/.fnx/"}
     "./?.fnl;./?/init.fnl;")
  ["FENNEL_PATH=/home/me/.local/share/.fnx/core/?.fnl;./?.fnl;./?/init.fnl;"
   "FNX_DATA_DIRECTORY=/home/me/.local/share/.fnx/"])

(t.eq
  (logic.build
     {:fnx-core-path "/home/me/.local/share/.fnx/core/"
      :fnx-data-directory "/home/me/.local/share/.fnx/"}
     ";./?.fnl;./?/init.fnl")
  ["FENNEL_PATH=/home/me/.local/share/.fnx/core/?.fnl;./?.fnl;./?/init.fnl"
   "FNX_DATA_DIRECTORY=/home/me/.local/share/.fnx/"])

(t.run!)
