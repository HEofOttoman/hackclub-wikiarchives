# Hack Club Wiki Archives
(Initially) A disorganised array of resources relating to restarting the Hack Club wiki.
In the future, with ongoing progress, this site will contain a jekyll blog of the archived wiki pages converted to markdown, and some of the configuration for the active mediawiki. This repository contains the following:
1. Archived articles from [the original Unoffical [sic] Hack Club Wiki recovered from the Internet Archive](https://web.archive.org/web/20251014093834/https://hackclub.wiki/), linked, downloaded as a pdf, and manually converted to markdown (with some being downloaded from source) 
2. Website source for an archived meta-site featuring the original content of hackclub.wiki (probably on Jekyll)
3. Configuration files for a running Mediawiki and ad-hoc backups
4. Source code for a Mediawiki-HCA extension

## Sources
The following articles were retrieved from the internet Archive from hackclub.wiki (with a check indicating having been converted to markdown):
- [ ] Welcome (Home Page) at [hackclub.wiki](https://web.archive.org/web/20251014093834/https://hackclub.wiki/) (17 captures, 2 from 2024, rest of 2025)
- [x] [Confessions Article](https://web.archive.org/web/20251031063018mp_/https://hackclub.wiki/en/Confessions) (the latest, from 31 Oct 2025)
- [x] Nest Article
- [ ] [List of Incidents](https://web.archive.org/web/20251104184230/https://hackclub.wiki/en/List_of_Incidents)
    - [x] [2025 Zach Latdroid Incident](https://web.archive.org/web/20251014092407mp_/https://hackclub.wiki/en/2025_Zach_Latdroid_Incident)
    - [ ] [2024 Hack Club Confessions Controversy](https://web.archive.org/web/20251031062843mp_/https://hackclub.wiki/en/2024_Hack_Club_Confessions_Controversy)
    - [x] [Privacy concerns and data handling at Hack Club](https://web.archive.org/web/20251031062848mp_/https://hackclub.wiki/en/Privacy_concerns_and_data_handling_at_Hack_Club) (1 capture)
- [x] [List of YSWS](https://web.archive.org/web/20251011134836mp_/https://hackclub.wiki/en/List_of_You_Ship_We_Ships)
- [x] [List of Hackathons](https://web.archive.org/web/20251102014713mp_/https://hackclub.wiki/en/List_of_Hackathons) (1 capture)
- [x] [List of Community Teams](https://web.archive.org/web/20251022192447mp_/https://hackclub.wiki/en/List_of_Community_Teams) (1 capture)
- [ ] [Confessions](https://web.archive.org/web/20251031063018/https://hackclub.wiki/en/Confessions) (6 captures)

- [sitemap.hackclub.com](https://sitemap.hackclub.com) was known to have existed, but is not on the Internet archive.

### Decisions
- Some of the markdown renditions of the archived articles have been attached with a source link. That might change in the future 
- Events archived in this repository and hence the new wiki might be triggering to some who have forgotten such incidents; they have been archived for posterity's sake 
- The question for restarting the wiki is: Should it be moderated and approved only by HQ, or a community effort? We don't want some Fandom level articles so that will be a thing, an Editors' Code of Conduct will need to be discussed.
- Use permanent CDN images on the wikis to reduce storage. This requires externalImages to be enabled on Mediawiki, which might pose security risks.
- Idea: Category 'meta' for pages relating hack club terminology
- File uploads *should* be disabled.. I checked it for whatever reasone
 
## Tech Stack
- Docker is used to deploy the mediawiki on a personal Oracle VPS
- Jekyll is (probably going to be) used for the archived version of the site

## Credits
This project would not have been possible without the following amazing people: 
- Andrei Jiroh, for having made the original wiki
- The original hackclub.wiki Administrator, for having last edited some of these articles
- Dani Davidson, for having last edited some archived articles
- Those wonderful souls who have decided to archive the wiki, the result only which we would've been able to ban today.
- And definitely, those people who are running the Internet Archive.

![nest](nest88x31.png) This is cool, was archived as a footer.