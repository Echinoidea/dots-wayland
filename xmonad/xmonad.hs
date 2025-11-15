import XMonad
import XMonad.Util.EZConfig (additionalKeysP, removeKeysP)
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Tabbed
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.SpawnOnce
import XMonad.Layout.Spacing
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Loggers
import XMonad.Actions.CycleWS
import XMonad.Layout.NoBorders

myWorkspaces = ["term", "www", "emacs", "disc", "5", "6", "7", "8", "9"]

myLayout = spacingWithEdge 10 $ tiled ||| Mirror tiled ||| Full ||| noBorders simpleTabbed ||| threeCol
  where
    threeCol = ThreeColMid nmaster delta ratio
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1/2
    delta = 3/100

main :: IO ()
main = xmonad 
     . ewmhFullscreen 
     . ewmh 
     . withEasySB (statusBarProp "xmobar -x 0 ~/.config/xmobar/xmobar.hs" (pure myXmobarPP)) defToggleStrutsKey
     . withEasySB (statusBarProp "xmobar -x 1 ~/.config/xmobar/xmobar.hs" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = " | "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = xmobarColor "#81a2be" "" . wrap "[" "]"
    , ppHidden          = xmobarColor "#b5bd68" ""
    , ppHiddenNoWindows = xmobarColor "#707880" ""
    , ppUrgent          = xmobarColor "#cc6666" "" . wrap "!" "!"
    , ppOrder           = \(ws:_:_:_) -> [ws]
    , ppExtras          = []
    }

myConfig = def
  { modMask = mod4Mask
  , layoutHook = myLayout  -- Changed from layoutHooks
  , startupHook = myStartupHook
  , terminal = "alacritty"
  , workspaces = myWorkspaces
  }
  `removeKeysP`
  [ "M-S-c"
  , "M-e" -- focus monitor2
  , "M-r" -- focus monitor3?
  ]
  `additionalKeysP`
    [
    ("M-<Return>", spawn "alacritty")
    , ("M-w", kill)
    , ("M-C-l", nextScreen)
    , ("M-C-h", prevScreen)
    ]
myStartupHook :: X ()
myStartupHook = do
  spawnOnce "feh --bg-fill --no-fehbg ~/Pictures/wallpapers/nix.png"
  spawnOnce "picom"
