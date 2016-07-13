require 'spec_helper'
require 'super_crawler/scrap'

describe SuperCrawler::Scrap do

  let(:ex_url)    { 'http://example.com' } # An example URL
  let(:html)      { File.read( File.expand_path('../../support/index.html', __FILE__) ) }
  subject(:page)  { SuperCrawler::Scrap.new(ex_url) }
  before          { allow(page).to receive(:get_doc) { Nokogiri(html) } }

  it { expect(page).to respond_to(:url) }
  it { expect(page).to respond_to(:get_links) }
  it { expect(page).to respond_to(:get_images) }
  it { expect(page).to respond_to(:get_stylesheets) }
  it { expect(page).to respond_to(:get_scripts) }
  it { expect(page).to respond_to(:get_assets) }
  it { expect(page).to respond_to(:get_all) }
  it { expect(page).to_not respond_to(:get_doc) }
  it { expect(page).to_not respond_to(:base_url) }
  it { expect(page).to_not respond_to(:create_absolute_url) }

  it { expect(page.url).to eq(ex_url) }

  describe "get_links" do
    let(:page_links) { page.get_links }

    it("should be an array") { expect(page_links).to be_a(Array) }
    it("should detect unique internal links") { expect(page_links.count).to eq(3) }
    it("shouldn't keep facebook.com") { expect(page_links.include?("http://facebook.com")).to eq(false) }
    it("shouldn't keep subdomain link") { expect(page_links.include?("http://developers.example.com/")).to eq(false) }
    it("should convert all links to absolute path") { expect(page_links.include?("#{ex_url}/help")).to eq(true) }
  end

  describe "get_images" do
    let(:page_images) { page.get_images }

    it("should be an array") { expect(page_images).to be_a(Array) }
    it("should detect only one image") { expect(page_images.count).to eq(1) }
    it("should convert relative image path to absolute path") { expect(page_images.include?("#{ex_url}/logo.png")).to eq(true) }
  end

  describe "get_stylesheets" do
    let(:page_stylesheets) { page.get_stylesheets }

    it("should be an array") { expect(page_stylesheets).to be_a(Array) }
    it("should detect only one stylesheet") { expect(page_stylesheets.count).to eq(1) }
    it("should convert relative stylesheet path to absolute path") { expect(page_stylesheets.include?("#{ex_url}/css/master.css")).to eq(true) }
  end

  describe "get_scripts" do
    let(:page_scripts) { page.get_scripts }

    it("should be an array") { expect(page_scripts).to be_a(Array) }
    it("should detect only two scripts") { expect(page_scripts.count).to eq(2) }
    it("should convert relative scripts path to absolute path") { expect(page_scripts.include?("#{ex_url}/js/jquery.min.js")).to eq(true) }
    it("should keep external scripts") { expect(page_scripts.include?("http://google.com/analytics.js")).to eq(true) }
  end

  describe "get_assets" do
    let(:page_assets) { page.get_assets }

    it("should be a hash") { expect(page_assets).to be_a(Hash) }
    it("should have images") { expect(page_assets[:images]).to_not eq(nil) }
    it("should have stylesheets") { expect(page_assets[:stylesheets]).to_not eq(nil) }
    it("should have scripts") { expect(page_assets[:scripts]).to_not eq(nil) }
  end

end
