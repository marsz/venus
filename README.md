Features
========

* Auto setup rubygems from Gemfile, bundle and generate related files.
* Can be used in exists project.

Installation
============

```ruby
group :development do
  ...
  gem 'venus', '~> 0.6.2'
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

* Sidekiq for background job.
* Unicorn setup for capistrano.
* Model versioning related gems setup.
* MongoDB configuration.
* RailsAdmin or ActiveAdmin.
* Amazon Elastic Cache & cells.

Thanks
======

Idea is from xdite/bootstrappers (https://github.com/xdite/bootstrappers).

Contribution
============

Just send pull request :)
