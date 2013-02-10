Features
========

* Auto setup rubygems from Gemfile, bundle and generate related files.
* Can be used in exists project.

Installation
============

```ruby
group :development do
  ...
  gem 'venus', '~> 0.4.2'
  ...
end
```

Usage
=====

* Setup Omniauth for multiple omniauth (Facebook, Twitter, Github) in model `User`.

  ```
  rails generate venus:omniauth
  ```

* Setup gem 'capistrano' for deloyment.

  ```
  rails generate venus:deploy
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

* Capistrano with multi-stages extendsion.
* MongoDB / Redis configuration.
* Twitter Bootstrap layout.
* Carrierwave with rmagick & fog.
* Aws SES for sending email.
* RailsAdmin or ActiveAdmin.
* Sidekiq for background job.

Thanks
======

Idea is from xdite/bootstrappers (https://github.com/xdite/bootstrappers).

Contribution
============

Just send pull request :)