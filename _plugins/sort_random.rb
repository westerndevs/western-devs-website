module Jekyll
  module RandomSortFilter
    def sort_random(input)
      input.sort_by{rand}
    end
  end
end

Liquid::Template.register_filter(Jekyll::RandomSortFilter)