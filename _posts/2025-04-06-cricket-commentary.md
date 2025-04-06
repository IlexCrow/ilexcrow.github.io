---
layout: post
title: Automatically sourcing cricket commentary from Cricinfo with NodeJS
subtitle: 
author: Ilex
header-style: text
tags:
  - cricket
  - webscraping
mathjax: true
github-link: https://github.com/IlexCrow/cricinfo-api
---
(Full disclosure: I know very little about cricket, so that terminology usage may be nonsense)
## Context
As mentioned in my previous post; I am part of a 'research' group (I hesitate to give it that grandeur) that is looking at analysing movement of cricket balls at different pitches. For this project, there was want for the ability to quickly source the commentary about a specific bowl from a website such as [Cricinfo](www.espncricinfo.com), but as Cricinfo has no documented API that I could find, I had to work out how get data by a combination of dev tools and (a lot of) trial and error.
## Working out fetch process
### Analysing network activity
This section will be done using [a game](https://www.espncricinfo.com/series/hkg-pl-t20-tournament-2024-25-1474232/united-services-recreation-club-vs-pakistan-association-of-hong-kong-7th-match-1474240/ball-by-ball-commentary) I picked more or less at random.
I knew I was probably looking for a fetch request for something along the line of "commentary/comments/comment" (etc), so I ran these filters in the dev-tools network analyser while scrolling through the [commentary section](https://www.espncricinfo.com/series/hkg-pl-t20-tournament-2024-25-1474232/united-services-recreation-club-vs-pakistan-association-of-hong-kong-7th-match-1474240/ball-by-ball-commentary) of the page:
![](assets/2025-04-06-cricket-commentary-20250406133816528.webp)
![](assets/2025-04-06-cricket-commentary-20250406133917396.webp)
And as expected: There were some requests for commentary data (among-side rather a few ads).
The request URL was in the following format:

`hs-consumer-api.espncricinfo.com/v1/pages/match/comments?lang=en&seriesId=#######&matchId=#######&inningNumber=#&commentType=ALL&sortDirection=ASC&fromInningOver=##`
Where the seriesId and matchId are the same as the match and series ID for the main page:
![](assets/2025-04-06-cricket-commentary-20250406134818298.webp)
"inningNumber" is the inning.
"FromInningOver" just refers to which chunk of commentary to grab from (Also effected by the sortDirection). 
### Attempting to reproduce with cURL
In trying to use cURL to reproduce this fetch request, I was able to access the same json data, but only for around $30$seconds before the request started returning an error.
A little bit of experimenting showed this time dependence to be based on the `X-Hsci-Auth-Token` request header:
![](assets/2025-04-06-cricket-commentary-20250406134452060.webp)
Looking around in *initiator* JS file, I found a function called `_generateToken` which contained the following lines (Rewritten to be a little more readable):
```js
s.push("exp=" + o); // Add the first chunk of Token with Unix timestamp of packet send time

var c = i.createHmac(this.options.algorithm, new r(this.options.key,"hex")); // Generate hash with  sha256
// a = ["exp=UNIX-TIME","url=ESCAPED-URL"]
return c.update(a.join("~")),
	s.push("hmac=" + c.digest("hex")),
	s.join("~")
```
Which ends up with `s` being the Token string. `this.options` can be found with dev-tools via a break-point.
## [Reproducing with Node](https://github.com/IlexCrow/cricinfo-api)
This can be reproduced with nodeJS, which I have done [here](https://github.com/IlexCrow/cricinfo-api/blob/main/index.js#L36). 
In this script I have also added some nice display code (Aside from the lack of line-wrapping):
![](/assets/2025-04-06-cricket-commentary-20250406145242780.webp)
On the Cricinfo website for comparison:
![](/assets/2025-04-06-cricket-commentary-20250406145317858.webp)

This is more or less as much as the research group needed so I left it at that. But if anyone else happens to be doing the extremely obscure task of scraping cricinfo, hopefully this will give them a head-start.