# SuperCrawler

Easy (yet efficient) ruby gem to crawl your favorite website.

## Quick Start

Open your terminal, then:

    git clone https://github.com/htaidirt/super_crawler
    cd super_crawler
    bundle
    ./bin/console

Then

    sc = SuperCrawler::Crawl.new('https://gocardless.com')
    sc.start(10) # => Start crawling the website using 10 threads
    sc.render(5) # => Show the first 5 results of the crawling as sitemap

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'super_crawler'
```

And then execute:

```ruby
bundle install
```

Or install it yourself as:

```ruby
gem install super_crawler
```

Want to experiment with the gem without installing it? Clone the following repo and run `bin/console` for an interactive prompt that will allow you to experiment.

## Warning!

This gem is an experiment and can't be used for production purposes. Please, use it with caution if you want to use it in your projects.

There are also a lot of limitations that weren't handled due to time. You'll find more information on the limitations below.

SuperCrawler gem was only tested on MRI 2.3.1 and Rubinius 2.5.8.

## Philosophy

Starting from a given URL, the crawler extracts all the internal links and assets within the page. The links are added to a list of unique links for further exploration. The crawler repeats the exploration visiting all the links until no new link is found.

Due to the heavy operations (thousands of pages), and the network time to access each page content, we will use threads to perform near-parallel processing.

In order to keep the code readable and structured, we created two classes:

- `SuperCrawler::Scrap` is responsible for scrapping a single page and extracting all relevant information (internal links and assets)
- `SuperCrawler::Crawl` is responsible for crawling a whole website by collecting and managing links (using `SuperCrawler::Scrap` on every internal link found.) This class is also responsible for rendering results.

## More detailed use

Open your favorite ruby console and require the gem:

    require 'super_crawler'

### Scrapping a single web page

Read the following if you would like to crawl a single web page and extract relevant information (internal links and assets).

    page = SuperCrawler::Scrap.new( url )

Where `url` should be the URL of the page you would like to scrap.

**Nota:** If the given URL has a missing scheme (`http://` or `https://`), SuperCrawler will prepend `http://` to the URL.

#### Get the encoded URL

Run

    page.url
    
to get the encoded URL.

#### Get internal links of a page

Run

    page.get_links
    
to get the list of internal links in the page. An internal link is a link that _has the same schame and host than the provided URL_. Subdomains are rejected.

This method searches in the `href` attribute of all `<a>` anchor tags.

**Nota:**

- This method returns an array of absolute URLs (all internal links).
- Bad links and special links (like mailto and javascript) are discarded.

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

    page.get_stylesheets

to get a list of stylesheet links within the page. The links are extracted from the `href="..."` attribute of all `<link rel="stylesheet">` tags.

**Nota:**

- Inline styling isn't yet detected by the method.
- This method returns an array of absolute URLs.

#### Get scripts of a page

Run

    page.get_scripts

to get a list of script links within the page. The links are extracted from the `src="..."` attribute of all `<script>` tags.

**Nota:**

- Inline script isn't yet detected by the method.
- This method returns an array of absolute URLs.

#### List all assets of a page

Run

    page.get_assets

to get a list of all assets (links of images, stylesheets and scripts) as a hash of arrays.

### Crawling a whole web site

    sc = SuperCrawler::Crawl.new(url)

where `url` is the URL of the website to crawl.

Next, start the crawler:

    sc.start(number_of_threads)
    
where `number_of_threads` is the number of threads that will perform the job (10 by default.) **This can take some time, depending on the site to crawl.**

To access the crawl results, use the following:

    sc.links # The array of unique internal links
    sc.crawl_results # Array of hashes containing links and assets for every unique internal link found

To see the crawling as a sitemap, use:

    sc.render(5) # Will render the sitemap of the first 5 pages

_TODO: Create a separate and more sophisticated rendering class, that can render within files of different formats (HTML, XML, JSON,...)_

#### Tips on searching assets and links

After `sc.start`, you can access all collected resources (links and assets) using `sc.crawl_results`. This has the following structure:

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

You can use `sc.crawl_results.select{ |resource| ... }` to select a particular resource.

## Limitations

Actually, the gem has the following limitations:

- Subdomains are not considered as internal links
- A link with the same domain but different scheme is ignored (http -> https, or the opposite)
- Only links within `<a href="...">` tags are extracted
- Only images links within `<img src="..."/>` tags are extracted
- Only stylesheets links within `<link rel="stylesheet" href="..." />` tags are extracted
- Only scripts links within `<script src="...">` tags are extracted
- A page that is not accessible (not status 200) is not checked later

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/htaidirt/super_crawler](https://github.com/htaidirt/super_crawler). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

Please, follow this process:

1. Fork the project
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Don't forget to have fun coding Ruby...
