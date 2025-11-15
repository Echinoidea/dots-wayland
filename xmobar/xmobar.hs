Config { 
   -- appearance
     font = "xft:AporeticSerifMonoNerdFont:size=10:antialias=true"
   , additionalFonts = []
   , bgColor = "#1c1c1c"
   , fgColor = "#d0d0d0"
   , position = Top
   , border = BottomB
   , borderColor = "#3a3a3a"

   -- layout
   , sepChar = "%"
   , alignSep = "}{"
   , template = " %UnsafeStdinReader% }{ %cpu% | %memory% | %disku% | %battery% | %wlan0wi% | %date% "

   -- general behavior
   , lowerOnStart = True
   , hideOnStart = False
   , allDesktops = True
   , overrideRedirect = True
   , pickBroadest = False
   , persistent = True

   -- plugins
   , commands = 
        [ Run UnsafeStdinReader
        
        , Run Cpu 
            [ "--template" , "CPU: <total>%"
            , "--Low"      , "30"
            , "--High"     , "70"
            , "--low"      , "#55aa55"
            , "--normal"   , "#f0c674"
            , "--high"     , "#cc6666"
            ] 10
        
        , Run Memory 
            [ "--template" , "MEM: <usedratio>%"
            , "--Low"      , "30"
            , "--High"     , "70"
            , "--low"      , "#55aa55"
            , "--normal"   , "#f0c674"
            , "--high"     , "#cc6666"
            ] 10
        
        , Run DiskU 
            [("/", "DISK: <free>")]
            [ "--Low"      , "20"
            , "--High"     , "80"
            , "--low"      , "#cc6666"
            , "--normal"   , "#f0c674"
            , "--high"     , "#55aa55"
            ] 50
        
        , Run Battery
            [ "--template" , "BAT: <acstatus>"
            , "--Low"      , "20"
            , "--High"     , "80"
            , "--low"      , "#cc6666"
            , "--normal"   , "#f0c674"
            , "--high"     , "#55aa55"
            , "--"
            , "-o" , "<left>% (<timeleft>)"  -- discharging
            , "-O" , "<left>% (charging)"    -- AC on, charging
            , "-i" , "<left>% (full)"        -- AC on, charged
            ] 50
        
        , Run Wireless "wlan0"
            [ "--template" , "WIFI: <essid> <quality>%"
            , "--Low"      , "30"
            , "--High"     , "70"
            , "--low"      , "#cc6666"
            , "--normal"   , "#f0c674"
            , "--high"     , "#55aa55"
            ] 10
        
        , Run Date "%a %Y-%m-%d %H:%M:%S" "date" 10
        ]
   }
