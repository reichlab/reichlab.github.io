---
title: Forecast Framework Demo
layout: post
author: Katie
comments: True
---

Want to learn how to do some forecasting with R? Here's your chance to try out a new time-series forecasting package for R whose aim is to standardize and simplify the process of making and evaluating forecasts!

The [Reich Lab](http://reichlab.io/) uses an R package called `ForecastFramework` to implement forecasting models. There are many benefits to using `ForecastFramework` in a forecasting pipeline, including: standardized and simplified rapid model development and performance evaluation. `ForecastFramework` was created by Joshua Kaminsky of the [Infectious Disease Dynamics Group at Johns Hopkins University](http://www.iddynamics.jhsph.edu/). The package is open source and can be found [on Github](https://github.com/HopkinsIDD/ForecastFramework).

After watching students in the lab working on learning how to use `ForecastFramework`, I decided to create a step-by-step demonstration of the primary use cases of `ForecastFramework`. The complete demo lives at [reichlab.io/forecast-framework-demos/](http://reichlab.io/forecast-framework-demos/). 

<a href="https://reichlab.github.io/flusight/">
    <img class="img-responsive" width="700" src="/images/blog/ff-demo.PNG">
</a>

<!--more-->

As the resident CS grad-student programmer in the lab, I wanted to write these demonstrations to make `ForecastFramework` accessible. However, the demo only scrape the surface of the many way that we (and others, we hope) will use  `ForecastFramework`. We have incorporated `ForecastFramework` into our workflow for generating [real-time dengue forecasts for the Ministry of Public Health in Thailand](https://journals.plos.org/plosntds/article?id=10.1371/journal.pntd.0004761), and students have found it really useful in generating small model comparison projects.

[The online demo](http://reichlab.io/forecast-framework-demos/) is separated into five sections. Each section will build off knowledge from the previous and will gradually increase in difficulty. However, the demos work as standalone scripts as well. The demos are categorized as the following:
1. [**The Data**](http://reichlab.io/forecast-framework-demos/#the-data-1) - This section will examine the raw data used in the `ForecastFramework` models ahead.
2. [**Defining Inputs**](http://reichlab.io/forecast-framework-demos/#defining-inputs-incidence-matrix-1) - This section will define what an `IncidenceMatrix` is, show how to format your data to be used as an `IncidenceMatrix`, and exemplify functions of the `IncidenceMatrix` class.
3. [**Fitting and Forecasting**](http://reichlab.io/forecast-framework-demos/#fitting-and-forecasting) - This section will focus on fitting data to a SARIMA model with `ForecastFramework`, using the [`sarimaTD` package](https://github.com/reichlab/sarimaTD) developed by [Evan Ray](http://www.mtholyoke.edu/~eray/).
4. [**Evaluating Complex Models**](http://reichlab.io/forecast-framework-demos/#evaluating-multiple-models) - This section will demonstrate evaluation metrics and techniques by comparing two complex models in `ForecastFramework`.
5. [**Creating your own Model**](http://reichlab.io/forecast-framework-demos/#creating-your-own-model) - This section will use object-oriented R programming demonstrate how to create your own model with `ForecastFramework`. 

[Try using `ForecastFramework` today](http://reichlab.io/forecast-framework-demos/)! I hope you find the tutorials interesting and instructive. If you have any questions or find any bugs, please let me know! I can be found at khouse [at] umass.edu or through [my personal website](http://katie-house.com/).

