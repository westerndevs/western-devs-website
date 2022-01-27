---
title:  Pandas Cheat Sheet
# Read a file 
# Get a summary of the data 
# Create a new column from combining with another 
# Create a new column from a function
# Binning 
# Average a column 
# Find row at an index 
# Filter data rows 
# Sort 
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

For excel use 

```
df = pd.read_excel (r'./Detected as deleted from API data.xlsx')
```

You might need to install a library for xlsx files 

```
pip install openpyxl
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

## Create a new column from a function

```
df = df.assign(percent=lambda x: 100* x['deleted on date'] / x['total'])
```

## Binning 

You can bin the data by adding a new bin column to the dataframe

```
df['binning'] = pd.cut(df['percent'], 5) # 5 bins based on the percent column
```

## Average a column 

```
df['column'].mean()
```

## Find row at an index 

```
df.iloc[[int(totalRecords * .95)]] # Find the row at the 95th percentile
```

## Filter data rows 

```
data.loc[(data['datetime'] > '2021-10-16')]
```

## Sort 

```
df.sort_values(by=['percent'], ascending=False)
```