tell application "Tunnelblick"
    connect "raj"
    get state of first configuration where name = "raj"
    repeat until result = "CONNECTED"
        delay 1
        get state of first configuration where name = "raj"
    end repeat
end tell