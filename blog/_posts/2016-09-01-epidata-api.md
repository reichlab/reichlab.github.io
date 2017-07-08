---
title: "Using the DELPHI API to access infectious disease data"
layout: post
author: Nick
comments: True
---

This week I attended a workshop at the CDC about last year's [FluSight challenge](https://predict.phiresearchlab.org/flu/index.html), a competition that scores weekly real-time predictions about the course of the influenza season. They are planning another round this year and are hoping to increase the number of teams particiating. Stay tuned to [this site](https://predict.phiresearchlab.org/flu/index.html) for more info.

At the workshop, I learned about [DELPHI's](http://delphi.midas.cs.cmu.edu/) real-time epidemiological [data API](https://github.com/undefx/delphi-epidata). The API is linked to various data sources on influenza and dengue, including US CDC flu data, Google Flu Trends, and Wikipedia data. There is [some documentation](https://github.com/undefx/delphi-epidata#the-api) and [minimal examples](https://github.com/undefx/delphi-epidata#code-samples), and this post documents a more robust and complete example for using the API via R. I'll note that the CDC's influenza data, can also be accessed via the `cdcfluview` R package, which I'm not going to discuss here and I will focus here on accessing some of the other data sources. Here's a teaser of this data that you can also interactively explore on the [DELPHI EpiVis website](http://delphi.midas.cs.cmu.edu/epivis/epivis.html):
<img class="img-responsive" width="600" src="/images/blog/epivis.png">



<!--more-->


Setup
-----

Let's start by loading the R script containing the relevant methods needed to access the API.

``` r
source("https://raw.githubusercontent.com/undefx/delphi-epidata/master/code/delphi_epidata.R")
```

Then, load in two packages that we will use to tidy and plot the data.

``` r
library(MMWRweek)
library(ggplot2)
```

Dengue data from Taiwan CDC
---------------------------

Here is some code that pulls data from [Taiwan's NIDSS](http://nidss.cdc.gov.tw/en/), specifically asking for nationwide data, and data from the central region. A complete list of [regions](https://github.com/undefx/delphi-epidata/blob/master/labels/nidss_regions.txt) and [locations](https://github.com/undefx/delphi-epidata/blob/master/labels/nidss_locations.txt) are available. Also, I've specified a range of weeks from the first week of 2010 (`201001`) to the last week of 2016 (`201653`).

``` r
res <- Epidata$nidss.dengue(locations = list('nationwide', 'central'), 
                            epiweeks = list(Epidata$range(201001, 201653)))
```

The above command should pull data down into your current session, but it will be a little bit 'list-y', so here is some code I wrote to clean it up and make it a bit more of a workable dataset in R.

``` r
df <- data.frame(matrix(unlist(res$epidata), nrow=length(res$epidata), byrow=T))
colnames(df) <- names(res$epidata[[1]])[!is.null(res$epidata[[1]])]
df$count <- as.numeric(as.character(df$count))
df$year <- as.numeric(substr(df$epiweek, 0, 4))
df$week <- as.numeric(substr(df$epiweek, 5, 6))
df$date <- MMWRweek2Date(MMWRyear = df$year, MMWRweek = df$week)
```

Note the use of the `MMWRweek2Date()` function that gives us a date column in our data frame. And here is a plot of the resulting data. 

``` r
ggplot(df, aes(x=date, y=count, color=location)) + geom_point() + scale_y_log10()
```

![](/images/blog/nidss-data.png)

Wikipedia data
--------------

Let's try loading some of the Wikipedia data on influenza and other related terms. The article. I think this reflects the number of hits on pages of certain articles, although I'm not sure.

``` r
res <- Epidata$wiki(articles=list("influenza", "common_cold", "cough"),
                    epiweeks=list(Epidata$range(201101, 201553)))
df <- data.frame(matrix(unlist(res$epidata), nrow=length(res$epidata), byrow=T))
colnames(df) <- names(res$epidata[[1]])[!is.null(res$epidata[[1]])]
df$count <- as.numeric(as.character(df$count))
df$year <- as.numeric(substr(df$epiweek, 0, 4))
df$week <- as.numeric(substr(df$epiweek, 5, 6))
df$date <- MMWRweek2Date(MMWRyear = df$year, MMWRweek = df$week)
ggplot(df, aes(x=date, y=count, color=article)) + 
  geom_point() + 
  geom_smooth(span=.1, se=FALSE)
```

![](/images/blog/wiki-data.png)

Happy data exploring!

__UPDATE__: (2 Sept 2016) Roni Rosenfeld, the head of the DELPHI group at CMU, pointed out and asked me to mention that David Farrow was the force behind the creation of the epidata API and the epivis tool.
