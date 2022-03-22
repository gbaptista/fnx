(local logic {})

(fn logic.working-directory [?dot-fnx-path]
  (let [dot-fnx-path (or ?dot-fnx-path "")
        dot-fnx-path (string.gsub dot-fnx-path ".fnx.fnl$" "")]
     (if (= dot-fnx-path "")
       nil 
       (if (= (string.len dot-fnx-path) 1)
         dot-fnx-path
         (string.gsub dot-fnx-path "/$" "")))))

logic
