require 'digest/md5'
require 'uri'

module Jekyll
  module GravatarFilter
    def to_gravatar(input, size=200)
      default_img = CGI.escape("http://www.westerndevs.com/images/luchador.png")
      "//www.gravatar.com/avatar/#{hash(input)}?s=#{size}&d=#{default_img}"
    end

    private :hash

    def hash(email)
      email_address = email ? email.downcase.strip : ''
      Digest::MD5.hexdigest(email_address)
    end
  end
end

Liquid::Template.register_filter(Jekyll::GravatarFilter)