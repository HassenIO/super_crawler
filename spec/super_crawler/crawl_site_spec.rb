require 'spec_helper'
require 'super_crawler/crawl_site'

describe SuperCrawler::CrawlSite do

  let(:url)             { 'http://htaidirt.com' }
  subject(:sc)          { SuperCrawler::CrawlSite.new(url, 10, debug: true) }

  describe "Crawling all http://htaidirt.com" do
    before { sc.start }

    it("should have results from all pages") { expect(sc.links.count).to eq(sc.crawl_results.count) }
  end

end
