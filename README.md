Features
========

* Auto setup rubygems from Gemfile, bundle and generate related files.
* Can be used in exists project.

Installation
============

```ruby
group :development do
  ...
  gem 'venus', '~> 0.6.1'
  ...
end
```

Usage
=====

* Setup twitter bootstrap theme and Unicorn Admin for optional
  
  ```
  rails generate venus:bootstrap
  ```

* Setup carrierwave with carrierwave-meta, rmagick, fog (for AWS S3) and give a sample uploader.
  
  ```
  rails generate venus:carrierwave
  ```

* Setup jQuery UI (including datepicker and more jQuery-UI plugins)
  
  ```
  rails generate venus:jqueryui
  ```

* Setup chosen for jQuery (see demo: http://harvesthq.github.com/chosen/)
  
  ```
  rails generate venus:chosen
  ```

* Setup AWS api keys for official aws-sdk (including SES).

  ```
  rails generate venus:aws
  ```

* Setup Omniauth for multiple omniauth (Facebook, Twitter, Github) in model `User`.

  ```
  rails generate venus:omniauth
  ```

* Setup gem 'capistrano' for deloyment.

  ```
  rails generate venus:deploy
  ```

* Setup gem 'simple_form' and its related gems (including 'nested_form')

  ```
  rails generate venus:simple_form
  ```

* Essentail gems (simple_form, kminari...etc) and setup (removing public/index.html ...etc).

  ```
  rails generate venus:init
  ```

* Setup Mysql connection

  ```
  rails generate venus:mysql
  ```

* Pagination gem "kaminari"

  ```
  rails generate venus:paginate
  ```

* Setup gem "settingslogic"

  ```
  rails generate venus:settingslogic
  ```

* Setup gem 'devise', default generate model `User`

  ```
  rails generate venus:devise
  ```

* Setup Rspec testing framework

  ```
  rails generate venus:rspec
  ```

TODO
====

* MongoDB / Redis configuration.
* RailsAdmin or ActiveAdmin.
* Sidekiq for background job.

Thanks
======

Idea is from xdite/bootstrappers (https://github.com/xdite/bootstrappers).

Contribution
============

Just send pull request :)