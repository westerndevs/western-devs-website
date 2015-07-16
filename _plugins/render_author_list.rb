require 'digest/md5'
require 'uri'

module Jekyll
  module AuthorFilter
    def to_author_list(input)
      input.split(',').map do |x|
        get_author_link x 
      end.join(', ')
    end

    private 
    def get_author_link(author_token)
      url = @context.registers[:site].config['url']
      author = @context.registers[:site].data["authors"][author_token]
      "<a href='#{url}/bios/#{author_token}'>#{author['name']}</a>"
    end
  end
end

Liquid::Template.register_filter(Jekyll::AuthorFilter)