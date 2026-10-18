local p = {}

function p.fetchlist(frame)
    -- local args = frame:getParent().args
    local sourceUrl = "https://hackclub.com/api/v1/events/rss"
    local dataMap = "name=name, description=description, link=link, date=pubDate, page=[[name]]"

    local data = mw.ext.externalData.getExternalData{
        url = sourceUrl,
        format = 'xml',
        data = dataMap
    }

    if not data or #data == 0 then
        return <span class="error">Error fetch failed</span
    end

    local output = {}
    table.insert(output, "=== All Hack Club Events ===")

    for i, row in ipairs(data) do
        local name = row.name or "Missingname"
        local description = row.description or "Missing desc"
        local link = row.link or "Missing link"
        local date = row.date or "Missing date"

    end
    
end

return p
