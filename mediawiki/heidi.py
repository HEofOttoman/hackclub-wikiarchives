# pywikibot
import pywikibot

## ==user-config.py==
family = 'hackclubwiki'
mylang = 'en'
usernames['hackclubwiki']['en'] = "Heidi Engine"

## Will do things like update page or something or automatically make pages from slack channels? Or an extension of that ysws list

## The ListOfYSWS module is a template that cannot update automaticallly without an edit trigger. This will run an edit every so often to update it.

site = pywikibot.Page('en', 'hackclubwiki')
page = pywikibot.Page(site, 'List_Of_YSWS')

## apparently something called touch for this exists.
# python pwb.py touch -page:"List_Of_YSWS"