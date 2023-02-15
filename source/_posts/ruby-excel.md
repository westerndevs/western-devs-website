---
title:  Excel and Ruby
# Spreadsheet
# RubyXL
# CAXLSX
# Fast Excel
authorId: simon_timms
date: 2023-02-15
originalurl: https://blog.simontimms.com/2023/02/15/ruby-excel
mode: public
---



Excel is the king of spreadsheets and I often find myself in situation where I have to write our Excel files in an application. I'd say that as an application grows the probability of needing Excel import or export approaches 1. Fortunately, there are lots of libraries out there to help with Excel across just about every language. The quality and usefuleness of these libraries varies a lot. In Ruby land there seem to be a few options.

## Spreadsheet

https://github.com/zdavatz/spreadsheet/

As the name suggests this library deals with Excel spreadsheets. It is able to both read and write them by using Spreadsheet::Excel Library and the ParseExcel Library. However it only supports the older XLS file format. While this is still widely used it is not the default format for Excel 2007 and later. I try to stay clear of the format as much as possible. There have not been any releases of this library in about 18 months but there haven't been any releases of the XLS file format for decades so it doesn't seem like a big deal. 

The library can be installed using 

```
gem install spreadsheet
```

Then you can use it like so

```ruby
require 'spreadsheet'

workbook = Spreadsheet.open("test.xls")
worksheet = workbook.worksheet 0
worksheet.rows[1][1] = "Hello there!"
workbook.write("test2.xls")
```

There are some limitations around editing files such as cell formats not updating but for most things it should be fine. 

## RubyXL

https://github.com/weshatheleopard/rubyXL

This library works on the more modern XLSX file formats. It is able to read and write files with modifications. However there are some limitations such as being unable to insert images 

```ruby
require 'rubyXL'

  # only do this if you don't care about memory usage, otherwise you can load submodules separately
  # depending on what you need
require 'rubyXL/convenience_methods'

workbook = RubyXL::Parser.parse("test.xlsx")
worksheet = workbook[0]
cell = worksheet.cell_at('A1')
cell.change_contents("Hello there!")
workbook.write("test2.xlsx")
```

## CAXLSX

https://github.com/caxlsx/caxlsx

This library is the community supported version of AXLSX. It is able to generate XLSX files but not read them or modify them. There is rich support for charts, images and other more advanced excel features. The 

Install using 

```
gem install caxlsx
```

And then a simple example looks like

```ruby
require 'axlsx'

p = Axlsx::Package.new
workbook = p.workbook

wb.add_worksheet(name: 'Test') do |sheet|
  sheet.add_row ['Hello there!']
end

p.serialize "test.xlsx"

```

Of all the libraries mentioned here the documentation for this one is the best. It is also the most actively maintained. The examples directory https://github.com/caxlsx/caxlsx/tree/master/examples gives a plethora of examples of how to use the library.


## Fast Excel

https://github.com/Paxa/fast_excel

This library focuses on being the fastest excel library for ruby. It is actually written in C to speed it up so comes with all the caveats about running native code. Similar to CAXLSX it is only able to read and write files and not modify them. 

```ruby
require 'fast_excel'

  # constant_memory: true streams changes to disk so it means that you cannot
  # modify an already written record
workbook = FastExcel.open("test.xlsx", constant_memory: true)
worksheet = workbook.add_worksheet("Test")

bold = workbook.bold_format
worksheet.set_column(0, 0, FastExcel::DEF_COL_WIDTH, bold)
worksheet << ["Hello World"]
workbook.close
```

As you can see here the library really excels at adding consistently shaped rows. You're unlikely to get a complex spreadsheet with headers and footers built using this tooling. 