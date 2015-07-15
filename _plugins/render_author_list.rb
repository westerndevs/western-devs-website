require 'digest/md5'
require 'uri'

module Jekyll
  module AuthorFilter
    def to_author_list(input)
      url = @context.registers[:site].config['url']
      author_list = @context.registers[:site].data["authors"]
      input.split(',').map{|x| "<a href='#{url}/bios/#{x}''>#{author_list[x]['name']}</a>"}.join(', ')
    end

  end
end

Liquid::Template.register_filter(Jekyll::AuthorFilter)