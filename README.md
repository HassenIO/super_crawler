# SuperCrawler

Easy (yet efficient) ruby gem to crawl your favorite website.

## Quick Start

Open your terminal, then:

```bash
$ git clone https://github.com/htaidirt/super_crawler

$ cd super_crawler

$ bundle

$ ./bin/console
```

```ruby
 > sc = SuperCrawler::CrawlSite.new('https://gocardless.com')

 > sc.start # => Start crawling the website

 > sc.render(5) # => Show first 5 results of the crawling as sitemap
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'super_crawler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install super_crawler

Want to experiment with the gem without installing it? Clone the following repo and run `bin/console` for an interactive prompt that will allow you to experiment.

## Warning!

This gem is an experiment and can't be used for production purposes. Please, use it with caution if you want to use it in your projects.

There are also a lot of limitations that weren't handled due to time. You'll find more information on the limitations below.

SuperCrawler gem was only tested on MRI and ruby 2.3.1.

## Philosophy

Starting from a URL, extract all the internal links and assets within the page. Add all unique links to an array for future exploration of theses links. Repeat for each link in the links list until no new link is discovered.

Due to the heavy operations, and the time to access each page content, we will use threads to perform near-parallel processing.

In order to keep the code readable and structured, create two classes:

- `SuperCrawler::CrawlPage` that is responsible for crawling a single page and extracting all relevant information (internal links and assets)
- `SuperCrawler::CrawlSite` that is responsible for crawling a whole website, by collecting links and calling `SuperCrawler::CrawlPage` within threads. This class is also responsible for rendering results.

## More detailed usage

Open your favorite ruby console and require the gem:

```ruby
require 'super_crawler'
```

### Crawling a single web page

Read the following if you would like to crawl a single web page and extract relevant information (internal links and assets).

```ruby
page = SuperCrawler::CrawlPage.new( url )
```

Where `url` should be the URL of the page you would like to crawl.

**Nota:** When missing a scheme (`http://` or `https://`), SuperCrawler will prepend the URL with an `http://`.

#### Get the encoded URL

Run

```ruby
page.url
```

to get the encoded URL provided.

#### Get internal links of a page

Run

```ruby
page.get_links
```

to get a list of internal links within the crawled page. An internal link is a link that _has the same host than the page URL_. Subdomains are rejected.

This method searches in the `href` attribute of all `<a>` anchor tags.

**Nota:** This method returns an array of absolute URLs (all internal links).

**Nota 2:** Bad links and special links (like mailto and javascript) are discarded.

#### Get images of a page

Run

```ruby
page.get_images
```

to get a list of images links within the page. The images links are extracted from the `src="..."` attribute of all `<img>` tags.

**Nota:** Images included using CSS or JavaScript aren't detected by the method.

**Nota 2:** This method returns an array of absolute URLs.

#### Get stylesheets of a page

Run

```ruby
page.get_stylesheets
```

to get a list of stylesheets links within the page. The stylesheets links are extracted from the `href="..."` attribute of all `<link rel="stylesheet">` tags.

**Nota:** Inline styling isn't yet detected by the method.

**Nota 2:** This method returns an array of absolute URLs.

#### Get scripts of a page

Run

```ruby
page.get_scripts
```

to get a list of scripts links within the page. The scripts links are extracted from the `src="..."` attribute of all `<script>` tags.

**Nota:** Inline script isn't yet detected by the method.

**Nota 2:** This method returns an array of absolute URLs.

#### List all assets of a page

Run

```ruby
page.get_assets
```

to get a list of all assets (images, stylesheets and scripts links) as a hash of arrays.

### Crawling a whole web site

First instantiate the site crawler.

```ruby
sc = SuperCrawler::CrawlSite.new(url, count_threads)
```

where `url` is the URL of the page to crawl, and `count_threads` the number of threads to handle the job (by default 10).

Next, start the crawler:

```ruby
sc.start
```

This can take some time, depending on the site to crawl.

To access crawl results, you can use the following:

```ruby
sc.links # The array of internal links

sc.crawl_results # Array of hashes containing links and assets for every link crawled
```

To see the crawling as a sitemap, use:

```ruby
sc.render(5) # Will render the sitemap of the first 5 pages
```

TODO: Make more sophisticated rendering class, that can render within files of different formats (HTML, XML, JSON,...)

#### Tips on searching assets and links

After `sc.start`, you can access all collected resources (links and assets) using `sc.crawl_results`. This has the following structure:

```json
[
  {
    url: 'http://example.com/',
    links: [...array of internal links...],
    assets: {
      images: [...array of images links],
      stylesheets: [...array of stylesheets links],
      scripts: [...array of scripts links],
    }
  },
  ...
]
```

You can use `sc.crawl_results.select{ |resource| ... }` to select a particular resource.

## Limitations

Actually, the gem has the following limitations:

- Subdomains are not considered as internal links
- Both HTTP and HTTPS pages are taken into account. This can increase the number of links found, but we think that we need to keep it because some sites don't duplicate all contents for HTTP and HTTPS
- Only links within `<a href="...">` tags are extracted
- Only images links within `<img src="..."/>` tags are extracted
- Only stylesheets links within `<link rel="stylesheet" href="..." />` tags are extracted
- Only scripts links within `<script src="...">` tags are extracted
- A page that is not accessible (eg. error 404) is not checked later

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/htaidirt/super_crawler. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## ... and never forget to have fun coding Ruby...
