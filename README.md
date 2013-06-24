Features
========

* Auto setup rubygems from Gemfile, bundle and generate related files.
* Can be used in exists project.

Installation
============

```ruby
group :development do
  ...
  gem 'venus', '~> 0.8.0'
  ...
end
```

* Edge version

```ruby
group :development do
  ...
  gem 'venus', :git => 'git://github.com/marsz/venus.git'
  ...
end
```

`bundle update venus`

Usage
=====

* `unicorn` for zero downtime deployment

  ```
  rails generate venus:unicorn
  ```

* `asset_sync` for upload assets files to AWS S3 after precompile

  ```
  rails generate venus:asset_sync
  ```


* `sidekiq` for background job

  ```
  rails generate venus:sidekiq
  ```

* `paper_trail` for model versioning

  ```
  rails generate venus:versioning
  ```

* `Twitter Bootstrap` theme and `Unicorn Admin` optional.
  
  ```
  rails generate venus:bootstrap
  ```

* `Carrierwave` installation and carrierwave-meta, rmagick, fog (for AWS S3) optional and give a sample uploader.
  
  ```
  rails generate venus:carrierwave
  ```

* `jQuery UI` (including `datepicker` and more jQuery-UI plugins)
  
  ```
  rails generate venus:jqueryui
  ```

* `Chosen` for jQuery (see demo: http://harvesthq.github.com/chosen/)
  
  ```
  rails generate venus:chosen
  ```

* `Amazon Web Service` api keys for official aws-sdk (including SES).

  ```
  rails generate venus:aws
  ```

* `Redis` client and related gems (redis-objects) for optional.

  ```
  rails generate venus:redis
  ```

* `Omniauth` for multiple omniauth (Facebook, Twitter, Github) in model `User`.

  ```
  rails generate venus:omniauth
  ```

* `Capistrano` for deloyment.

  ```
  rails generate venus:deploy
  ```

* `simple_form` and its related gems (including `nested_form`)

  ```
  rails generate venus:simple_form
  ```

* Essentail gems (kminari...etc) and setup (removing public/index.html ...etc).

  ```
  rails generate venus:init
  ```

* `MySql` database connection

  ```
  rails generate venus:mysql
  ```

* `kaminari` for pagination

  ```
  rails generate venus:paginate
  ```

* `settingslogic` for all YAML configurations.

  ```
  rails generate venus:settingslogic
  ```

* `devise` for user login, default generate model `User`

  ```
  rails generate venus:devise
  ```

* `RSpec` testing framework

  ```
  rails generate venus:rspec
  ```

TODO
====

* Unicorn setup for capistrano.
* MongoDB configuration.
* RailsAdmin or ActiveAdmin.
* Amazon Elastic Cache & cells.

Contribution
============

Just send pull request :)
