---
title: "Under the hood of our real-time flu predictions"
layout: post
author: Nick
comments: True
---

For the second year in a row, the Reich Lab is participating in the [CDC FluSight challenge](https://predict.phiresearchlab.org/post/57f3f440123b0f563ece2576), a project where teams from around the country submit real-time predictions of influenza to the CDC. The teams use a variety of different models and methods to generate these predictions, from [an empirical Bayes method that uses Google search data](http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004382) to [a extended Kalman-filter method that uses humidity data](http://www.nature.com/articles/ncomms3837) to [our kernel conditional density estimation method using recent incidence](https://github.com/reichlab/article-disease-pred-with-kcde/raw/master/inst/article/infectious-disease-prediction-with-kcde.pdf), and there are many others!

This year, we -- well, mostly [Evan](https://github.com/elray1) -- have developed a new ensemble method that combines predictions from different models. We -- mostly [Abhinav](https://github.com/lepisma) -- also created a visualizer for our predictions. Check it out [here](https://reichlab.github.io/flusight/)! It's still early in the season, and we're not seeing much data to suggest that this will be an unusually high or low year, but that's largely because there just isn't much information in the early-season data.
In this post, I'm going to give you a quick tour under the hood of our ensemble forecasting methodology. At some point, we'll have an article up on GitHub or arXiv, but for now, this explanation will have to suffice.

<a href="https://reichlab.github.io/flusight/">
    <img class="img-responsive" width="700" src="/images/blog/flusight-wide.png">
</a>

<!--more-->

## Details of the challenge 
We call our team the Kernel of Truth (left over from our KCDE methods last year, although we hope the name still is appropriate). The contest is based on predicting a measure of influenza incidence that represents the percentage of all doctor's visits that are for influenza-like-illness (ILI), weighted by population. The measure is called "weighted ILI" and its units are percentage points. Per contest rules, all submissions have to submit full predictive distributions each week from November through April for seven different targets of interest, for each of the HHS regions in the U.S. (and for the country as a whole). Here are the targets

 - incidence for each of the next four weeks
 - onset week: the first week of the first sequence of three weeks to be above the regional CDC baseline for weighted ILI
 - peak week: the week in which peak incidence will occur
 - peak incidence: the actual value of weighted ILI at the peak week


## Component models
For our submissions this year, we obtain the final predictive distributions as a weighted average of predictions from three component models:

1. A "fixed" model using either Kernel Density Estimation (for onset week, peak week, and peak incidence), or a generalized additive model (for predictions of incidence at horizons 1 to 4 weeks).  The raw predictions from this model do not change as new data are observed over the course of the season (though the predictions for incidence in individual weeks do depend on the week being predicted), and can be interpreted as a representation of "everything that we have seen in the past".  A separate model fit is obtained for each region. In week 3 of the competition (Nov 21, 2016), we modified this method to truncate the predictive distributions for onset timing, peak timing, and peak incidence so that values that have been eliminated by previously observed incidence are assigned low probability. Currently, this is done in a very ad hoc manner.
2. A model combining Kernel Conditional Density Estimation (KCDE) and copulas. this method is described in more detail [here](https://github.com/reichlab/article-disease-pred-with-kcde/raw/master/inst/article/infectious-disease-prediction-with-kcde.pdf). In brief, KCDE is used to obtain separate predictive densities for each future week in the season.  In order to predict seasonal quantities (onset, peak timing, and peak incidence), we use a copula to model dependence among those individual predicitive densities, thereby obtaining a joint predicitive density for incidence in all future weeks.  Predicitive densities for the seasonal quantities can be obtained as appropriate integrals of this joint density.  A separate model fit is obtained for each region.
3. A seasonal auto-regressive integrated moving average (SARIMA) model. This model is fit to seasonally differenced log(weighted_ili) using a stepwise procedure to select the model specification. A separate model fit is obtained for each region.

## Ensemble model
The final predictions are obtained as a linear combination of the predictions from these component models using a method known as “stacking” or model averaging.  The model weights depend on the week of the season in which the predictions are made. There is a lot of gnarly math and computation that we’re leaving out here, but if you’d like to see it let us know in the comments section and post some more details.  We estimate the weights via gradient tree boosting, optimizing leave-one-season-out crossvalidated log scores (using the definition of log scores specified for this competition). Currently we are using the `xgboost` package in R to implement this, although there have been some rumblings about moving to another method, as this one is giving us some problems when the curvature of our loss function is negative. I'll spare you the details for now.

We are submitting two variations on the ensemble model:

 - KoTstable is a stable version, in which we will hold fixed all details and model fits for the component models as well as the model weights throughout the season.  Because this model will not be updated, we will be able to learn about model performance over the course of the season. These are the predictions currently shown on the [FluSight visualizer](https://reichlab.github.io/flusight/).
 - KoTdev is a development version, which we will update over the course of the season.  We have plans for tweaks to all three of the existing component models, the addition of new component models, and changes to computation of the model weights.  This model provides a sandbox for development of new features and continuous improvement of our prediction methodology.  In the first submission week, the predictions from KoTstable and KoTdev were

## Summary
There is a lot more work to do on this to get it to where we want to it be, but one of the "advantages" of these challenges is that they force you to get stuff out there and just try it out. Some of the things that we are thinking about doing are improving the estimation methodology for the weights (including perhaps some kind of smoothing or regularization of the weights), adding a more mechanistic model that incorporates some biological features of flu, and incorporating the uncertainty in recent observations (as you can see in the app, there can be adjustments to reported cases, especially in the most recently reported weeks). So, there's lots to do, and we're hopefully just getting started.
