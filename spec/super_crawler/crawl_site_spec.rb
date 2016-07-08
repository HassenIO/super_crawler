require 'spec_helper'
require 'super_crawler/crawl_page'
require 'super_crawler/crawl_site'

describe SuperCrawler::CrawlSite do

  let(:index_url)       { 'http://example.com' } # The index URL
  let(:index_html)      { File.read( File.expand_path('../../support/index.html', __FILE__) ) }
  subject(:index_page)  { SuperCrawler::CrawlPage.new(index_url) }

  let(:help_url)        { 'http://example.com/help' } # The help URL
  let(:help_html)       { File.read( File.expand_path('../../support/help.html', __FILE__) ) }
  subject(:help_page)   { SuperCrawler::CrawlPage.new(help_url) }

  subject(:sc) { SuperCrawler::CrawlSite.new(index_url, 4, debug: false) }

  before do
    allow(index_page).to receive(:get_doc) { Nokogiri(index_html) }
    allow(help_page).to  receive(:get_doc) { Nokogiri(help_html) }
  end

  describe "Crawling all http://example.com" do
    before { sc.start }

    it do
      puts sc.crawl_results.to_s
      # puts index_page.get_links
      expect(true).to eq(true)
    end
  end

end
