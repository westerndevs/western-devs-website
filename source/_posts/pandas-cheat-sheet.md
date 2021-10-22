---
title:  Pandas Cheat Sheet
# Read a file 
# Get a summary of the data 
# Create a new column from combining with another 
# Filter data rows 
authorId: simon_timms
date: 2021-10-22
originalurl: https://blog.simontimms.com/2021/10/22/pandas-cheat-sheet
mode: public
---



Part of an evolving cheat sheet

## Read a file 

For CSV use 

```
data = pd.read_csv('data.csv')
```

## Get a summary of the data 

Numerical summaries 

```
data.describe()
```

Types of columns 

```
data.dtypes
```

## Create a new column from combining with another 

This adds up values in two columns 

```
data["totalqueuelength"] = data["Svc"] + data["Svc Que"]
```

This converts a couple of columns that have the data and time to a single field and turns it into a date 

```
data["datetime"] = pd.to_datetime(data["Date"] + " " + data["Time"], format='%m/%d/%Y %I:%M %p')
```
Check date formats at https://docs.python.org/3/library/datetime.html#strftime-and-strptime-behavior

## Filter data rows 

```
data.loc[(data['datetime'] > '2021-10-16')]
```