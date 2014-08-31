# foreign_key_validation

Protect your models by specifying a collection of foreign keys that should be tested for consistency with the `belongs_to` relations. For example, when the `user_id` is used in all models we can check if the `user_id` of `model a` matches `user_id` of `model b` before saving the records.

## Requirements
    ruby >= 1.9
    rails
    active_record

## Installation

Add this line to your application's Gemfile:

    gem 'foreign_key_validation'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install foreign_key_validation

## Usage

Call `validate_foreign_keys` below the association definitions (`belongs_to`, ...) in your model. By default it assumes that it should check all foreign keys against the `user_id` column. So any relation (except `user`) will be checked for a matching `user_id` if the column exists.

Change behaviour by calling `validate_foreign_keys` with arguments hash.

    validate_foreign_keys on: :admin_user, with: [:project]

This would only check `model.project.admin_user_id` to match `model.admin_user_id`.

## Note

Only tested with ActiveRecord


## Contributing

1. Fork it ( https://github.com/marcusg/foreign_key_validation/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
