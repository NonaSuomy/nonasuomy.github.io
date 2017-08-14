module Jekyll
  class PlaceAds < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      "#{@text}"
    end
  end
end

Liquid::Template.registertag('placeads', Jekyll::PlaceAds)
