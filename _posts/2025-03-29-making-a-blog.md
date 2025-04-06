---
layout: post
title: Making a blog site
subtitle: Hello, World!
author: Ilex
header-style: text
tags:
  - web
mathjax: true
---
## Motive
Starting a blog for all the nonsense I get up to is something I have wanted to do for a while. I spend a large chunk of my free time doing an assortment of little programming/computer-y projects that I have been told on several occasions would be quite well suited for blogging.
Despite this, I never had the motivation to put the effort into setting up a website to my liking. But I am doing it now! All thanks to [Tiff](https://qtbigsilly.tumblr.com/) making one and giving me the motivation to create a blog that's way better than hers is.
## Setup process
While I am certainly motivated to make Tiff's blog look like a sad bag of rocks in comparison to mine, I am still a full-time student, meaning I have piss all free time (And I am atrocious at graphic design). So as much as I would have liked to build this whole site from the ground up; I never would have got it done if I did. My compromise was to fork a [Jekyll](https://jekyllrb.com/) theme by [Hynduf's](https://github.com/HynDuf/hynduf.github.io) and customise from there. As of writing this, it is still pretty similar to [Hyndufs blog](https://hynduf.github.io/), once I have more free time I will hopefully make it a little more unique.
That being said, Hyndufs Jekyll theme is honestly brilliant, so I suspect that this will always look somewhat like it.
My process from there was more or less as follows:
### Create a blank-er slate
Remove features of Hyndufs blog that I would not be using:
 - Existing blog posts
 - Most of the README
 - Vietnamese-English translation tab
 - A whole host of socials that I do not use
 
As well as replacing personal info, replace a few graphics, and putting [Tiff](https://qtbigsilly.tumblr.com/) in the *Friends* tab.
### Obsidian integration
As I was using Jekyll, my hope was that I could have a pretty simple workflow for writing posts in [Obsian](https://obsidian.md/). I am not as obsessed with obsidian as a lot of people seem to be, but I use it for my course notes and writing essays, so it wouldn't take any adjusting to get into the flow of writing blog posts in it.
There weren't many issues with this, aside from the fact that when you past images into obsidian (with link format set to *absolute file-path in vault*), you get the following format:
```md
![](DIRECTORY/IMAGE.png)
```
But for the image to render properly in a webpage, I would need there to be a slash at the front:
```html
/DIRECTORY/IMAGE.png
```
My solution was to make a super simple Jekyll plugin that would replace all instances of `DIRECTORY/` with `/DIRECTORY/` (Where in my case "DIRECTORY" is just "assets"):
```rb
module Jekyll  
  class FixImagePaths < Generator  
    safe true  
    def generate(site)  
      site.posts.docs.each do |post|  
        post.content.gsub!(/\]\(assets\//, '](/assets/')  
      end  
    end  endend
```
Aside from me getting the regex wrong around 6 times, this worked first try, which honestly felt like a bad omen.
### LaTeX
I use LaTeX formatting a decent chunk in my notes, and I am expecting to use it in posts here. While the [repo](https://github.com/Huxpro/huxpro.github.io) Hynduf forked from did have some LaTeX support boilerplate, Hynduf did not have it enabled. Having enabled it, I have been having some bizare behaviour that I have yet to be able to fix:
Inline LaTeX works fine: $y^{\prime \prime}-4y'+3y=0 \implies y=C_{1}e^{3x}+C_{2}e^{4x}$. But when I try to use a display equation:

$$
y''-4y'+3y=0 \implies y=C_{1}e^{3x}+C_{2}e^{4x}
$$

Hopefully in future this section will make no sense and will just display properly, but the [time being](/assets/2025-03-29-making-my-blog-20250329151522740.webp) I am leaving it as it is.

### Adding comments
I liked the idea of having a comment section on my page so people could shout abuse at me over the internet. There are a few static site comment services out there ([uterances](https://utteranc.es/), [cactus](https://cactus.chat/), etc), but I settled on [giscus](https://github.com/giscus/giscus). My main issue with giscus (for my purposes) is the requirement of a Github account, as it essentially a window to Github discussion, but given that realistically most of the people reading this blog would be the sort to have a Github account; I decided it a good fit.
LaTeX equations also work properly in the comments, which feels a little taunting.

## Future plans
As mentioned before, I plan on further customising this site, but for now I am probably going to focus on other projects.

I have a short project involving webscraping some data for a research group(~) that I am part of that I did only a couple weeks ago that I may write up as a blog post as it was honestly quite interesting (if a little niche).

Hopefully I will remain motivated. 

We shall see.
