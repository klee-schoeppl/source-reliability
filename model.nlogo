extensions [py]
breed[conOLs conOL]
breed[boolOLs boolOL]
breed[conBHs conBH]
breed[boolBHs boolBH]
breed[boolALs boolAL]
breed[boolSDs boolSD]
breed[conALs conAL]
breed[conSDs conSD]
globals[rep rel repCounter]

;in order, h r c a are the agents' credences in the hypothesis, in the source-reliability, in the source-competency and in the degree-of-interest-alignment
boolOLs-own[h r vValue accurateTrustCounter trustAccuracy]
boolBHs-own[h r vValue accurateTrustCounter trustAccuracy]
boolALs-own[h c a vValue accurateTrustCounter trustAccuracy]
boolSDs-own[h c a vValue accurateTrustCounter trustAccuracy]
conBHs-own[h meanR r vValue accurateTrustCounter trustAccuracy]
conOLs-own[h meanR r vValue accurateTrustCounter trustAccuracy]
conALs-own[h a c meanA meanC vValue accurateTrustCounter trustAccuracy]
conSDs-own[h a c meanA meanC vValue accurateTrustCounter trustAccuracy]

to setup
  clear-all
  reset-ticks
  setupPython
  if conOL? = true [setupConOL]
  if conBH? = true [setupConBH]
  if conAL? = true [setupConAL]
  if conSD? = true [setupConSD]
  if boolOL? = true [setupBoolOL]
  if boolBH? = true [setupBoolBH]
  if boolAL? = true [setupBoolAL]
  if boolSD? = true [setupBoolSD]
  set rel alpha * kappa + (1 - alpha) * (1 - kappa)
end


to go
  tick

  set-current-plot "current credense density distribution(s)"
  clear-plot
  set-current-plot "trustworthiness Accuracies"
  clear-plot

  ifelse manualReporting = false [
    let i random-float 1
    ifelse i < (alpha * kappa + (1 - alpha) * (1 - kappa))[
      set rep true
      set repCounter repCounter + 1
    ][
      set rep false
    ]
  ][
    set rep report?
    if report? [set repCounter repCounter + 1]
  ]

  updateConOL
  updateConBH
  updateConAL
  updateConSD
  updateBoolOL
  updateBoolBH
  updateBoolAL
  updateBoolSD

  if ticks >= ticksLimit [stop]
end

to setupPython

   py:setup  py:python
  (py:run
    "import scipy.stats as stats"
    "import numpy as np"
  )

  py:set "res" res
  py:set "useMean" useWeightedMean
  py:set "rnd" rnd

  py:set "relBH" relBH
  py:set "alphaBH" alphaBH
  py:set "betaBH" betaBH

  py:set "relOL" relOL
  py:set "alphaOL" alphaOL
  py:set "betaOL" betaOL

  py:set "alAL" alAL
  py:set "comAL" comAL
  py:set "alAlphaAL" alAlphaAL
  py:set "alBetaAL" alBetaAL
  py:set "comAlphaAL" comAlphaAL
  py:set "comBetaAL" comBetaAL

  py:set "alSD" alSD
  py:set "comSD" comSD
  py:set "alAlphaSD" alAlphaSD
  py:set "alBetaSD" alBetaSD
  py:set "comAlphaSD" comAlphaSD
  py:set "comBetaSD" comBetaSD
end

;Boolean focal agents
to setupBoolOL
  create-boolOLs 1[
    set size 5
    set h priorHyp
    set r relOL

    set-current-plot "boolean OL"
    set-current-plot-pen "REL"
    plotxy ticks r
    set-current-plot-pen "HYP"
    plotxy ticks h

    set vValue ((phi * h) - (1 - phi) * (1 - h))
    set trustAccuracy 0.5

    set-current-plot "veritistic Values"
    set-current-plot-pen "Boolean OL"
    plotxy ticks vValue
    set-current-plot "trustworthiness Accuracies"
    set-current-plot-pen "Boolean OL"
    plotxy 0 trustAccuracy

    if failsafeH[
      if h <= 0.0000000000001 [set h 0.000000000001]
      if h >= 0.9999999999999 [set h 0.999999999999]
    ]
    if r >= 0.9999999999999 [set r 0.999999999999]
    if r <= 0.0000000000001 [set r 0.000000000001]
  ]
end

to setupBoolBH

  create-boolBHs 1[

    set size 5
    set h priorHyp
    set r relBH

    set-current-plot "boolean BH"
    set-current-plot-pen "REL"
    plotxy ticks r
    set-current-plot-pen "HYP"
    plotxy ticks h

    set vValue ((phi * h) - (1 - phi) * (1 - h))
    set trustAccuracy 0.5

    set-current-plot "veritistic Values"
    set-current-plot-pen "Boolean BH"
    plotxy ticks vValue
    set-current-plot "trustworthiness Accuracies"
    set-current-plot-pen "Boolean BH"
    plotxy 2 trustAccuracy

    if failsafeH[
      if h <= 0.0000000000001 [set h 0.000000000001]
      if h >= 0.9999999999999 [set h 0.999999999999]
    ]
    if r >= 0.9999999999999 [set r 0.999999999999]
    if r <= 0.0000000000001 [set r 0.000000000001]


  ]

end

to setupBoolAL
  create-boolALs 1[

    set size 5
    set h priorHyp
    set a alAL
    set c comAL

    set-current-plot "boolean AL"
    set-current-plot-pen "AL"
    plotxy ticks a
    set-current-plot-pen "COM"
    plotxy ticks c
    set-current-plot-pen "HYP"
    plotxy ticks h

    set vValue ((phi * h) - (1 - phi) * (1 - h))
    set trustAccuracy 0.5

    set-current-plot "veritistic Values"
    set-current-plot-pen "Boolean AL"
    plotxy ticks vValue
    set-current-plot "trustworthiness Accuracies"
    set-current-plot-pen "Boolean AL"
    plotxy 4 trustAccuracy

     if failsafeH[
      if h <= 0.0000000000001 [set h 0.000000000001]
      if h >= 0.9999999999999 [set h 0.999999999999]
    ]
      if c >= 0.9999999999999 [set c 0.999999999999]
      if a >= 0.9999999999999 [set a 0.999999999999]
      if c <= 0.0000000000001 [set c 0.000000000001]
      if a <= 0.0000000000001 [set a 0.000000000001]

  ]

end

to setupBoolSD
  create-boolSDs 1[

    set size 5
    set h priorHyp
    set a alSD
    set c comSD

    set-current-plot "boolean SD"
    set-current-plot-pen "AL"
    plotxy ticks a
    set-current-plot-pen "COM"
    plotxy ticks c
    set-current-plot-pen "HYP"
    plotxy ticks h

    set vValue ((phi * h) - (1 - phi) * (1 - h))
    set trustAccuracy 0.5

    set-current-plot "veritistic Values"
    set-current-plot-pen "Boolean SD"
    plotxy ticks vValue
    set-current-plot "trustworthiness Accuracies"
    set-current-plot-pen "Boolean SD"
    plotxy 6 trustAccuracy

    if failsafeH[
      if h <= 0.0000000000001 [set h 0.000000000001]
      if h >= 0.9999999999999 [set h 0.999999999999]
    ]
    if c >= 0.9999999999999 [set c 0.999999999999]
    if a >= 0.9999999999999 [set a 0.999999999999]
    if c <= 0.0000000000001 [set c 0.000000000001]
    if a <= 0.0000000000001 [set a 0.000000000001]

  ]

end

to updateBoolOL
  ask boolOLs[

    let tempH h
    ;did this agent update p(HYP) in the correct manner?
    if (r > 0.5 and rel > 0.5) or (r < 0.5 and rel < 0.5) or (r = 0.5 and rel = 0.5) [set accurateTrustCounter accurateTrustCounter + 1]

    ifelse rep = true[
      set h ((r * h)/(r * h + (1 - r)* (1 - h)))
      set r ((tempH * r)/(tempH * r + (1 - tempH) * (1 - r)))
    ][
      set h ((h * ( 1 - r))/(1 - (r * h + (1 - r)* (1 - h))))
      set r (((1 - tempH) * r)/(1 - (r * tempH + (1 - r)* (1 - tempH))))
    ]


    if failsafeH[
      if h <= 0.0000000000001 [set h 0.000000000001]
      if h >= 0.9999999999999 [set h 0.999999999999]
    ]
    if r >= 0.9999999999999 [set r 0.999999999999]
    if r <= 0.0000000000001 [set r 0.000000000001]


    set-current-plot "boolean OL"
    set-current-plot-pen "REL"
    plotxy ticks r
    set-current-plot-pen "HYP"
    plotxy ticks h

    set vValue ((phi * h) - (1 - phi) * (1 - h))
    set trustAccuracy accurateTrustCounter / ticks

    set-current-plot "veritistic Values"
    set-current-plot-pen "Boolean OL"
    plotxy ticks vValue
    set-current-plot "trustworthiness Accuracies"
    set-current-plot-pen "Boolean OL"
    plotxy 0 trustAccuracy
  ]
end

to updateBoolBH
  ask boolBHs[


     if (r > 0 and rel > 0.5) or (r = 0 and rel = 0.5) [set accurateTrustCounter accurateTrustCounter + 1]

    let tempH h

    ifelse rep = true[
      set h ((r + rnd - r * rnd) * h /(r * h + rnd - r * rnd))
      set r ((tempH * r)/(r * tempH + rnd - r * rnd))
    ][
      set h (((1 - (r + rnd - r * rnd))* h) /(1 - (r * h + rnd - r * rnd)))
      set r (((1 - tempH)* r) / (1 - (r * tempH + rnd - r * rnd)))
    ]

    if failsafeH[
      if h <= 0.0000000000001 [set h 0.000000000001]
      if h >= 0.9999999999999 [set h 0.999999999999]
    ]
    if r >= 0.9999999999999 [set r 0.999999999999]
    if r <= 0.0000000000001 [set r 0.000000000001]


    set-current-plot "boolean BH"
    set-current-plot-pen "REL"
    plotxy ticks r
    set-current-plot-pen "HYP"
    plotxy ticks h

    set vValue ((phi * h) - (1 - phi) * (1 - h))
    set trustAccuracy accurateTrustCounter / ticks

    set-current-plot "veritistic Values"
    set-current-plot-pen "Boolean BH"
    plotxy ticks vValue
    set-current-plot "trustworthiness Accuracies"
    set-current-plot-pen "Boolean BH"
    plotxy 2 trustAccuracy


  ]
end

to updateBoolAL
  ask boolALs[

    if ((a > 0.5) and (c > 0) and (rel > 0.5)) or ((a  < 0.5) and (c > 0) and (rel < 0.5)) or ((a  = 0.5 or c = 0) and rel = 0.5) [set accurateTrustCounter accurateTrustCounter + 1]
    let tempH h
    let tempC c

    ifelse rep = true[
      set h ((c * a + rnd * (1 - c))* h)/(h * c * a + (1 - h) * c * (1 - a) + rnd * (1 - c ))
      set c (((tempH * a + (1 - tempH)*(1 - a)) * c)/(tempH * c * a + (1 - tempH) * c * (1 - a) + rnd * (1 - c)))
      set a (((tempH * tempC + rnd * (1 - tempC))* a)/(tempH * tempC * a + (1 - tempH) * tempC * (1 - a) + rnd * (1 - tempC)))
    ][
      set h (((1 - (c * a + rnd * (1 - c))) * h) / (1 - (h * c * a + (1 - h) * c * (1 - a) + rnd * (1 - c))))
      set c ((1 - (tempH * a + (1 - tempH) * (1 - a))) * c)/(1 - (tempH * c * a + (1 - tempH) * c * (1 - a) + rnd * (1 - c)))
      set a (((1 - (tempH * tempC + rnd * (1 - tempC))) * a)/(1 - (tempH * tempC * a + (1 - tempH) * tempC * (1 - a) + rnd * (1 - tempC))))
    ]

     if failsafeH[
      if h <= 0.0000000000001 [set h 0.000000000001]
      if h >= 0.9999999999999 [set h 0.999999999999]
    ]
    if c >= 0.9999999999999 [set c 0.999999999999]
    if a >= 0.9999999999999 [set a 0.999999999999]
    if c <= 0.0000000000001 [set c 0.000000000001]
    if a <= 0.0000000000001 [set a 0.000000000001]

    set-current-plot "boolean AL"
    set-current-plot-pen "AL"
    plotxy ticks a
    set-current-plot-pen "COM"
    plotxy ticks c
    set-current-plot-pen "HYP"
    plotxy ticks h

    set vValue ((phi * h) - (1 - phi) * (1 - h))
    set trustAccuracy accurateTrustCounter / ticks

    set-current-plot "veritistic Values"
    set-current-plot-pen "Boolean AL"
    plotxy ticks vValue
    set-current-plot "trustworthiness Accuracies"
    set-current-plot-pen "Boolean AL"
    plotxy 4 trustAccuracy
  ]
end

to updateBoolSD
  ask boolSDs[

    if ((a  * c + (1 - a) * (1 - c) > 0.5) and rel > 0.5) or ((a * c + (1 - a) * (1 - c) < 0.5) and rel < 0.5) or ((a * c + (1 - a) * (1 - c) = 0.5) and rel = 0.5) [set accurateTrustCounter accurateTrustCounter + 1]
    let tempH h
    let tempC c

    ifelse rep = true[
      set h ((c * a + (1 - c) * (1 - a))* h)/(h * c * a + (1 - h) * (1 - c) * a + h * (1 - c) * (1 - a) + (1 - h) * c * (1 - a))
      set c ((tempH * a + (1 - tempH) * (1 - a))* c)/(tempH * c * a + (1 - tempH) * (1 - c) * a + tempH * (1 - c) * (1 - a) + (1 - tempH) * c * (1 - a))
      set a ((tempH * tempC + (1 - tempH) * (1 - tempC))* a)/(tempH * tempC * a + (1 - tempH) * (1 - tempC) * a + tempH * (1 - tempC) * (1 - a) + (1 - tempH) * tempC * (1 - a))
    ][
      set h ((1 - (c * a + (1 - c) * (1 - a)))* h)/(1 - (h * c * a + (1 - h) * (1 - c) * a + h * (1 - c) * (1 - a) + (1 - h) * c * (1 - a)))
      set c ((1 - (tempH * a + (1 - tempH) * (1 - a)))* c)/(1 - (tempH * c * a + (1 - tempH) * (1 - c) * a + tempH * (1 - c) * (1 - a) + (1 - tempH) * c * (1 - a)))
      set a ((1 - (tempH * tempC + (1 - tempH) * (1 - tempC)))* a)/(1 - (tempH * tempC * a + (1 - tempH) * (1 - tempC) * a + tempH * (1 - tempC) * (1 - a) + (1 - tempH) * tempC * (1 - a)))
    ]

    if failsafeH[
      if h <= 0.0000000000001 [set h 0.000000000001]
      if h >= 0.9999999999999 [set h 0.999999999999]
    ]
    if c >= 0.9999999999999 [set c 0.999999999999]
    if a >= 0.9999999999999 [set a 0.999999999999]
    if c <= 0.0000000000001 [set c 0.000000000001]
    if a <= 0.0000000000001 [set a 0.000000000001]


    set-current-plot "boolean SD"
    set-current-plot-pen "AL"
    plotxy ticks a
    set-current-plot-pen "COM"
    plotxy ticks c
    set-current-plot-pen "HYP"
    plotxy ticks h

    set vValue ((phi * h) - (1 - phi) * (1 - h))
    set trustAccuracy accurateTrustCounter / ticks

    set-current-plot "veritistic Values"
    set-current-plot-pen "Boolean SD"
    plotxy ticks vValue
    set-current-plot "trustworthiness Accuracies"
    set-current-plot-pen "Boolean SD"
    plotxy 6 trustAccuracy
  ]
end

to setupConOL
  create-conOLs 1[

    set size 5
    set h priorHyp
    set vValue ((phi * h) - (1 - phi) * (1 - h))

    (py:run
    "unitInterval = np.linspace(0, 1, res + 1)"
    "r = stats.beta.pdf(unitInterval, alphaOL, betaOL)"
    )
    set r py:runresult "r"


    ifelse useWeightedMean[
      (py:run
        "meanR = 0"
        "for x in range(len(r)):"
        "    meanR = meanR + r[x] * x / res"
        "meanR = meanR / (res + 1)"
      )
    ][

      (py:run
        "meanR = 0"
        "for x in range(len(r)):"
        "    r[x] = r[x] * (x / res)"
        "for x in range(len(r)-1):"
        "    meanR = meanR + (min(r[x], r[x+1]) * (1 / res) + 0.5 * abs(r[x] - r[x+1]) * (1 / res))";* (x + 0.5) / res

    )
    ]

     if failsafeH[
      if h <= 0.0000000000001 [set h 0.000000000001]
      if h >= 0.9999999999999 [set h 0.999999999999]
    ]

    set meanR py:runresult "meanR"
    set-current-plot "continuous OL"
    set-current-plot-pen "mean REL"
    plotxy ticks meanR
    set-current-plot-pen "HYP"
    plotxy ticks h

    set-current-plot "current credense density distribution(s)"
    set-current-plot-pen "continuous OL (REL)"
    let x 0
    foreach r [
      y ->
      plotxy x y
      set x x + 1 / res
       if x > 1 [set x 1];just to keep the plot nice-looking in case of rounding errors producing x values minimally above 1
    ]

    set vValue ((phi * h) - (1 - phi) * (1 - h))
    set trustAccuracy 0.5

    set-current-plot "veritistic Values"
    set-current-plot-pen "continuous OL"
    plotxy ticks vValue
    set-current-plot "trustworthiness Accuracies"
    set-current-plot-pen "continuous OL"
    plotxy 1 trustAccuracy

  ]

end

to setupConBH
  create-conBHs 1[
    set size 5
    set color red
    set xcor 0
    set ycor 0
    set h priorHyp

    (py:run
    "x = np.linspace(0, 1, res + 1)"
    "r = stats.beta.pdf(x, alphaBH, betaBH)"
    )

    set r py:runresult "r"

    ifelse useWeightedMean[
      (py:run
        "meanR = 0"
        "for x in range(len(r)):"
        "    meanR = meanR + r[x] * x / res"
        "meanR = meanR / (res + 1)"
      )
    ][

      (py:run
        "meanR = 0"
        "for x in range(len(r)):"
        "    r[x] = r[x] * (x / res)"
        "for x in range(len(r)-1):"
        "    meanR = meanR + (min(r[x], r[x+1]) * (1 / res) + 0.5 * abs(r[x] - r[x+1]) * (1 / res))";* (x + 0.5) / res

    )
    ]



      if failsafeH[
      if h <= 0.0000000000001 [set h 0.000000000001]
      if h >= 0.9999999999999 [set h 0.999999999999]
    ]

     set meanR py:runresult "meanR"

    set-current-plot "continuous BH"
    set-current-plot-pen "mean REL"
    plotxy ticks meanR
    set-current-plot-pen "HYP"
    plotxy ticks h


    set-current-plot "current credense density distribution(s)"
    set-current-plot-pen "continuous BH (REL)"
    let x 0
    foreach r [
      y ->
      plotxy x y
      set x x + 1 / res
      if x > 1 [set x 1]
    ]

    set vValue ((phi * h) - (1 - phi) * (1 - h))
    set trustAccuracy 0.5

    set-current-plot "veritistic Values"
    set-current-plot-pen "continuous BH"
    plotxy ticks vValue
    set-current-plot "trustworthiness Accuracies"
    set-current-plot-pen "continuous BH"
    plotxy 3 trustAccuracy

  ]

end

to setupConAL

   create-conALs 1[
    set size 5
    set color red
    set xcor 0
    set ycor 0
    set h priorHyp

    (py:run
    "x = np.linspace(0, 1, res + 1)"

    "a = stats.beta.pdf(x, alAlphaAL, alBetaAL)"

    "c = stats.beta.pdf(x, comAlphaAL, comBetaAL)"
       )

     set a py:runresult "a"
     set c py:runresult "c"

     ifelse useWeightedMean[
      (py:run
        "meanA = 0"
        "for x in range(len(a)):"
        "    meanA = meanA + a[x] * x / res"
        "meanA = meanA / (res + 1)"

        "meanC = 0"
        "for x in range(len(c)):"
        "    meanC = meanC + c[x] * x / res"
        "meanC = meanC / (res + 1)"
      )
    ][

      (py:run
        "meanA = 0"
        "for x in range(len(a)):"
        "    a[x] = a[x] * (x / res)"
        "for x in range(len(a)-1):"
        "    meanA = meanA + (min(a[x], a[x+1]) * (1 / res) + 0.5 * abs(a[x] - a[x+1]) * (1 / res))"

        "meanC = 0"
        "for x in range(len(c)):"
        "    c[x] = c[x] * (x / res)"
        "for x in range(len(c)-1):"
        "    meanC = meanC + (min(c[x], c[x+1]) * (1 / res) + 0.5 * abs(c[x] - c[x+1]) * (1 / res))"
    )
    ]




      if failsafeH[
      if h <= 0.0000000000001 [set h 0.000000000001]
      if h >= 0.9999999999999 [set h 0.999999999999]
    ]


    set meanA py:runresult "meanA"


    set meanC py:runresult "meanC"

      set-current-plot "continuous AL"
    set-current-plot-pen "mean AL"
    plotxy ticks meanA
    set-current-plot-pen "mean COM"
    plotxy ticks meanC
    set-current-plot-pen "HYP"
    plotxy ticks h

    set-current-plot "current credense density distribution(s)"
    set-current-plot-pen "continuous AL (AL)"
    let x 0
    foreach a [
      y ->
      plotxy x y
      set x x + 1 / res
      if x > 1 [set x 1]
    ]
    set-current-plot-pen "continuous AL (COM)"
    set x 0
    foreach c [
      y ->
      plotxy x y
      set x x + 1 / res
      if x > 1 [set x 1]
    ]

     set vValue ((phi * h) - (1 - phi) * (1 - h))
    set trustAccuracy 0.5

    set-current-plot "veritistic Values"
    set-current-plot-pen "continuous AL"
    plotxy ticks vValue
    set-current-plot "trustworthiness Accuracies"
    set-current-plot-pen "continuous AL"
    plotxy 5 trustAccuracy


  ]

end

to setupConSD

   create-conSDs 1[
    set size 5
    set color red
    set xcor 0
    set ycor 0
    set h priorHyp

    (py:run
    "x = np.linspace(0, 1, res + 1)"

    "a = stats.beta.pdf(x, alAlphaSD, alBetaSD)"

     "c = stats.beta.pdf(x, comAlphaSD, comBetaSD)"
    )

    set a py:runresult "a"
    set c py:runresult "c"

    ifelse useWeightedMean[
      (py:run
        "meanA = 0"
        "for x in range(len(a)):"
        "    meanA = meanA + a[x] * x / res"
        "meanA = meanA / (res + 1)"

        "meanC = 0"
        "for x in range(len(c)):"
        "    meanC = meanC + c[x] * x / res"
        "meanC = meanC / (res + 1)"
      )
    ][

      (py:run
        "meanA = 0"
        "for x in range(len(a)):"
        "    a[x] = a[x] * (x / res)"
        "for x in range(len(a)-1):"
        "    meanA = meanA + (min(a[x], a[x+1]) * (1 / res) + 0.5 * abs(a[x] - a[x+1]) * (1 / res))"

        "meanC = 0"
        "for x in range(len(c)):"
        "    c[x] = c[x] * (x / res)"
        "for x in range(len(c)-1):"
        "    meanC = meanC + (min(c[x], c[x+1]) * (1 / res) + 0.5 * abs(c[x] - c[x+1]) * (1 / res))"
      )
    ]

      if failsafeH[
      if h <= 0.0000000000001 [set h 0.000000000001]
      if h >= 0.9999999999999 [set h 0.999999999999]
    ]


    set meanA py:runresult "meanA"


    set meanC py:runresult "meanC"

    set-current-plot "continuous SD"
    set-current-plot-pen "mean AL"
    plotxy ticks meanA
    set-current-plot-pen "mean COM"
    plotxy ticks meanC
    set-current-plot-pen "HYP"
    plotxy ticks h

    set-current-plot "current credense density distribution(s)"
    set-current-plot-pen "continuous SD (AL)"
    let x 0
    foreach a [
      y ->
      plotxy x y
      set x x + 1 / res
      if x > 1 [set x 1]
    ]
    set-current-plot-pen "continuous SD (COM)"
    set x 0
    foreach c [
      y ->
      plotxy x y
      set x x + 1 / res
      if x > 1 [set x 1]
    ]

    set vValue ((phi * h) - (1 - phi) * (1 - h))
    set trustAccuracy 0.5

    set-current-plot "veritistic Values"
    set-current-plot-pen "continuous SD"
    plotxy ticks vValue
    set-current-plot "trustworthiness Accuracies"
    set-current-plot-pen "continuous SD"
    plotxy 7 trustAccuracy

  ]

end

;when updating and plotting, increment x by (res - 1), because it takes n data-points to encapsulate n - 1 intervals //no longer true
to updateConOL
  ask conOLs[
    if ((meanR > 0.5) and rel > 0.5) or (meanR < 0.5 and rel < 0.5) or (meanR = 0.5 and rel = 0.5) [set accurateTrustCounter accurateTrustCounter + 1]

    py:set "r" r
    py:set "meanR" meanR
    py:set "h" h

    ifelse rep = true[
      (py:run

        "for x in range(len(r)):"
        "    r[x] = ((x / res) * h + (1 - x / res) * (1 - h))/(meanR * h + (1 - meanR) * (1 - h)) * r[x]"
        "h = (meanR * h) / (meanR * h + (1 - meanR) * (1 - h))"

      )
    ][
      (py:run

        "for x in range(len(r)):"
        "    r[x] = ((x / res) * (1 - h) + (1 - x / res) * h)/ (1 -(meanR * h + (1 - meanR) * (1 - h))) * r[x]"
        "h = ((1 - meanR) * h) / (1 - (meanR * h + (1 - meanR) * (1 - h)))"
      )
    ]

     (py:run
      "for x in range(len(r)):"
      "    if r[x]  == 0 :"
      "        r[x] = 0.0000000000001"
    )


    set r py:runresult "r"
    set h py:runresult "h"



    ifelse useWeightedMean[
      (py:run
        "meanR = 0"
        "for x in range(len(r)):"
        "    meanR = meanR + r[x] * x / res"
        "meanR = meanR / (res + 1)"
      )
    ][

      (py:run
        "meanR = 0"
        "for x in range(len(r)):"
        "    r[x] = r[x] * (x / res)"
        "for x in range(len(r)-1):"
        "    meanR = meanR + (min(r[x], r[x+1]) * (1 / res) + 0.5 * abs(r[x] - r[x+1]) * (1 / res))";* (x + 0.5) / res

    )
    ]

     set meanR py:runresult "meanR"

     if failsafeH[
      if h <= 0.0000000000001 [set h 0.000000000001]
      if h >= 0.9999999999999 [set h 0.999999999999]
    ]


    set-current-plot "continuous OL"
    set-current-plot-pen "mean REL"
    plotxy ticks meanR
    set-current-plot-pen "HYP"
    plotxy ticks h


    set-current-plot "current credense density distribution(s)"
    set-current-plot-pen "continuous OL (REL)"
    let x 0
    foreach r [
      y ->
      plotxy x y
      set x x + 1 / res
      if x > 1 [set x 1]
    ]

     set vValue ((phi * h) - (1 - phi) * (1 - h))
    set trustAccuracy accurateTrustCounter / ticks

    set-current-plot "veritistic Values"
    set-current-plot-pen "continuous OL"
    plotxy ticks vValue
    set-current-plot "trustworthiness Accuracies"
    set-current-plot-pen "continuous OL"
    plotxy 1 trustAccuracy
  ]

end

; Bovens & Hartmann agents with continuously defined reliability nodes
to updateConBH
  ask conBHs[
    if ((meanR > 0) and rel > 0.5) or (meanR = 0 and rel = 0.5)[set accurateTrustCounter accurateTrustCounter + 1]
    py:set "r" r
    py:set "meanR" meanR
    py:set "h" h

    ;*******************************************
    ;updating of M(r) and p(HYP)
    ifelse rep = true[
      (py:run
        "for x in range(len(r)):"
        "    r[x] = ((((x / res) * h + (1 - (x / res)) * rnd) / (meanR * h + rnd - meanR * rnd)) * r[x])"
        "h = (((meanR + rnd - meanR * rnd) * h) / (meanR * h + rnd - meanR * rnd))"
      )
    ][
      (py:run
        "for x in range(len(r)):"
        "    r[x] = ((((1 - h) * (x / res) + (1 - (x / res)) * (1 - rnd)) / (1 - (meanR * h + rnd - meanR * rnd))) * r[x])"
        "h = (((1 - (meanR + rnd - meanR * rnd))* h)/ (1 -(meanR * h + rnd - meanR * rnd)))"


      )
    ]

     (py:run
      "for x in range(len(r)):"
      "    if r[x]  == 0 :"
      "        r[x] = 0.0000000000001"

    )


    set r py:runresult "r"
    set h py:runresult "h"


    ifelse useWeightedMean[
      (py:run
        "meanR = 0"
        "for x in range(len(r)):"
        "    meanR = meanR + r[x] * x / res"
        "meanR = meanR / (res + 1)"
      )
    ][

      (py:run
        "meanR = 0"
        "for x in range(len(r)):"
        "    r[x] = r[x] * (x / res)"
        "for x in range(len(r)-1):"
        "    meanR = meanR + (min(r[x], r[x+1]) * (1 / res) + 0.5 * abs(r[x] - r[x+1]) * (1 / res))";* (x + 0.5) / res

    )
    ]

     set meanR py:runresult "meanR"


    if failsafeH[
      if h <= 0.0000000000001 [set h 0.000000000001]
      if h >= 0.9999999999999 [set h 0.999999999999]
    ]

    set-current-plot "continuous BH"
    set-current-plot-pen "mean REL"
    plotxy ticks meanR
    set-current-plot-pen "HYP"
    plotxy ticks h

    set-current-plot "current credense density distribution(s)"
    set-current-plot-pen "continuous BH (REL)"
    let x 0
    foreach r [
      y ->
      plotxy x y
      set x x + 1 / res
      if x > 1 [set x 1]
    ]

    set vValue ((phi * h) - (1 - phi) * (1 - h))
    set trustAccuracy accurateTrustCounter / ticks

    set-current-plot "veritistic Values"
    set-current-plot-pen "continuous BH"
    plotxy ticks vValue
    set-current-plot "trustworthiness Accuracies"
    set-current-plot-pen "continuous BH"
    plotxy 3 trustAccuracy
  ]

end

to updateConAL
  ask conALs[
    if ((meanA > 0.5 and meanC > 0) and rel > 0.5) or ((meanA < 0.5 and meanC > 0) and rel < 0.5) or ((meanA = 0.5 or meanC = 0) and rel = 0.5) [set accurateTrustCounter accurateTrustCounter + 1]
    py:set "a" a
    py:set "meanA" meanA
    py:set "c" c
    py:set "meanC" meanC
    py:set "h" h

    ifelse rep = true[
      (py:run
        "for x in range(len(a)):"
        "    a[x] = ((((h * meanC + rnd * (1 - meanC)) * (x / res) + ((1 - h) * meanC + rnd * (1 - meanC)) * (1 - (x / res))) / (h * meanC * meanA + (1 - h) * meanC * (1 - meanA) + rnd * (1 - meanC))) * a[x])"

        "for x in range(len(c)):"
        "    c[x] = ((((h * meanA + (1- h) * (1 - meanA)) * (x / res) + rnd * (1 - (x / res))) / (h * meanC * meanA + (1 - h) * meanC * (1 - meanA) + rnd * (1 - meanC))) * c[x])"

        "h = (((meanC * meanA + rnd * (1 - meanC)) * h)/(h * meanC * meanA + (1 - h) * (1 - meanA) * meanC + rnd * (1 - meanC)))"
      )
    ][
      (py:run
         "for x in range(len(a)):"
        "   a[x] = ((((1 - (h * meanC + rnd * (1 - meanC))) * (x / res) + (1 - ((1 - h) * meanC + rnd * (1 - meanC))) * (1 - (x / res))) / (1 - (h * meanC * meanA + (1 - h) * meanC * (1 - meanA) + rnd * (1 - meanC))))* a[x])"
        "for x in range(len(c)):"
        "    c[x] = (((((1 - (h * meanA + (1 - h) * (1 - meanA))) * (x / res)) + (1 - rnd) * (1 - (x / res)))/(1 - (h * meanC * meanA + (1 - h) * meanC * (1 - meanA) + rnd * (1 - meanC)))) * c[x])"
        "h = (((1 -(meanC * meanA + rnd * (1 - meanC))) * h)/(1 - (h * meanC * meanA + (1 - h) * (1 - meanA) * meanC + rnd * (1 - meanC))))"
      )
    ]


    (py:run
      "for x in range(len(c)):"
      "    if c[x] == 0 :"
      "        c[x] = 0.000000000001"
      "for x in range(len(a)):"
      "    if a[x] == 0 :"
      "        a[x] = 0.000000000001"
    )

    set a py:runresult "a"
    set c py:runresult "c"
    set h py:runresult "h"



    ifelse useWeightedMean[
      (py:run
        "meanA = 0"
        "for x in range(len(a)):"
        "    meanA = meanA + a[x] * x / res"
        "meanA = meanA / (res + 1)"
        "meanC = 0"
        "for x in range(len(c)):"
        "    meanC = meanC + c[x] * x / res"
        "meanC = meanC / (res + 1)"
      )
    ][

      (py:run
        "meanA = 0"
        "for x in range(len(a)):"
        "    a[x] = a[x] * (x / res)"
        "for x in range(len(a)-1):"
        "    meanA = meanA + (min(a[x], a[x+1]) * (1 / res) + 0.5 * abs(a[x] - a[x+1]) * (1 / res))"


        "meanC = 0"
        "for x in range(len(c)):"
        "    c[x] = c[x] * (x / res)"
        "for x in range(len(c)-1):"
        "    meanC = meanC + (min(c[x], c[x+1]) * (1 / res) + 0.5 * abs(c[x] - c[x+1]) * (1 / res))"

    )
    ]



    set meanA py:runresult "meanA"


    set meanC py:runresult "meanC"



    (py:run
      "for x in range(len(c)):"
      "    if c[x] <= 0.0000000000001 :"
      "        c[x] = 0.000000000001"

    "for x in range(len(a)):"
      "    if a[x] <= 0.0000000000001 :"
      "        a[x] = 0.000000000001"
    )



      if failsafeH[
      if h <= 0.0000000000001 [set h 0.000000000001]
      if h >= 0.9999999999999 [set h 0.999999999999]
    ]

    set-current-plot "continuous AL"
    set-current-plot-pen "mean AL"
    plotxy ticks meanA
    set-current-plot-pen "mean COM"
    plotxy ticks meanC
    set-current-plot-pen "HYP"
    plotxy ticks h

    set-current-plot "current credense density distribution(s)"
    set-current-plot-pen "continuous AL (AL)"
    let x 0
    foreach a [
      y ->
      plotxy x y
      set x x + 1 / res
      if x > 1 [set x 1]
    ]
    set-current-plot-pen "continuous AL (COM)"
    set x 0
    foreach c [
      y ->
      plotxy x y
      set x x + 1 / res
      if x > 1 [set x 1]
    ]
    set vValue ((phi * h) - (1 - phi) * (1 - h))
    set trustAccuracy accurateTrustCounter / ticks

    set-current-plot "veritistic Values"
    set-current-plot-pen "continuous AL"
    plotxy ticks vValue
    set-current-plot "trustworthiness Accuracies"
    set-current-plot-pen "continuous AL"
    plotxy 5 trustAccuracy
  ]

end


to updateConSD
  ask conSDs[
    if ((meanA * meanC + (1 - meanA) * (1 - meanC) > 0.5 and rel > 0.5) or ((meanA * meanC + (1 - meanA) * (1 - meanC) < 0.5) and rel < 0.5)) or (meanA * meanC + (1 - meanA) * (1 - meanC) = 0.5 and rel = 0.5)[set accurateTrustCounter accurateTrustCounter + 1]
    py:set "a" a
    py:set "meanA" meanA
    py:set "c" c
    py:set "meanC" meanC
    py:set "h" h

    ifelse rep = true[
      (py:run
        "for x in range(len(a)):"
        "    a[x] = ((((h * meanC + (1 - h) * (1 - meanC)) * (x / res) + (h * (1 - meanC) + (1 - h) * meanC) * (1 - (x / res))) / (h * meanC * meanA + (1 - h) * (1 - meanC) * meanA + h * (1 - meanC) * (1 - meanA) + (1 - h) * meanC * (1 - meanA))) * a[x])"
        "for x in range(len(c)):"
        "    c[x] = ((((h * meanA + (1 - h) * (1 - meanA))* (x / res) + ((1 - h) * meanA + h * (1 - meanA)) * (1 - (x / res))) / (h * meanC * meanA + (1 - h) * (1 - meanC) * meanA + h * (1 - meanC) * (1 - meanA) + (1 - h) * meanC * (1 - meanA))) * c[x])"
        "h = (((meanC * meanA + (1 - meanA) * (1 - meanC)) * h) / (h * meanC * meanA + (1 - h) * (1 - meanC) * meanA + h * (1 - meanC) * (1 - meanA) + (1 - h) * meanC * (1 - meanA)))"
      )
    ][
      (py:run
         "for x in range(len(a)):"
        "   a[x] = ((((1 - (h * meanC + (1 - h) * (1 - meanC))) * (x / res) + (1 - (h * (1 - meanC) + (1 - h) * meanC)) * (1 - (x / res))) / (1 - (h * meanC * meanA + (1 - h) * (1 - meanC) * meanA + h * (1 - meanC) * (1 - meanA) + (1 - h) * meanC * (1 - meanA)))) * a[x])"
        "for x in range(len(c)):"
        "    c[x] = ((((1 - (h * meanA + (1 - h) * (1 - meanA)))* (x / res) + (1 - ((1 - h) * meanA + h * (1 - meanA))) * (1 - (x / res))) / (1 - (h * meanC * meanA + (1 - h) * (1 - meanC) * meanA + h * (1 - meanC) * (1 - meanA) + (1 - h) * meanC * (1 - meanA)))) * c[x])"
        "h = (((1 -(meanC * meanA + (1 - meanA) * (1 - meanC))) * h)/(1 - (h * meanC * meanA + (1 - h) * (1 - meanC) * meanA + h * (1 - meanC) * (1 - meanA) + (1 - h) * meanC * (1 - meanA))))"
      )
    ]

    (py:run
      "for x in range(len(c)):"
      "    if c[x] == 0 :"
      "        c[x] = 0.000000000001"
      "for x in range(len(a)):"
      "    if a[x] == 0 :"
      "        a[x] = 0.000000000001"
    )

    set a py:runresult "a"
    set c py:runresult "c"
    set h py:runresult "h"


    ifelse useWeightedMean[
      (py:run
        "meanA = 0"
        "for x in range(len(a)):"
        "    meanA = meanA + a[x] * x / res"
        "meanA = meanA / (res + 1)"
        "meanC = 0"
        "for x in range(len(c)):"
        "    meanC = meanC + c[x] * x / res"
        "meanC = meanC / (res + 1)"
      )
    ][

      (py:run
        "meanA = 0"
        "for x in range(len(a)):"
        "    a[x] = a[x] * (x / res)"
        "for x in range(len(a)-1):"
        "    meanA = meanA + (min(a[x], a[x+1]) * (1 / res) + 0.5 * abs(a[x] - a[x+1]) * (1 / res))"
        "meanC = 0"
        "for x in range(len(c)):"
        "    c[x] = c[x] * (x / res)"
        "for x in range(len(c)-1):"
        "    meanC = meanC + (min(c[x], c[x+1]) * (1 / res) + 0.5 * abs(c[x] - c[x+1]) * (1 / res))"
      )
    ]

    set meanA py:runresult "meanA"
    set meanC py:runresult "meanC"

    if failsafeH[
      if h <= 0.0000000000001 [set h 0.000000000001]
      if h >= 0.9999999999999 [set h 0.999999999999]
    ]

    set-current-plot "continuous SD"
    set-current-plot-pen "mean AL"
    plotxy ticks meanA
    set-current-plot-pen "mean COM"
    plotxy ticks meanC
    set-current-plot-pen "HYP"
    plotxy ticks h

    set-current-plot "current credense density distribution(s)"
    set-current-plot-pen "continuous SD (AL)"
    let x 0
    foreach a [
      y ->
      plotxy x y
      set x x + 1 / res
      if x > 1 [set x 1]
    ]
    set-current-plot-pen "continuous SD (COM)"
    set x 0
    foreach c [
      y ->
      plotxy x y
      set x x + 1 / res
      if x > 1 [set x 1]
    ]

    set vValue ((phi * h) - (1 - phi) * (1 - h))
    set trustAccuracy accurateTrustCounter / ticks

    set-current-plot "veritistic Values"
    set-current-plot-pen "continuous SD"
    plotxy ticks vValue
    set-current-plot "trustworthiness Accuracies"
    set-current-plot-pen "continuous SD"
    plotxy 7 trustAccuracy
  ]

end



@#$#@#$#@
GRAPHICS-WINDOW
1173
659
1211
698
-1
-1
10.0
1
10
1
1
1
0
1
1
1
-1
1
-1
1
0
0
1
ticks
30.0

BUTTON
1237
661
1310
694
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1315
661
1378
694
NIL
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1516
660
1689
693
alpha
alpha
0
1
0.6
0.1
1
NIL
HORIZONTAL

SLIDER
1516
698
1689
731
kappa
kappa
0
1
0.8
0.1
1
NIL
HORIZONTAL

SLIDER
1517
737
1689
770
phi
phi
0
1
1.0
1
1
NIL
HORIZONTAL

SWITCH
1172
784
1332
817
manualReporting
manualReporting
1
1
-1000

PLOT
1170
10
1688
652
current credense density distribution(s)
credence
credence density
0.0
1.0
0.0
0.0
true
true
"" ""
PENS
"continuous OL (REL)" 1.0 0 -13345367 true "" ""
"continuous BH (REL)" 1.0 0 -2674135 true "" ""
"continuous AL (AL)" 1.0 0 -10899396 true "" ""
"continuous AL (COM)" 1.0 0 -1184463 true "" ""
"continuous SD (AL)" 1.0 0 -8630108 true "" ""
"continuous SD (COM)" 1.0 0 -2064490 true "" ""

SWITCH
1173
708
1282
741
report?
report?
1
1
-1000

SLIDER
186
770
358
803
priorHyp
priorHyp
0
1
0.5
0.1
1
NIL
HORIZONTAL

SLIDER
403
770
575
803
rnd
rnd
0
1
0.5
0.1
1
NIL
HORIZONTAL

PLOT
300
10
547
331
Boolean BH
ticks
credence
0.0
1.0
0.0
1.0
true
true
"" ""
PENS
"HYP" 1.0 0 -13840069 true "" ""
"REL" 1.0 0 -13345367 true "" ""

PLOT
6
334
297
652
continuous OL
ticks
credence
0.0
0.0
0.0
1.0
true
true
"" ""
PENS
"HYP" 1.0 0 -13840069 true "" ""
"mean REL" 1.0 0 -13345367 true "" ""

SWITCH
185
660
293
693
conOL?
conOL?
0
1
-1000

PLOT
6
10
260
331
Boolean OL
ticks
credence
0.0
0.0
0.0
1.0
true
true
"" ""
PENS
"HYP" 1.0 0 -13840069 true "" ""
"REL" 1.0 0 -13345367 true "" ""

SWITCH
8
658
107
691
boolOL?
boolOL?
0
1
-1000

SWITCH
1172
746
1338
779
useWeightedMean
useWeightedMean
1
1
-1000

SWITCH
300
659
402
692
boolBH?
boolBH?
0
1
-1000

PLOT
585
10
836
330
Boolean AL
ticks
credence
0.0
1.0
0.0
1.0
true
true
"" ""
PENS
"HYP" 1.0 0 -13840069 true "" ""
"AL" 1.0 0 -2674135 true "" ""
"COM" 1.0 0 -11221820 true "" ""

SWITCH
586
659
688
692
boolAL?
boolAL?
0
1
-1000

SWITCH
877
657
991
690
boolSD?
boolSD?
0
1
-1000

PLOT
876
10
1136
330
Boolean SD
ticks
credence
0.0
1.0
0.0
1.0
true
true
"" ""
PENS
"HYP" 1.0 0 -13840069 true "" ""
"AL" 1.0 0 -2674135 true "" ""
"COM" 1.0 0 -11221820 true "" ""

PLOT
300
334
582
652
continuous BH
ticks
credence
0.0
1.0
0.0
1.0
true
true
"" ""
PENS
"HYP" 1.0 0 -13840069 true "" ""
"mean REL" 1.0 0 -13345367 true "" ""

SWITCH
470
658
580
691
conBH?
conBH?
0
1
-1000

SWITCH
767
657
866
690
conAL?
conAL?
0
1
-1000

SWITCH
1055
658
1165
691
conSD?
conSD?
0
1
-1000

PLOT
585
334
873
652
continuous AL
ticks
credence
0.0
1.0
0.0
1.0
true
true
"" ""
PENS
"HYP" 1.0 0 -13840069 true "" ""
"mean AL" 1.0 0 -2674135 true "" ""
"mean COM" 1.0 0 -11221820 true "" ""

PLOT
876
334
1167
652
continuous SD
ticks
credence
0.0
1.0
0.0
1.0
true
true
"" ""
PENS
"HYP" 1.0 0 -13840069 true "" ""
"mean AL" 1.0 0 -2674135 true "" ""
"mean COM" 1.0 0 -11221820 true "" ""

INPUTBOX
8
696
69
756
relOL
0.68
1
0
Number

INPUTBOX
71
696
135
756
alphaOL
2.125
1
0
Number

INPUTBOX
138
696
202
756
betaOL
1.0
1
0
Number

INPUTBOX
300
696
366
756
relBH
0.36
1
0
Number

INPUTBOX
368
696
430
756
alphaBH
1.0
1
0
Number

INPUTBOX
431
696
504
756
betaBH
1.77777
1
0
Number

INPUTBOX
586
758
648
818
comAL
0.6
1
0
Number

INPUTBOX
586
695
652
755
alAL
0.8
1
0
Number

INPUTBOX
1351
705
1424
765
res
1000.0
1
0
Number

INPUTBOX
724
695
798
755
alBetaAL
1.0
1
0
Number

INPUTBOX
656
695
722
755
alAlphaAL
4.0
1
0
Number

INPUTBOX
652
759
731
819
comAlphaAL
1.5
1
0
Number

INPUTBOX
732
759
808
819
comBetaAL
1.0
1
0
Number

INPUTBOX
878
695
930
755
alSD
0.8
1
0
Number

INPUTBOX
878
759
944
819
comSD
0.8
1
0
Number

INPUTBOX
933
695
1019
755
alAlphaSD
4.0
1
0
Number

INPUTBOX
1020
696
1094
756
alBetaSD
1.0
1
0
Number

INPUTBOX
945
759
1033
819
comAlphaSD
4.0
1
0
Number

INPUTBOX
1036
759
1114
819
comBetaSD
1.0
1
0
Number

BUTTON
1382
661
1445
694
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1691
10
2139
502
veritistic Values
ticks
veritistic Value
0.0
1.0
0.0
1.0
true
true
"" ""
PENS
"Boolean OL" 1.0 0 -13791810 true "" ""
"continuous OL" 1.0 0 -13840069 true "" ""
"Boolean BH" 1.0 0 -8630108 true "" ""
"continuous BH" 1.0 0 -5825686 true "" ""
"Boolean AL" 1.0 0 -2064490 true "" ""
"continuous AL" 1.0 0 -2674135 true "" ""
"Boolean SD" 1.0 0 -955883 true "" ""
"continuous SD" 1.0 0 -6459832 true "" ""

PLOT
1691
505
2139
819
trustworthiness Accuracies
agents
percent
0.0
8.0
0.0
1.0
false
true
"" ""
PENS
"Boolean OL" 1.0 1 -13791810 true "" ""
"continuous OL" 1.0 1 -13840069 true "" ""
"Boolean BH" 1.0 1 -8630108 true "" ""
"Continuous BH" 1.0 1 -5825686 true "" ""
"Boolean AL" 1.0 1 -2064490 true "" ""
"continuous AL" 1.0 1 -2674135 true "" ""
"Boolean SD" 1.0 1 -955883 true "" ""
"continuous SD" 1.0 1 -6459832 true "" ""

MONITOR
1390
774
1457
819
last REP
rep
1
1
11

INPUTBOX
1435
704
1500
764
ticksLimit
1000.0
1
0
Number

MONITOR
1624
774
1689
819
reliability
rel
4
1
11

SWITCH
8
769
127
802
failsafeH
failsafeH
1
1
-1000

MONITOR
1512
774
1592
819
report ratio
repCounter / ticks
3
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
