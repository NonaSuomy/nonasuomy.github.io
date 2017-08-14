module Jekyll
  class PlaceAds < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      "<div>
       <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
       <ins class="adsbygoogle"
         style="display:block; text-align:center;"
         data-ad-format="fluid"
         data-ad-layout="in-article"
         data-ad-client="ca-pub-6522065888169039"
         data-ad-slot="8755974884"></ins>
       <script>
         (adsbygoogle = window.adsbygoogle || []).push({});
      </script>
      </div>"
    end
  end
end

Liquid::Template.registertag('placeads', Jekyll::PlaceAds)
