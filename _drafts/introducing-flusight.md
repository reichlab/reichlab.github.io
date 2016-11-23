---
title: "Under the hood of our real-time flu predictions"
layout: post
author: Nick
comments: True
---

Because just what the world needs right now is 

<img class="img-responsive" width="600" src="https://reichlab.github.io/images/blog-figs/epivis.png">


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

![](https://reichlab.github.io/images/blog-figs/nidss-data.png)

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

![](https://reichlab.github.io/images/blog-figs/wiki-data.png)

Happy data exploring!

__UPDATE__: (2 Sept 2016) Roni Rosenfeld, the head of the DELPHI group at CMU, pointed out and asked me to mention that David Farrow was the force behind the creation of the epidata API and the epivis tool.
