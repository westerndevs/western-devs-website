'use strict';

hexo.extend.generator.register('author-list-json', function(locals) {

  var authorList = [];
  var authorKeys = Object.keys(locals.data.authors);
  for (var i = 0; i < authorKeys.length; i++) {
    var authorId = authorKeys[i];
    var author = locals.data.authors[authorId];
    if (author.active) {
      author.authorId = authorId;
      authorList.push(author);
    }
  }

  return {
    path: 'api/authorList.json',
    data: JSON.stringify(authorList)
  }
})
