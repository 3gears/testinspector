# viewcumber

A Cucumber formatter which generates an HTML website to browse your scenarios and view screen capture of every single step.

## Pre-requisites

* Rails 4
* Cucumber `~> 1.3`
* Capybara `~> 2.4`

## Installation

Add this line to your application's Gemfile:

    gem 'viewcumber'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install viewcumber

## Usage

  viewcumber features

or

  cucumber --format Viewcumber features

Then open ./viewcumber/index.html in Firefox/Safari. It does not work in Chrome.

![A screenshot](screenshot.png)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/viewcumber/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
