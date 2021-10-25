---
title:  Reading a TSV file in Pandas
authorId: simon_timms
date: 2021-10-25
originalurl: https://blog.simontimms.com/2021/10/25/pandas-read-tsv
mode: public
---



Pretty easy, just use the csv loader with a different record separator

```
data = pd.read_csv('work/data.tsv', sep='\t')
```

You can tell it explicitly to use the first column as the header

```
data = pd.read_csv('work/data.tsv', sep='\t', header=0)
```

I also found that it interpreted my first column as an index which I didn't want (it offset all the columns by one)

```
data = pd.read_csv('work/data.tsv', sep='\t', header=0, index_col=False)
```