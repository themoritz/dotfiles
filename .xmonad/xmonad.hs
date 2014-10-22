import XMonad
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.DecorationMadness
import XMonad.Layout.PerWorkspace
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main :: IO ()
main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/mdrexl/.xmobarrc"
    xmonad $ defaultConfig
        { modMask = mod4Mask
        , borderWidth        = 2
        , normalBorderColor  = "#333333"
        , focusedBorderColor = "#cd8b00"
        , manageHook = manageDocks <+> composeAll myManageHook
        , layoutHook = smartBorders $ avoidStruts myLayoutHook
        , startupHook = spawn "~/.xmonad/startup-hook"
        , logHook = dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "orange" "" . shorten 100
                }
        } `additionalKeys` [
            ((mod4Mask .|. shiftMask, xK_l), spawn "slock")
        ]

isKeepass = className =? "KeePass2"

myLayoutHook = onWorkspace "7" imLayout $ basic ||| full
    where
        basic = Tall 1 (3/100) (1/2)
        full = Full
        imLayout = withIM 0.15 skypeRoster Grid
        skypeRoster = Title "the-moritz - Skype™"

myManageHook = [isKeepass --> doCenterFloat]
