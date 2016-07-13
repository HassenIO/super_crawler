require 'spec_helper'
require 'super_crawler/crawl_site'

describe SuperCrawler::CrawlSite do

  let(:url)             { 'http://htaidirt.com' }
  subject(:sc)          { SuperCrawler::CrawlSite.new(url, debug: true) }

  describe "Crawling all http://htaidirt.com" do
    before { sc.start 10 }

    it("should have results from all pages") { expect(sc.links.count).to eq(sc.crawl_results.count) }
  end

end
