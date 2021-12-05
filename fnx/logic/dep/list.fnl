(local sn (require :supernova))

(local helper/list (require :fnx.helpers/list))

(local logic {
  :formatters
    { :available #(sn.green (.. " " $1 " "))
      :expected  #(sn.yellow $1)
      :fennel    #(sn.cyan $1)
      :lua       #(sn.blue $1)
      :missing   #(sn.red (.. " " $1 " "))}})

(fn logic.build-sml-table [prepared-dependencies formatters?]
  (let [formatters (or formatters? logic.formatters)]
    (local result [])
    (each [_ item (pairs prepared-dependencies)]
      (if item.custom
        (table.insert result item.data)
        (table.insert result
         [[item.identifier :right 
             (if (= item.language :lua) formatters.lua formatters.fennel)]
          [item.state :center
             (if item.available? formatters.available formatters.missing)]
          [item.expected :left
             (if item.installable? nil formatters.expected)]])))
    result))

(fn logic.installable [dependencies]
  (helper/list.filter #(. $1 :install-from) dependencies))

(fn logic.fnx-only [dependencies]
  (helper/list.filter #(= (. $1 :provider) :fnx) dependencies))

(fn logic.not-installed [dependencies state]
  (local result [])
  (each [_ dependency (pairs dependencies)]
    (if (and
          (not (. state dependency.identifier))
          dependency.install-from)
      (table.insert result dependency)))
  result)

(fn logic.sort-to-display [prepared-dependencies]
  (->>
    prepared-dependencies
    (helper/list.sort-by-f
      #(.. (if (. $1 :available?) "a" "b")
           (if (. $1 :installable?) "a" "b")
           (. $1 :identifier)))
    (helper/list.insert-between
      #(. $1 :installable?)
      #(not (. $1 :installable?))
      {:custom true :available? true :data ["" "" ""]})
    (helper/list.insert-between
      #(. $1 :available?)
      #(not (. $1 :available?))
      {:custom true :data ["" "" ""]})))

(fn logic.prepare [dependencies state]
  (local result
    (helper/list.map
     #(logic.prepare-dependency $1 state)
     dependencies))
  (helper/list.sort-by :identifier result)
  result)

(fn logic.prepare-dependency [dependency state]
  (local result
    {:identifier   dependency.identifier
     :language     dependency.language
     :available?   (if (. state dependency.identifier) true false)
     :installable? (if dependency.install-from true false)})

  (if (= dependency.provider :local)
    (tset result :state (if (. state dependency.identifier) "ok" "missing"))
    (tset result :state (if (. state dependency.identifier) "ok" "missing")))

  (local mode
    (if (and dependency.install-from dependency.install-from.mode)
      dependency.install-from.mode
      dependency.install-from))

  (match [dependency.provider mode]
    [:rock   i]
    (do
      (tset result :expected dependency.install-from.version)
      (if (. state dependency.identifier)
        (tset result :state (. state dependency.identifier))))
    [:fnx   :git] (tset result :expected dependency.install-from.version)
    [_      :local] (tset result :expected dependency.install-from.path)
    [:local  _] (tset result :expected dependency.usage-path))
  result)

logic
