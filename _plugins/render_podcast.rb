module Jekyll
  class RenderPodcastTag < Liquid::Tag

    def initialize(tag_name, podcast, tokens )
      super
      @podcast = podcast
    end

    def render(context)
      podcast = Liquid::Template.parse(@podcast).render context
      "
 <audio controls>
	<source src='http://cdn.westerndevs.com/podcasts/#{podcast}' type='audio/mpeg'>
    Your browser does not support the audio element.
</audio>"
    end
  end

end

Liquid::Template.register_tag('render_podcast', Jekyll::RenderPodcastTag)
