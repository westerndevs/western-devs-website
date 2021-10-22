---
title:  Mathplotlib cheat sheet
# Include the library 
# Set the plot size to be larger
# Set plot title
# Plot a line chart 
# Add Legend
authorId: simon_timms
date: 2021-10-22
originalurl: https://blog.simontimms.com/2021/10/22/matplotlib-cheat-sheet
mode: public
---



Part of an evolving cheat sheet

## Include the library 

```
import matplotlib.pyplot as plt
```

## Set the plot size to be larger

```
plt.rcParams['figure.figsize'] = [30, 21]
```

## Set plot title

```
plt.title("some title)
```

## Plot a line chart 

```
  plt.plot(filtered['datetime'], filtered['totalsales'], label="Sales Ingest")
  plt.show()
```

## Add Legend

```
plt.legend()
```