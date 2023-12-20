
RegisterNetEvent("police:areprintsonfile", function(cid)
    local src = source
    -- checks to see if character exists period, not just from active characters table
    local char = exports["oxmysql"]:executeSync("SELECT * FROM _fivem_characters WHERE id = ?", {cid})[1]
    if char then
        -- selects table from jail by cid
        local query = exports["oxmysql"]:executeSync("SELECT * FROM _fivem_jail WHERE cid = ?", {cid})

        if not ActiveTable(query) then
            -- no table exists, insert table and return stored message to db
            exports["oxmysql"]:executeSync("INSERT INTO _fivem_jail (cid, fingerprint) VALUES (?, 1) ", {cid})
            TriggerNetEvent("chatMessage", src, "Fingerprints", 3, 'Unforunately those prints didn\'t get a hit in the database. We\'ll keep them on file once they\'re jailed and have them for the future.')
        else
            if query[1].fingerprint then
            -- fingerprint is set to boolean 1 aka true
                if not query[1].jail_time then
                    -- Fingerprints taken but not jailed -- TODO is this necessary? if they have the fingerprints from swapping the person it should just return the name
                    TriggerNetEvent("chatMessage", src, "Fingerprints", 3, 'Looks like we already have a copy of those prints. Once the individual is sent to jail we will be able to use the prints to ID them in the future.')
                else
                    -- Fingerprints were found on file and the person has been jailed, return full name
                    TriggerNetEvent("chatMessage", src, "Fingerprints", 2, 'Those prints came back a match to: ' .. char.first_name .. ' ' .. char.last_name .. '.')
                end
            else
                -- fingerprint is set to boolean 0 aka false
                -- Not on file -> update to fingerprints run
                exports["oxmysql"]:executeSync("UPDATE _fivem_jail SET fingerprint = 1 WHERE cid = ?", {cid})
                TriggerNetEvent("chatMessage", src, "Fingerprints", 3, 'Unforunately those prints didn\'t get a hit in the database. We\'ll keep them on file once they\'re jailed and have them for the future.')
            end
        end
    end

    -- destroy item -- TODO maybe send destroy by slot so it destroys the right item, but in client it doesn't let u run multiples so probably will never be needed
    RPC.Execute('inventory:removeItem', src, 'fingerprint_card', 1)
end)