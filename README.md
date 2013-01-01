Features
========

* Auto setup rubygems from Gemfile, bundle and generate related files.
* Can be used in exists project.

Installation
============

```ruby
group :development do
  ...
  gem 'venus'
  ...
end
```

Usage
=====

Project basic rubygems

```
rails generate venus:init
```

Pagination gem "kaminari"

```
rails generate venus:paginate
```

Settings gem "settingslogic"

```
rails generate venus:settingslogic
```

gem 'devise', default generate model `User`

```
rails generate venus:devise
```

Facebook login (for model `User`)

```
rails generate venus:fbauth
```

Rspec testing framework

```
rails generate venus:rspec
```

TODO
====

* MySql / MongoDB / Redis auto setup.
* Bootstrap.
* Carrierwave with rmagick & fog.
* Aws SES for sending email.
* RailsAdmin or ActiveAdmin.
* Sidekiq for background job.
* Testing different rails version.

Contribution
============

Just send pull request :)