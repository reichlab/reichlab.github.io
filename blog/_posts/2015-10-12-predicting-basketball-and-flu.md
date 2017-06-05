---
title: "Strange bedfellows: methods for predicting the NBA and flu"
layout: post
author: Nick
comments: True
---

FiveThirtyEight's new [CARMELO prediction alorithm, that projects the future careers of every NBA player](http://fivethirtyeight.com/features/how-were-predicting-nba-player-career/), has similarity with prediction methods in other fields.

<!--more-->

I read up this morning on [CARMELO](http://fivethirtyeight.com/features/how-were-predicting-nba-player-career/), the latest stats-backed tool to come out of Nate Silver's shop at FiveThirtyEight. They clearly have down the formla for putting together real quantitative predictions with a glossy front end delivery. [It looks slick!](http://projects.fivethirtyeight.com/carmelo/) As they point out, CARMELO is based on [PECOTA, a similar system for predicting baseball player careers](https://en.wikipedia.org/wiki/PECOTA), which was Nate's first big modeling breakthrough back in the early-mid 2000s. 

What struck me reading through this today was how similar it is to what is known as "the method of analogues" in at least the [meterological](http://ww2010.atmos.uiuc.edu/(Gh)/guides/mtr/fcst/mth/oth.rxml) and [infectious disease](http://www.ncbi.nlm.nih.gov/pubmed/14607808) forecasting communities. The shared idea in these prediction methods is that you find "similar" observations to the one that you are trying to predict in your existing dataset. Then, look at those similar observations, see what they did in the future and use them to come up with some intelligent guess about what your observation of interest will do. (Hint: it tends to be something like a weighted mean of the observed trajectories of the similar datapoints.)

Evan Ray and Krzysztof Sakrejda, post-docs in the [Reich Lab](http://reichlab.github.io), put together a new formulation of the method of analogues for a submission to the [White House Dengue Prediction Challenge](http://predict.phiresearchlab.org/dengue/index.html) this past summer, for predicting outbreaks of dengue fever in Puerto Rico and Peru. Their submission method wasn't in the top three performers, but it wasn't too shabby either, and there were a few small tweaks and fixes that they are working on to see if that might improve performance. (The complete story will be the topic of a future blog post.) Their method (still a work in progress) including code, as well as brief and detailed write-ups can be found on [GitHub](https://github.com/reichlab/dengue-ssr-prediction/).

I find it interesting to see the similarities of some of these methods from disparate fields. Please comment if you know or recognize these prediction methods from yet other contexts. 

I'll be curious to see (and hope the folks at FiveThirtyEight put together, in 8 months) some honest evaluations of these early drafts of CARMELO. At the end of this season, for example, what will the actual CARMELO prediction interval coverages be? How much more/less accurate will the  point predictions for a player's WAR be comparing CARMELO to a simple model? (Possible simple model: a player's WAR from last year or the average WAR of players with a given number of years' experience.) These questions get at a common theme of a lot of our research lately: how can you tell that a prediction is adding value? Turns out, this is a tougher question to answer than it appears. 