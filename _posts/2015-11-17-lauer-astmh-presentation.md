---
title: "ASTMH 2015 Presentation: Real-time prediction of dengue fever in Thailand"
layout: post
author: Steve
comments: True
---

Last week, I had the honor of presenting at the 64th Annual Meeting of the [American Society of Tropical Medicine & Hygiene (ASTMH)](https://www.astmh.org/Home.htm) in the well-attended [Dengue: Epidemiology session](http://www.abstractsonline.com/Plan/ViewSession.aspx?sKey=b42307ef-cc96-4877-9cfe-40cb3e3ffb51&mKey=%7bAB652FDF-0111-45C7-A5E5-0BA9D4AF5E12%7d). This presentation covers our work with the Thai Ministry of Public Health and Johns Hopkins University in building an infrastructure for making real-time dengue hemorrhagic fever case predictions and evaluating the performance of our predictions thus far.

You can find the slides for the presentation [here](https://speakerdeck.com/salauer/real-time-prediction-of-dengue-fever-in-thailand). After the jump, I'll provide a slide-by-slide summary. To view the paper associated with this work, you can check it out on [arXiv](http://arxiv.org/abs/1511.04812).

<!--more-->

#### Slides 1-3: Introduction, funding, and project team members

#### Slide 4: Statement of purpose and background

The goal of this project is to predict Thailand dengue hemorrhagic fever (DHF) outbreaks in real time. Since 1980, there have been between 17,000 and 175,000 DHF cases reported each year, with about 50,000 on average. All four dengue serotypes co-circulate in Thailand, which creates complex transmission dynamics. Furthermore, there are 77 provinces, which vary in nearly every possible dimension from geography and climate to economy and demographics. Altogether, this makes it very difficult to have one unifying model for the entire country

#### Slide 5: Presentation overview

#### Slide 6: Data pipeline

Every two weeks, the Thai Ministry of Public Health (MoPH) sends us a cumulative list of all the cases reported for the year-to-date. We integrate this into our PostgreSQL database and aggregate the data into analysis datasets. We use these datasets to make predictions, which we present to the Thai MoPH as a pdf and an interactive web app.

#### Slide 7: Interactive web app

With our interactive web app, the Thai MoPH can view the observed cases and our predictions for the rest of the year as a plot or on a heat map of Thailand. The app can be viewed in either English or Thai. In this screenshot, you can observe that 2013 was a large epidemic season, while 2014 was rather low. Thus far, we have already observed more cases for 2015 than for 2014, though we believe it is unlikely that there will be as many cases this year as in 2013.

#### Slide 8: Database

The foundation of our project is our DHF database. The Thai Dengue Surveillance System has been around for nearly fifty years and has tallied DHF cases in several different sources and formats. Our team aggregated the data from these sources into a single database.

This graph displays over two million DHF cases over 48 years. On the y-axis are the provinces arranged by population (with Bangkok Metropolis as the most populous), the years are on the x-axis, and the colors indicate DHF incidence, with darker indicating higher rates. The ripples going across represent seasonality and multi-annual trends for each province. The dark vertical lines show the epidemics that affected multiple provinces.

#### Slide 9: Forecasting model overview

To predict the number of DHF cases, we built a forecasting model grounded in epidemiological theory. We seek to predict the number of cases $Y$ in province $i$ at time $t$. We assume that these cases counts follow a Poisson distribution with a mean equal to $\lambda_{i,t}$ multiplied by the number of cases at the last time step.

By re-arranging the formula, we show that $\lambda_{i,t}$ is equivalent to the ratio of the expected current cases over the number of cases observed at the previous time step. By setting each time step to the estimated generation time of dengue, about two weeks (or what we call a biweek), $\lambda_{i,t}$ approximates the reproductive rate.

#### Slide 10: GAM for $\lambda_{i,t}$

We fit a generalized additive model (GAM) with three major components to estimate $\lambda_{i,t}$. $f(t)$ is a cyclic cubic spline for seasonality. $g(t)$ is a smooth spline to capture long-term secular trends. The final term takes in recently observed trends for multiple provinces at recent time points. This means that the model observes whether the number of cases are increasing or decreasing in those provinces and the magnitude of these changes. The $\alpha$ coefficients determine how these trends affect the change in cases in our province of interest at the current time step.

#### Slide 11: Predictions using complete data

Having formulated our model, we set out to train it by "predicting" the cases that we observed from 2000-2009. For more details about how we conducted this model training, see slide 32.

#### Slide 12-14: Visualizing prediction and evaluation

In these slides, I will show an example of how we make predictions using complete data. The first slide shows the counts for Bangkok in 2014. On July 16th, we assume that we know all prior data and nothing of the current or future counts.

In the second slide, we use our forecasting model to recursively make 1,000 predictions 10 time steps into the future (for our 2000-2009 validation, we actually predicted 13 time steps forward). The points are the median prediction for each biweek surrounded by the 95% confidence interval.

In the third slide, we compare our predictions to the historical median for each province biweek. We define the historical median as the median case count for a given biweek in a given province over the past ten years. To evaluate our predictions, we divide the mean absolute error of our prediction by the mean absolute error of the historical median to obtain the relative mean absolute error (for more on this see slide 33).

#### Slide 15: Model training results

The table on this slide displays how often our model made better predictions than a model that merely predicted the historical median. For more detailed results from our model training, see slide 34.

#### Slide 16: Predictions using real-time data

Having trained our model, we set out to use it to predict the 2014 season in real time. However, when the Thai MoPH started sending us case reports at the end of 2013, we immediately noticed something was different...

#### Slide 17: Reporting delays

... There were reporting delays. We define a reporting delay as the time difference between the onset of symptoms for a case and when that case enters our database. We realized that we would need to adjust our forecasting model in order to account for these reporting delays and would be unable to predict the 2014 season in real time.

In April of 2015, we received our final case report for 2014. In 2014, reporting delays ranged from 1 day to 17 months; 75% of cases were reported within 3 months and 95% were reported within 8 months.

#### Slides 18-22: Real-time prediction adjustment

Using our previous example, I will display how we adjusted our forecasts to be conducted in real time. The first slide of this sequence shows the assumptions of our model from before, with complete reporting.

The second slide shows what we had actually observed at that point in time. Instead of seeing all of the data before July 16th, there are no cases reported for the previous biweek and steadily more further back in time. This is an exceptional scenario before a large data dump with many of the cases from January through May were reported, however it is indicative of the challenges we face when trying to predict in real time.

In the third slide, we move our prediction date back 6 biweeks. Even though only 75% of cases have been reported by this time (on average), we assume that all cases prior to this date are complete and ignore everything since. While this is a rather weak assumption in this specific case, we use it as a starting point for making real-time forecasts.

The fourth and fifth slides show our predictions and comparison to historical medians as in slides 13-14.

#### Slides 23-25: "Predicting" 2014

By keeping the reporting dates for each case, we were able to use our model to "predict" the 2014 season as if in real time. After making the predictions, we ranked the provinces by their performance relative to historical medians.

The first slide shows two multi-step predictions from the three provinces that performed best compared to the historical medians. The second slide shows the three provinces that performed adequately against the historical medians. The third slide shows the three provinces that performed worst against the historical medians. Note that a couple of these predictions "explode" and become very large at a fast rate. Whether this is due to issues in reporting or for model-based reasons has yet to be determined.

#### Slide 26: "Real-time" results

One time step forecasts for our "real-time" model performed comparably to four month ahead predictions in the complete data training model. Two month ahead real-time predictions are outperformed by the historical medians model.

2014 was a rather anomalous season. After the large epidemic season in 2013, many provinces observed more cases in January and February than during the rainy season, from May to October, when the majority of cases usually occur. Furthermore, our model was trained on ten seasons with nearly 20,000 predicted province biweeks. By contrast, we made fewer than 2,000 predictions for the 2014 season. We expect these numbers to change as our model makes more forecasts. For more detailed results from our model training, see slide 35.

Therefore, we continued on to predict the 2015 dengue season in real time with the same model.

#### Slide 27: 2015 predictions to date

This graph shows the observed case counts of 2015 as of October 22nd as black bars and our predictions for each time point as green lines. From our experience with reporting delays, we know that all of the cases will increase between now and April 2016. Thus far, 2015 has been a more regular dengue season than 2014. In October, we started to receive a large number of reported cases for Bangkok in July and August. While our model generally predicts that 2015 will have fewer cases than 2013, the large uncertainty about Bangkok allows a slim possibility for 2015 to surpass that season.

#### Slide 28: Central achievements

#### Slide 29: Future developments

There are several augmentations we hope to incorporate into our model before the Thais begin using our model to make public health policy decisions in 2016. We are modeling the reporting delays so that we can use all of the information we have at our disposal instead of ignoring recent data.

Serotype dynamics play a major role in the transmission of dengue. While the true structure is incredibly complex, we are hoping to use some simplified approximations to improve our model.

The use of climate information may help us determine the timing of the dengue season.

When making biweek-scale forecasts, some intuition we have about multi-annual dengue trends may get lost. By incorporating annual predictions, we may be able to adjust our forecasts to make better long-term predictions.

Eventually, our ultimate goal is to wrap several strong models into a single ensemble model capable of making more accurate forecasts for dengue hemorrhagic fever in Thailand.

#### Slide 30: Final slide

Forgot to mention that my twitter handle is @salauer_biostat

#### Slide 31: Database sources

The two major contributors to our database were monthly aggregated counts for the years before 2005 and a line list of individual cases since 1999.

#### Slide 32: Model training

To conduct model training, we used leave-one-year-out cross validation (i.e. use all the data from 1968-1999 and 2001-2009 to predict 2000, then use all data from 1968-2000 and 2002-2009 to predict 2001, etc.). We used many combinations of lags and correlated provinces. The combination that performed best at making forecasts by relative mean absolute error (more info on slide 33) was one with 3 correlated provinces at the prior time step. That was on average for the whole country, there was provincial variation for best combination.

#### Slide 33: Relative mean absolute error (MAE)

Relative MAE is intuitive because when it represents the amount of error of one system over another. A relative MAE of 0.5 means that our model has half of the error of the historical medians model; a relative MAE of 1 indicates that the models are equivalent; and a relative MAE of 2 conveys that our model has twice as much error as the historical medians model.

One advantage of using MAE is that it doesn't penalize outliers as much as other evaluation measures, such as mean squared error.

#### Slide 34: Training relative MAE results

This graph shows the performance of each province from the model training. On the y-axis are the provinces ordered by population; the x-axis has the relative MAE; and the color of the points represent different forecast horizons, with lighter colors indicating longer term predictions.

For these results, the vast majority of the points are to the left of the dashed line, which indicates that the predictions had less error than those of the historical medians model. Also, darker points tend to be to the left of lighter points, which indicates that our short-term forecasts are better than our long-term forecasts, relative to the historical medians model.

#### Slide 35: "Real-time" relative MAE results

This graph is set up in the same way as the one for training in slide 34, except that the step numbers are adjusted for our 6 biweek adjustment.

There is much more variation in these results (note the log scale on the x-axis) than for the training results. This is partially due to the fact that the results are averaged over one season instead of ten seasons. There are also some provinces which had better long-term predictions than short-term predictions. This may be due to the anomalous timing of the 2014 dengue season, reporting delays, or other factors.