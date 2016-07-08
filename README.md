# SuperCrawler

Easy (yet efficient) ruby gem to crawl a web site.

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

## Quick Start

Open your terminal, then:

```bash
$ git clone https://github.com/htaidirt/super_crawler

$ cd super_crawler

$ bundle

$ ./bin/console
```

```ruby
sc = SuperCrawler::CrawlSite.new('https://gocardless.com')

sc.links.count # => How many links crawled
```

## Warning!

This gem is an experiment and can't be used for production purposes. Please, use it with caution if you want to use it in your projects.

There are also a lot of limitations that weren't handled due to time. You'll find more information on the limitations below.

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

This method search in the `href` attribute of all `<a>` anchor tags.

**Nota:** This methods returns an array of absolute URLs (all internal links).

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/htaidirt/super_crawler. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
