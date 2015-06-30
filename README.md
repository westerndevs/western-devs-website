# Western Devs Website

The website for [WesternDevs](http://www.westerndevs.com)

Run `bundle install` to start off.

Useful commands:

* `rake serve`: Serves up the website on your local machine (assuming Jekyll and Rake are installed). Will not show draft posts but links will be properly addressed for your local machine
* `rake serve["drafts"]`: Same as `rake serve` but includes draft posts
* `octopress new draft "Draft Title"`: Creates a new draft based on the specified title. You'll need to set the author and original URL.
* `octopress new post "Post Title"`: Same as the previous command except it creates a post
* `octopress publish moo`: Moves the post titled "moo" from _drafts to _posts. If there is more than one draft with "moo" in the title, it will give you a list to choose from.
