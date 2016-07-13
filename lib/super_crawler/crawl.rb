require 'thread'

require 'super_crawler/scrap'

module SuperCrawler

  ###
  # Crawl a whole website
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

      crawling_start_notice( @start_url, threads_count ) # Show message on what will happen
      threads = [] # Will contain our n-threads
      @links_queue = Queue.new # Will contain the links queue that the threads will use
      @links = [@start_url] # Re-init the links list
      @crawl_results = [] # Re-init the crawling results

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
      crawling_summary_notice(start_time, Time.now, threads_count) if @option_debug # Display crawling summary

      return true
    end

    ###
    # Render sitemap
    # Show, for each link, internal links and assets
    # We will limit pages to display, because some sites have more than 1,000 pages
    #
    def render max_pages = 10
      draw_line
      puts "Showing first #{max_pages} crawled pages and their contents:\n\n"
      @crawl_results[0..(max_pages-1)].each_with_index do |result, index|
        puts "[#{index+1}] Content of #{result[:url]}\n"

        puts "     + Internal links: #{'None' if result[:links].empty?}"
        result[:links].each { |link| puts "            - #{link}" }

        puts "     + Internal images: #{'None' if result[:assets][:images].empty?}"
        result[:assets][:images].each { |link| puts "            - #{link}" }

        puts "     + Internal stylesheets: #{'None' if result[:assets][:stylesheets].empty?}"
        result[:assets][:stylesheets].each { |link| puts "            - #{link}" }

        puts "     + Internal scripts: #{'None' if result[:assets][:scripts].empty?}"
        result[:assets][:scripts].each { |link| puts "            - #{link}" }
        puts ""
      end
      draw_line
    end

    private

    ###
    # Process a page by extracting information and updating links queue, links list and results.
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

      log_status( page_url ) if @option_debug # Display site crawling status
    end

    ###
    # Display a notice when starting a site crawl
    #
    def crawling_start_notice start_url, threads
      draw_line
      puts "Start crawling #{start_url} using #{threads} threads. Crawling rules:"
      puts "1. Keep only internal links"
      puts "2. Links with different scheme are agnored"
      puts "3. Remove the fragment part from the links (#...)"
      puts "4. Keep paths with different parameters (?...)"
      draw_line
    end

    ###
    # Log current search status (crawled links / total links)
    #
    def log_status url
      text = "Crawled #{@crawl_results.length.to_s}/#{@links.length.to_s}: #{url}"
      print "\r#{" "*100}\r" # Clean the previous text
      print (text.length <= 50) ? text : "#{text[0..46]}..."
      STDOUT.flush
    end

    ###
    # Display final crawling summary after site crawling complete
    #
    def crawling_summary_notice time_start, time_end, threads
      total_time = time_end - time_start
      puts ""
      draw_line
      puts "Crawled #{@links.count} links in #{total_time.to_f.to_s} seconds using #{threads} threads."
      puts "Use .crawl_results to access the crawl results as an array of hashes."
      puts "Use .render to see the crawl_results as a sitemap."
      draw_line
    end

    ###
    # Draw a line (because readability is also important!!)
    #
    def draw_line
      puts "#{'-' * 80}"
    end

  end

end
