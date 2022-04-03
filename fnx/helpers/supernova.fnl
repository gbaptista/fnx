(local styles
  [:blink :blink-off :bold :bold-off :conceal :crossed-out :crossed-out-off :doubly
   :doubly-underline :encircled :encircled-off :faint :fraktur :fraktur-off :framed
   :framed-off :hide :invert :invert-off :italic :italic-off :overlined :overlined-off
   :proportional :proportional-off :proportional-spacing :proportional-spacing-off
   :rapid-blink :reset :reveal :reverse :reverse-off :reverse-video :slow-blink
   :spacing :spacing-off :strike :strike-off :subscript :superscript :underline
   :underline-off])

(local colors
  [:black :blue :cyan :green :magenta :red :white :yellow
   :bright-black :gray :bright-blue :bright-cyan :bright-green :bright-magenta
   :bright-red :bright-white :bright-yellow
   :color :gradient])

(local placebo {})

(each [_ key (pairs styles)] (tset placebo key #$1))
(each [_ key (pairs colors)] (tset placebo key #$1))

(let [(success library) (pcall require :supernova)]
  (if success library placebo))
