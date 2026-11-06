
-- Module:DynamicYSWSList
-- Public Hack Club YSWS directory
-- Data source: https://hackclub.com/api/v1/events
--
-- Generates a sortable MediaWiki table.
-- Search and status updates are handled by personal JS or a gadget.

local p = {}

local API_URL = 'https://hackclub.com/api/v1/events'

local MONTHS = {
    'January', 'February', 'March',
    'April', 'May', 'June',
    'July', 'August', 'September',
    'October', 'November', 'December'
}

-- ============================================================
-- Utility functions
-- ============================================================

local function str(value)
    if value == nil then
        return ''
    end

    if type(value) ~= 'string'
        and type(value) ~= 'number' then
        return ''
    end

    return mw.text.trim(tostring(value))
end

local function firstNonEmpty(...)
    for i = 1, select('#', ...) do
        local value = str(select(i, ...))

        if value ~= '' then
            return value
        end
    end

    return ''
end

-- Add literal text safely to an mw.html element.
-- External data must not be interpreted as wiki markup.
local function addText(element, value)
    element:wikitext(
        mw.text.nowiki(tostring(value or ''))
    )

    return element
end

local function validUrl(url)
    url = str(url)

    if url:match('^https?://[^%s<>"\']+$') then
        return url
    end

    return nil
end

-- ============================================================
-- Date handling
-- ============================================================

local function normalizeDate(value)
    value = str(value)

    -- Supports ISO dates and ISO timestamps.
    local year, month, day =
        value:match('^(%d%d%d%d)%-(%d%d)%-(%d%d)')

    if not year then
        return nil
    end

    year = tonumber(year)
    month = tonumber(month)
    day = tonumber(day)

    if not year or not month or not day then
        return nil
    end

    if month < 1 or month > 12 then
        return nil
    end

    local days = {
        31, 28, 31, 30, 31, 30,
        31, 31, 30, 31, 30, 31
    }

    local leap =
        year % 4 == 0 and
        (year % 100 ~= 0 or year % 400 == 0)

    if leap then
        days[2] = 29
    end

    if day < 1 or day > days[month] then
        return nil
    end

    return string.format(
        '%04d-%02d-%02d',
        year,
        month,
        day
    )
end

local function displayDate(iso)
    if not iso then
        return '—'
    end

    local year, month, day =
        iso:match('^(%d%d%d%d)%-(%d%d)%-(%d%d)$')

    if not year then
        return '—'
    end

    return string.format(
        '%d %s %s',
        tonumber(day),
        MONTHS[tonumber(month)],
        year
    )
end

-- ============================================================
-- Public API
-- ============================================================

local function fetchPrograms()
    if not mw.ext or not mw.ext.externalData then
        return nil, 'External Data extension is unavailable.'
    end

    local externalData = mw.ext.externalData

    if type(externalData.getExternalData) ~= 'function' then
        return nil, 'External Data Lua interface is unavailable.'
    end

    local ok, data = pcall(
        externalData.getExternalData,
        {
            url = API_URL,
            format = 'json with jsonpath',
            data = {
                name = '$.data[*].name',
                description = '$.data[*].description',
                url = '$.data[*].url',
                startDate = '$.data[*].startDate',
                endDate = '$.data[*].endDate'
            }
        }
    )

    if not ok then
        return nil, 'Unable to retrieve the public event feed.'
    end

    if type(data) ~= 'table' or next(data) == nil then
        return nil, 'The public event feed returned no data.'
    end

    return data
end

-- ============================================================
-- Program normalization
-- ============================================================

local function cleanDescription(value)
    local description = str(value)

    if description == '' then
        return ''
    end

    -- Remove HTML markup from descriptions.
    description = description:gsub('<[^>]*>', '')

    -- Decode common HTML entities.
    description = mw.text.decode(description)

    -- Collapse whitespace.
    description = description:gsub('%s+', ' ')
    description = mw.text.trim(description)

    -- Keep table cells reasonably compact.
    if mw.ustring.len(description) > 240 then
        description =
            mw.ustring.sub(description, 1, 237) .. '…'
    end

    return description
end

local function normalizePrograms(data)
    local programs = {}

    -- External Data may return an array of rows.
    for _, row in ipairs(data) do
        if type(row) == 'table' then
            local name = firstNonEmpty(
                row.name,
                row.title
            )

            if name ~= '' then
                local startDate = normalizeDate(
                    firstNonEmpty(
                        row.startDate,
                        row.start_date,
                        row.start
                    )
                )

                local endDate = normalizeDate(
                    firstNonEmpty(
                        row.endDate,
                        row.end_date,
                        row['end']
                    )
                )

                local description = cleanDescription(
                    firstNonEmpty(
                        row.description,
                        row.summary
                    )
                )

                local url = validUrl(
                    firstNonEmpty(
                        row.url,
                        row.website,
                        row.link
                    )
                )

                programs[#programs + 1] = {
                    name = name,
                    description = description,
                    startDate = startDate,
                    endDate = endDate,
                    url = url
                }
            end
        end
    end

    table.sort(programs, function(a, b)
        local aName = mw.ustring.lower(a.name)
        local bName = mw.ustring.lower(b.name)

        return aName < bName
    end)

    return programs
end

-- ============================================================
-- HTML helpers
-- ============================================================

local function addDateCell(row, date, className)
    local cell = row:tag('td')
        :addClass(className)
        :attr(
            'data-sort-value',
            date or '9999-12-31'
        )

    if date then
        addText(
            cell:tag('time')
                :attr('datetime', date),
            displayDate(date)
        )
    else
        addText(cell, '—')
    end

    return cell
end

local function addHeader(row, heading)
    return addText(
        row:tag('th')
            :attr('scope', 'col'),
        heading
    )
end

local function addProgramRow(tbody, program)
    local row = tbody:tag('tr')
        :addClass('ysws-program')
        :attr('data-start', program.startDate or '')
        :attr('data-end', program.endDate or '')

    -- Program name
    addText(
        row:tag('th')
            :attr('scope', 'row')
            :addClass('ysws-name'),
        program.name
    )

    -- Description
    addText(
        row:tag('td')
            :addClass('ysws-description'),
        program.description ~= ''
            and program.description
            or '—'
    )

    -- Start date
    addDateCell(
        row,
        program.startDate,
        'ysws-start'
    )

    -- End date
    addDateCell(
        row,
        program.endDate,
        'ysws-end'
    )

    -- Status is calculated by client-side JavaScript.
    addText(
        row:tag('td')
            :addClass('ysws-status'),
        'Unknown'
    )

    -- Website
    local websiteCell = row:tag('td')
        :addClass('ysws-website')

    if program.url then
        addText(
            websiteCell:tag('a')
                :attr('href', program.url)
                :attr('rel', 'noopener noreferrer'),
            'Website'
        )
    else
        addText(websiteCell, '—')
    end

    return row
end

-- ============================================================
-- Directory renderer
-- ============================================================

local function renderTable(programs)
    local root = mw.html.create('div')
        :addClass('ysws-directory')

    -- Entry count
    addText(
        root:tag('p')
            :addClass('ysws-directory-count'),
        string.format(
            '%d public event entries listed.',
            #programs
        )
    )

    -- Search controls
    local controls = root:tag('div')
        :addClass('ysws-controls')

    addText(
        controls:tag('label')
            :attr('for', 'ysws-search'),
        'Search programs'
    )

    controls:tag('input')
        :attr('id', 'ysws-search')
        :attr('type', 'search')
        :attr(
            'placeholder',
            'Search name or description'
        )
        :attr('autocomplete', 'off')
        :attr('aria-controls', 'ysws-table')

    controls:tag('p')
        :addClass('ysws-results')
        :attr('role', 'status')
        :attr('aria-live', 'polite')

    -- Table wrapper
    local wrapper = root:tag('div')
        :addClass('ysws-table-wrapper')

    local tbl = wrapper:tag('table')
        :attr('id', 'ysws-table')
        :addClass('wikitable')
        :addClass('sortable')
        :addClass('ysws-table')

    -- Table headings
    local header = tbl:tag('thead'):tag('tr')

    addHeader(header, 'Program')
    addHeader(header, 'Description')
    addHeader(header, 'Start date')
    addHeader(header, 'End date')
    addHeader(header, 'Status')
    addHeader(header, 'Website')

    -- Table body
    local tbody = tbl:tag('tbody')

    for _, program in ipairs(programs) do
        addProgramRow(tbody, program)
    end

    -- Empty search result message
    local empty = root:tag('p')
        :addClass('ysws-empty')
        :attr('hidden', 'hidden')

    addText(
        empty,
        'No programs match your search.'
    )

    -- Source information
    addText(
        root:tag('p')
            :addClass('ysws-source-note'),
        'Generated from the public Hack Club events API. '
            .. 'Dates and descriptions reflect the public feed.'
    )

    return tostring(root)
end

-- ============================================================
-- Public entry point
-- ============================================================

function p.main(frame)
    local data, err = fetchPrograms()

    if not data then
        return tostring(
            mw.html.create('p')
                :addClass('error')
                :wikitext(
                    mw.text.nowiki(
                        err or 'Unable to load programs.'
                    )
                )
        )
    end

    local programs = normalizePrograms(data)

    if #programs == 0 then
        return tostring(
            mw.html.create('p')
                :addClass('error')
                :wikitext(
                    'No public programs were returned.'
                )
        )
    end

    return renderTable(programs)
end

return p