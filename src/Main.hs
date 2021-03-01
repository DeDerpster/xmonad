---------------------------------
---          IMPORTS          ---
---------------------------------

import           Control.Monad                  ( forM_ )
  -- Base
import           XMonad                         ( (-->)
                                                , (<+>)
                                                , Default(def)
                                                , XConfig
                                                  ( borderWidth
                                                  , focusedBorderColor
                                                  , handleEventHook
                                                  , layoutHook
                                                  , logHook
                                                  , manageHook
                                                  , modMask
                                                  , normalBorderColor
                                                  , startupHook
                                                  , terminal
                                                  , workspaces
                                                  )
                                                , io
                                                , xmonad
                                                )
import           XMonad.Hooks.EwmhDesktops      ( ewmh )
import           XMonad.Hooks.ManageDocks       ( docksEventHook
                                                , manageDocks
                                                )
import           XMonad.Hooks.ManageHelpers     ( doFullFloat
                                                , isFullscreen
                                                )
import           XMonad.Hooks.ServerMode        ( serverModeEventHook
                                                , serverModeEventHookCmd
                                                , serverModeEventHookF
                                                )
import           XMonad.Layout.Fullscreen       ( fullscreenSupport )
import           XMonad.Util.EZConfig           ( additionalKeysP )
import           XMonad.Util.Run                ( safeSpawn )

import           Hooks                          ( eventLogHookForPolyBar
                                                , myManagementHook
                                                , myStartupHook
                                                )
import           Keys                           ( myKeys )
import           Layouts                        ( myLayoutHook )
import           Settings                       ( myBorderWidth
                                                , myFocusColour
                                                , myModMask
                                                , myNormColour
                                                , myTerminal
                                                , myWorkspaces
                                                )

main :: IO ()
main = do
  forM_ [".xmonad-workspace-log", ".xmonad-title-log"]
    $ \file -> safeSpawn "mkfifo" ["/tmp/" ++ file]
  xmonad
    $                 fullscreenSupport
    $                 ewmh def
                        { manageHook         = (isFullscreen --> doFullFloat)
                                               <+> myManagementHook
                                               <+> manageDocks
                        , handleEventHook    = serverModeEventHookCmd
                                               <+> serverModeEventHook
                                               <+> serverModeEventHookF "XMONAD_PRINT"
                                                                        (io . putStrLn)
                                               <+> docksEventHook
                        , modMask            = myModMask
                        , terminal           = myTerminal
                        , startupHook        = myStartupHook
                        , layoutHook         = myLayoutHook
                        , workspaces         = myWorkspaces
                        , borderWidth        = myBorderWidth
                        , normalBorderColor  = myNormColour
                        , focusedBorderColor = myFocusColour
                        , logHook            = eventLogHookForPolyBar
                        }
    `additionalKeysP` myKeys
