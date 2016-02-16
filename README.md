# ActiveTriples::MongoidStrategy

[![Build Status](https://travis-ci.org/ActiveTriples/active_triples-mongoi.png?branch=master)](https://travis-ci.org/ActiveTriples/active_triples-mongoid_strategy)
[![Coverage Status](https://coveralls.io/repos/ActiveTriples/active_triples-mongoid_strategy/badge.png?branch=master)](https://coveralls.io/r/ActiveTriples/active_triples-mongoid_strategy?branch=master)
[![Gem Version](https://badge.fury.io/rb/active_triples-mongoid_strategy.svg)](http://badge.fury.io/rb/active_triples-mongoid_strategy)

Provides a graph-based persistence strategy for the [ActiveTriples](https://github.com/ActiveTriples/ActiveTriples) framework.  `ActiveTriples::RDFSources` are persisted to MongoDB natively as Compacted [JSON-LD](http://json-ld.org) documents.

## Installation

Add this line to your application's Gemfile:

    gem 'active_triples-mongoid_strategy'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install active_triples-mongoid_strategy

## Usage

Start by [configuring Mongoid](https://docs.mongodb.org/ecosystem/tutorial/mongoid-installation/#configuration) for your environment or application as per the documentation.

Persistence strategies currently (as of [ActiveTriples 0.8.1](https://github.com/ActiveTriples/ActiveTriples/tree/v0.8.1)) use `RDF::Repository` as the default persistence strategy.  To override this, you have to inject `MongoidStrategy` into `RDFSource` instances at runtime:

```ruby
require 'active_triples/mongoid_strategy'

source = ActiveTriples::Resource.new
source.persistence_strategy # => #<ActiveTriples::RepositoryStrategy:...>

source.set_persistence_strategy(ActiveTriples::MongoidStrategy)
source.persistence_strategy # => #<ActiveTriples::MongoidStrategy:...>
```

## Contributing

Please observe the following guidelines:

 - Do your work in a feature branch based on ```master``` and rebase before submitting a pull request.
 - Write tests for your contributions.
 - Document every method you add using YARD annotations. (_Note: Annotations are sparse in the existing codebase, help us fix that!_)
 - Organize your commits into logical units.
 - Don't leave trailing whitespace (i.e. run ```git diff --check``` before committing).
 - Use [well formed](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) commit messages.
