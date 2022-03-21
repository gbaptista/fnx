(local t (require :fspec))

(local helper (require :fnx.helpers.string))

(t.eq (helper.strip "/folder/file\n") "/folder/file")
(t.eq (helper.strip-dash "-force") "force")
(t.eq (helper.split "=" "a=b c = d") ["a" "b c " " d"])

(t.run!)
