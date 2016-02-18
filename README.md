# ActiveTriples::MongoidStrategy

[![Build Status](https://travis-ci.org/ActiveTriples/active_triples-mongoid_strategy.svg?branch=master)](https://travis-ci.org/ActiveTriples/active_triples-mongoid_strategy)
[![Coverage Status](https://coveralls.io/repos/github/ActiveTriples/active_triples-mongoid_strategy/badge.svg?branch=master)](https://coveralls.io/github/ActiveTriples/active_triples-mongoid_strategy?branch=master)
[![Gem Version](https://badge.fury.io/rb/active_triples-mongoid_strategy.svg)](http://badge.fury.io/rb/active_triples-mongoid_strategy)

Provides a graph-based persistence strategy for the [ActiveTriples](https://github.com/ActiveTriples/ActiveTriples) framework.  RDF Sources are persisted to MongoDB natively as Flattened [JSON-LD](https://github.com/ruby-rdf/json-ld) documents.

## Installation

Add this line to your application's Gemfile:

    gem 'active_triples-mongoid_strategy'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install active_triples-mongoid_strategy

## Usage

Start by [configuring Mongoid](https://docs.mongodb.org/ecosystem/tutorial/mongoid-installation/#configuration) for your environment or application as per the documentation.

ActiveTriples currently (as of [0.8.1](https://github.com/ActiveTriples/ActiveTriples/tree/v0.8.1)) uses an `RDF::Repository` as the default persistence strategy.  To override this, you have to manually set `MongoidStrategy` on instances at runtime:

```ruby
require 'active_triples/mongoid_strategy'

source = ActiveTriples::Resource.new
source.persistence_strategy # => #<ActiveTriples::RepositoryStrategy:...>

source.set_persistence_strategy(ActiveTriples::MongoidStrategy)
source.persistence_strategy # => #<ActiveTriples::MongoidStrategy:...>
```

[See this gist](https://gist.github.com/elrayle/11898117572445a15c4a) for more information on Persistence Strategies.

## Contributing

Please observe the following guidelines:

 - Do your work in a feature branch based on ```master``` and rebase before submitting a pull request.
 - Write tests for your contributions.
 - Document every method you add using YARD annotations. (_Note: Annotations are sparse in the existing codebase, help us fix that!_)
 - Organize your commits into logical units.
 - Don't leave trailing whitespace (i.e. run ```git diff --check``` before committing).
 - Use [well formed](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) commit messages.
