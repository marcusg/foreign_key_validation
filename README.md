# foreign_key_validation

[![Coverage Status](https://coveralls.io/repos/marcusg/foreign_key_validation/badge.png?branch=master)](https://coveralls.io/r/marcusg/foreign_key_validation?branch=master)
[![Code Climate](https://codeclimate.com/github/marcusg/foreign_key_validation/badges/gpa.svg)](https://codeclimate.com/github/marcusg/foreign_key_validation)
[![Build Status](https://travis-ci.org/marcusg/foreign_key_validation.svg?branch=master)](https://travis-ci.org/marcusg/foreign_key_validation)
[![Gem Version](https://badge.fury.io/rb/foreign_key_validation.svg)](http://badge.fury.io/rb/foreign_key_validation)

Protect your models by specifying a collection of relations that should be tested for consistency with a predefined column (e.g. `user_id`).This is useful when the column `user_id` is used in multiple models. We can check if the `user_id` of *model A* matches `user_id` of *model B* before saving the records - if the IDs are different, an error will be attached to the errors hash of checked model.

## Requirements

    ruby >= 1.9.3
    active_record & active_support >= 3.2.0

## Installation

Add this line to your application's Gemfile:

    gem 'foreign_key_validation'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install foreign_key_validation

## Usage

Call `validate_foreign_keys` below the association definitions (`belongs_to`, ...) in your model. By default it assumes that it should check all `belongs_to` relations against the `user_id` column. So any relation will be checked for a matching `user_id`.

Change behaviour by calling `validate_foreign_keys` with arguments hash.

    validate_foreign_keys on: :admin_user, with: [:project]

This would only check `model.project.admin_user_id` to match `model.admin_user_id` before saving the record.

## Configuration

You can customize the default behaviour of the gem by calling the `configure` method on the module with a block (e.g. initializer).

    ForeignKeyValidation.configure do |config|
      config.error_message      = lambda { |key, name, object| "My custom msg!" }
      config.inject_subclasses  = false     # default: true
      config.validate_against   = :admin    # default: :user
    end

## Tests

Use these commands to run the testsuite against different versions of ActiveRecord

    bundle
    appraisal install
    appraisal rspec

## Contributing

1. Fork it ( https://github.com/marcusg/foreign_key_validation/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
