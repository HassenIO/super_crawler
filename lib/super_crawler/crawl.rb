require 'thread'

require 'super_crawler/scrap'
require 'super_crawler/render'

module SuperCrawler

  ###
  # Crawl a whole website
  # For each new link detected, scrap the corresponding page.
  #
  class Crawl

    attr_reader :links, :crawl_results

    def initialize start_url, options = {}
      @start_url = URI(URI.encode start_url).normalize().to_s # Normalize the given URL
      @links = [@start_url] # Will contain the list of all links found
      @crawl_results = [] # Will contain the crawl results (links and assets), as array of hashes

      @option_debug = options[:debug].nil? ? true : !!(options[:debug]) # Debug by default
    end

    ###
    # Start crawling site
    # Could take a while! Use threads to speed up crawling and log to inform user.
    #
    def start threads_count = 10

      SuperCrawler::Render.crawling_start_notice( @start_url, threads_count ) if @option_debug # Show message on what will happen

      threads = []              # Will contain our n-threads
      @links_queue = Queue.new  # Will contain the links queue that the threads will use
      @links = [@start_url]     # Re-init the links list
      @crawl_results = []       # Re-init the crawling results

      start_time = Time.now if @option_debug # Start the timer

      # Let's populate our queue with links and resources from source url
      process_page( @start_url )

      # Create threads to handle new links
      threads_count.times do # Create threads_count threads

        threads << Thread.new do # Instantiate a new threads
          begin
            while current_link = @links_queue.pop(true) # Pop one link after another
              process_page( current_link ) # Get links and assets of the popped link
            end
          rescue ThreadError # Stop when empty links queue
          end
        end

      end

      threads.map(&:join) # Activate the threads
      SuperCrawler::Render.crawling_summary_notice(Time.now - start_time, threads_count, @links.count) if @option_debug # Display crawling summary

      return true
    end

    ###
    # Render the crawling result as a sitemap in the console
    #
    def render max_pages = 10
      SuperCrawler::Render.console( @crawl_results, max_pages )
    end

    ###
    # Get specific assets (images, stylesheets and scripts)
    #
    def get_assets asset
      return [] if @crawl_results.empty? # No crawling yet? Return empty search

      # The asset parameter can only be images, stylesheets or scripts
      unless %w(images stylesheets scripts).include? asset.to_s
        # Display error message in this case.
        SuperCrawler::Render.error "`asset` parameter can only be `images`, `stylesheets` or `scripts`"
        return [] # Return empty array
      end

      # Good! Return flatten array of unique assets
      return @crawl_results.map{ |cr| cr[:assets][asset.to_sym] }.flatten.uniq
    end

    private

    ###
    # Process a page by extracting information and updating links queue,
    # links list and results.
    #
    def process_page page_url
      page = SuperCrawler::Scrap.new(page_url) # Scrap the current page

      current_page_links = page.get_links # Get current page internal links
      new_links = current_page_links - @links # Select new links

      new_links.each { |link| @links_queue.push(link) } # Add new links to the queue
      @links += new_links # Add new links to the links list
      @crawl_results << { # Provide current page crawl result as a hash
        url: page.url, # The crawled page
        links: current_page_links, # Its internal links
        assets: page.get_assets # Its assets
      }

      SuperCrawler::Render.log_status( page_url, @crawl_results.length, @links.length ) if @option_debug # Display site crawling status
    end

  end

end
