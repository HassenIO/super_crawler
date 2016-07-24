module SuperCrawler

  ##
  # Render crawl results and processing.
  #
  class Render

    ###
    # Display a notice when starting a site crawl
    #
    def self.crawling_start_notice start_url, threads
      self.draw_line
      puts "Start crawling #{start_url} using #{threads} threads. Crawling rules:"
      puts "1. Keep only internal links"
      puts "2. Links with different scheme are agnored"
      puts "3. Remove the fragment part from the links (#...)"
      puts "4. Keep paths with different parameters (?...)"
      self.draw_line
    end

    ###
    # Render sitemap in console
    # Show, for each link, internal links and assets
    # We will limit pages to display, because some sites have more than 1,000 pages
    #
    def self.console crawl_results, max_pages
      self.draw_line
      puts "Showing first #{max_pages} crawled pages and their contents:\n\n"
      crawl_results[0..(max_pages-1)].each_with_index do |result, index|
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
      self.draw_line
    end

    ###
    # Log current search status (crawled links / total links)
    #
    def self.log_status url, crawl_results_length, links_length
      text = "Crawled #{crawl_results_length.to_s}/#{links_length.to_s}: #{url}"
      print "\r#{" "*100}\r" # Clean the previous text
      print (text.length <= 50) ? text : "#{text[0..46]}..."
      STDOUT.flush
    end

    ###
    # Display final crawling summary after site crawling complete
    #
    def self.crawling_summary_notice total_time, threads_count, links_count
      puts
      self.draw_line
      puts "Crawled #{links_count} links in #{total_time.to_f.to_s} seconds using #{threads_count} threads."
      puts "Use .crawl_results to access the crawl results as an array of hashes."
      puts "Use .render to see the crawl_results as a sitemap."
      self.draw_line
    end

    private

    ###
    # Draw a line (because readability is also important!!)
    #
    def self.draw_line
      puts "#{'-' * 80}"
    end


  end

end
