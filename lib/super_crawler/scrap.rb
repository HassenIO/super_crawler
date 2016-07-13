require "open-uri"
require "nokogiri"

module SuperCrawler

  ###
  # Scrap a single HTML page
  # Responsible for extracting all relevant information within a page
  # (internal links and assets)
  #
  class Scrap

    attr_reader :url

    def initialize url
      # Normalize the URL, by adding a scheme (http) if not present in the URL
      @url = URI.encode( !!(url =~ /^(http(s)?:\/\/)/) ? url : ('http://' + url) )
    end

    ###
    # Get INTERNAL links of the page (same host)
    #
    def get_links
      return [] unless page_exists?

      # Get all the links that are within <a> tag, using Nokogiri
      links = get_doc.css('a').map{ |link| link['href'] }.compact

      # Select only internal links (relative links, or absolute links with the same host)
      links.select!{ |link| URI.parse(URI.encode link).host.nil? || link.start_with?( @url ) }

      # Reject bad matches links (like mailto, tel and javascript)
      links.reject!{ |link| !!(link =~ /^(mailto:|tel:|javascript:)/) }

      # Clean the links
      links.map!{ |link| create_absolute_url( link ) } # Make all links absolute
           .map!{ |link| link.split('#')[0] } # Remove the fragment part from the links (...#...) if any
           .map!{ |link| URI(URI.encode link).normalize().to_s } # Normalize links

      return links.uniq # Return links without duplicates
    end

    ###
    # Get all the images within a page
    # NOTA: These are images within <img src="..." /> tag.
    #
    def get_images
      return [] unless page_exists?

      # Get all the images sources (URLs), using Nokogiri
      images_links = get_doc.css('img').map{ |image| image['src'] }.compact

      # Create the absolute path of the images
      images_links.map!{ |image| create_absolute_url( image ) }

      return images_links.uniq # Return links to images without duplicates
    end

    ###
    # Get all the CSS links within a page
    # NOTA: These are links within <link href="..." /> tag.
    #
    def get_stylesheets
      return [] unless page_exists?

      # Get all the stylesheet links (URLs), using Nokogiri
      css_links = get_doc.css('link').select{ |css_link| css_link['rel'] == 'stylesheet' }
                                     .map{ |css_link| css_link['href'] }
                                     .compact

      # Create the absolute path of the CSS links
      css_links.map!{ |css_link| create_absolute_url( css_link ) }

      return css_links.uniq # Return links to CSS files without duplicates
    end

    ###
    # Get all the JS scripts within a page
      # NOTA: These are scripts within <script src="..." /> tag.
    #
    def get_scripts
      return [] unless page_exists?

      # Get all the script sources (URLs), using Nokogiri
      scripts_links = get_doc.css('script').map{ |script| script['src'] }.compact

      # Create the absolute path of the scripts
      scripts_links.map!{ |script| create_absolute_url( script ) }

      return scripts_links.uniq # Return links to scripts without duplicates
    end

    ###
    # Get all assets within a page
    # Returns a hash of images, stylesheets and scripts URLs
    #
    def get_assets
      {
        :'images' => get_images,
        :'stylesheets' => get_stylesheets,
        :'scripts' => get_scripts
      }
    end

    ###
    # Get links and assets within a page
    # Returns a hash of links, images, stylesheets and scripts URLs
    #
    def get_all
      {
        :'links' => get_links,
        :'images' => get_images,
        :'stylesheets' => get_stylesheets,
        :'scripts' => get_scripts
      }
    end

    ###
    # Check if the page exists
    #
    def page_exists?
      !!( get_doc rescue false )
    end

    private

    ###
    # Get the page `doc` (document) from Nokogiri.
    # Cache it for performace issue.
    #
    def get_doc
      begin
        @doc ||= Nokogiri(open( @url ))
      rescue Exception => e
        raise "Problem with URL #{@url}: #{e}"
      end
    end

    ###
    # Given a URL, return the absolute URL
    #
    def create_absolute_url url
      # Append the base URL (scheme+host) if the provided URL is relative
      URI.parse(URI.encode url).host.nil? ? "#{URI.parse(@url).scheme}://#{URI.parse(@url).host}#{url}" : url
    end

  end

end
