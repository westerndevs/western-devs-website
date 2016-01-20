---
layout: post
title:  "Custom MVC6 Tag Helper Samples"
date: 2015-09-20T17:20:00-04:00
categories:
comments: true
authorId: dave_paquette
originalurl: http://www.davepaquette.com/archive/2015/09/20/custom-mvc-6-tag-helper-samples.aspx
---
A group of us who have been exploring MVC 6 Tag Helpers have created a repository of [Tag Helper Samples](https://github.com/dpaquette/TagHelperSamples). The repository contains a set of real world samples that can help you understand how to build your own custom tag helpers.

<!--more-->
  
So far, we have been focusing on Tag Helpers that make it easier to use various Bootstrap components. We chose Bootstrap because Bootstrap components are often verbose and it can be easy to miss a particular class or a specific attribute. I find that this is especially when you consider all the accessibility _aria-*_ attributes. So far, we have implemented tag helpers for Bootstrap [Alerts](http://getbootstrap.com/components/#alerts), [Progress Bars](http://getbootstrap.com/components/#progress) and most recently [Modals](http://getbootstrap.com/javascript/#modals).

## Alert

The [alert tag helper](https://github.com/dpaquette/TagHelperSamples/blob/master/TagHelperSamples/src/TagHelperSamples/TagHelpers/AlertTagHelper.cs), contributed by Rick Strahl, makes it easy to display Bootstrap alerts containing Font-Awesome icons.

```
<alert message="Payment has been processed." icon="success">
</alert>
```

Will output the following HTML:

```
<div class="alert alert-success" role="alert">
  <i class="fa fa-check"></i> Payment has been processed.
</div>
```

## Progress Bar

Displaying a progress bar in Bootstrap is a rather verbose set of elements and attributes:

```
<div class="progress">
  <div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
    <span class="sr-only">60% Complete</span>
  </div>
</div>
```
The [progress bar tag helper](https://github.com/dpaquette/TagHelperSamples/blob/master/TagHelperSamples/src/TagHelperSamples/TagHelpers/ProgressBarTagHelper.cs) provides a much cleaner syntax:

```
<div bs-progress-value="66">
</div>
```

## Modal

Bootstrap modals are also rather convoluted items. The simplest possible modal consists of too many nested divs and in my opinion is hard to read:

```
<div class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Modal title</h4>
      </div>
      <div class="modal-body">
        <p>One fine body&hellip;</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
```

The same modal using the [modal tag helper](https://github.com/dpaquette/TagHelperSamples/blob/master/TagHelperSamples/src/TagHelperSamples/TagHelpers/ModalTagHelper.cs) is much easier to read and will produce the same output:

```
<modal id="simpleModal" title="Modal Title" >
    <modal-body>
        <p>One fine body&hellip;</p>
    </modal-body>
    <modal-footer>
        <button type="button" class="btn btn-primary">Save changes</button>
    </modal-footer>
</modal>
```

## Wrapping it up

Feel free to browse the [sample code](https://github.com/dpaquette/TagHelperSamples/tree/master/TagHelperSamples/src/TagHelperSamples/TagHelpers) or [view them in action on Azure](http://taghelpersamples.azurewebsites.net/). If you have ideas for other Tag Helpers, feel free to [log an issue](https://github.com/dpaquette/TagHelperSamples/issues) in the repo. Better yet, you could also submit a pull request.

A big thank you to [Rick Anderson](https://twitter.com/RickAndMSFT) for suggesting this and getting us started and to [Rick Strahl](http://weblog.west-wind.com/) for contributing.
