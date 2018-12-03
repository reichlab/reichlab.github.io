---
title: Forecast Framework Demo
layout: post
author: Katie
comments: True
---

Want to learn how to forecast with R? Here's your chance to try out a straight-forward and robust library!

The Reich Lab uses a R package called ForecastFramework to implement forecasting models. There are many benefits to using ForecastFramework in a forecasting pipeline, including: standardized and simplified rapid model development and performance evaluation. ForecastFramework was created by Joshua Kaminsky of the Infectious Disease Dynamics Group at Johns Hopkins University. The package is open source and can be found [on Github](https://github.com/HopkinsIDD/ForecastFramework).

The graduate programmer at the Reich Lab, Katie House, created a step-by-step demonstration of the use cases of ForecastFramework. This demo lives at [reichlab.io/forecast-framework-demos/](http://reichlab.io/forecast-framework-demos/). 

<a href="https://reichlab.github.io/flusight/">
    <img class="img-responsive" width="700" src="/images/blog/ff-demo.PNG">
</a>

<!--more-->

The purpose of these demonstrations is to make ForecastFramework accessible. However, these demonstrations only touch the surface as to the ennumerous uses of ForecastFramework. In fact, ForecastFramework is Reich Lab's primary library for generating our real-time dengue forecasts for the Ministry of Public Health in Thailand.

The demo is separated into five sections. Each section will build off knowledge from the previous and will gradually increase in difficulty. However, the demos work as standalone scripts as well. The demos are categorized as the following:
1. **The Data** - This section will examine the raw data used in the ForecastFramework models ahead.
2. **Defining Inputs** - This section will define what an Incidence Matrix is, show how to format your data to be used as an Incidence Matrix, and exemplify functions of Incidence Matrices.
3. **Fitting and Forecasting** - This section will focus on fitting data to a SARIMA model with ForecastFramework.
4. **Evaluating Complex Models** - This section will demonstrate evaluation metrics and techniques by comparing two complex models in ForecastFramework.
5. **Creating your own Model** - This section will use object-oriented R programming demonstrate how to create your own model with ForecastFramework. 

[Try using ForecastFramework today](http://reichlab.io/forecast-framework-demos/)! For any questions or bug reporting, please contact khouse@umass.edu.

