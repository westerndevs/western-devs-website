require 'digest/md5'
require 'uri'

module Jekyll
  module AuthorFilter
    def to_author_list(input)
      input.split(',').map do |x|
        get_author_link x 
      end.join(', ')
    end

    def find_author_id(author)
      @context.registers[:site].data["authors"].find { |k, v| v == author}[0]
    end
    
    private 
    def get_author_link(author_token)
      url = @context.registers[:site].config['url']
      author = @context.registers[:site].data["authors"][author_token]
      "<a href='#{url}/bios/#{author_token}'>#{author['name']}</a>"
    end

  end

  module PostFilter
    def filter_by_author(posts, author)
      filtered_posts = []
      for post in posts
        found_author = post["participants"].find { |v| v == author }
        if found_author
          filtered_posts.push(post)
        end
      end
      filtered_posts
    end
  end

  module PublicationFilter
    def filter_work_by_author(publications, author)
      # books = @context.registers[:site].data["publications"]["books"].find { |v| v["author"] == author }
      books = publications["books"].find{ |v| v["author"] == author}
      works = []
      if books
        puts "Book: " + books["title"].to_s
        for book in books
          works.push(book)
        end 
      end
      works
    end
  end
end

Liquid::Template.register_filter(Jekyll::AuthorFilter)
Liquid::Template.register_filter(Jekyll::PostFilter)
Liquid::Template.register_filter(Jekyll::PublicationFilter)

