Features
========

* Auto setup rubygems from Gemfile, bundle and generate related files.
* Can be used in exists project.

Installation
============

```ruby
group :development do
  ...
  gem 'venus', '~> 0.8.6'
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

* For project initial, including general gems installation asking, `.gitignore` attaching, removing useless files....etc.

  ```
  rails generate venus:init
  ```

* `MySQL` database setup.

  ```
  rails generate venus:mysql
  ```

* `RSpec` testing framework

  ```
  rails generate venus:rspec
  ```

* `simple_form` and its related gems (including `nested_form`)

  ```
  rails generate venus:simple_form
  ```

* `kaminari` for pagination

  ```
  rails generate venus:kaminari
  ```

* `settingslogic` for all YAML configurations.

  ```
  rails generate venus:settingslogic
  ```

* `devise` installation or model generation (with scoped views).

  ```
  rails generate venus:devise
  ```

* ask and install gems for development, including spring, guard, better_errors...etc.

  ```
  rails generate venus:dev
  ```
    
* `Amazon Web Service` api keys for official aws-sdk (including SES).

  ```
  rails generate venus:aws
  ```

* `Redis` client and related gems (redis-objects) for optional.

  ```
  rails generate venus:redis
  ```

* `sidekiq` for background job

  ```
  rails generate venus:sidekiq
  ```

* `Capistrano` for deloyment.

  ```
  rails generate venus:capistrano
  ```

* install & setup gem `whenever`

  ```
  rails generate venus:whenever
  ```

* `unicorn` for zero downtime deployment

  ```
  rails generate venus:unicorn
  ```

* Hipchat generator for notification while deploy.

  ```
  rails generate venus:hipchat
  ```
  
* `asset_sync` for upload assets files to AWS S3 after precompile

  ```
  rails generate venus:asset_sync
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

* `Omniauth` for multiple omniauth (Facebook, Twitter, Github) in model `User`.

  ```
  rails generate venus:omniauth
  ```

TODO
====

* MongoDB configuration.
* RailsAdmin or ActiveAdmin.
* Amazon Elastic Cache & cells.

Contribution
============

Just send pull request :)
