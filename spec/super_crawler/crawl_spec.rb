require 'spec_helper'
require 'super_crawler/crawl'

describe SuperCrawler::Crawl do

  let(:index_url) { 'http://example.com/'}
  let(:help_url) { 'http://example.com/help/'}
  let(:faq_url) { 'http://example.com/faq/'}

  let(:index_html) { File.read(File.expand_path('../../support/index.html', __FILE__)) }
  let(:help_html) { File.read(File.expand_path('../../support/help.html', __FILE__)) }
  let(:faq_url) { File.read(File.expand_path('../../support/faq.html', __FILE__)) }

  subject(:index_page) { SuperCrawler::Scrap.new(index_url) }
  subject(:help_page) { SuperCrawler::Scrap.new(help_url) }
  subject(:faq_page) { SuperCrawler::Scrap.new(faq_url) }

  subject(:crawler) { SuperCrawler::Crawl.new(index_url, debug: false) }

  before do
    allow(index_page).to receive(:get_doc) { Nokogiri(index_html) }
    allow(help_page).to receive(:get_doc) { Nokogiri(help_html) }
    allow(faq_page).to receive(:get_doc) { Nokogiri(faq_html) }
  end

  describe "Crawling all http://example.com/" do
    before { crawler.start 10 }

    it("should have results from all pages") { expect(crawler.links.count).to eq(crawler.crawl_results.count) }
  end

end
