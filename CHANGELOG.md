## 0.8.6

Features:
  
  - Add unicorn generator, `rails generate venus:unicorn`.
  - Ask generate venus:puma after generate venus:deploy.
  - Add puma server generator, `rails generate venus:puma`.
  - Newrelic 3.6.5 generator.
  - Sentry generator for cloud exceptions storage.
  - Hipchat generator for deploy notification.
  - better_errors generator for rendering errors clearly.
  - Bind better_errors generator into init generator.
  - rails_panel generator for debugging request in Chrome.
  - Bind rails_panel generator into init generator.

Updates:

  - Always upload files config hint in config/asset_sync.rb
  - Replace rmagick to mini_magick in carrierwave generator.
  - Upgrade sidekiq to 2.12.4 .
  - Remove HAML in init generator.
  - Upgrade timepicker to 1.3 .
  - Upgrade chosen-rails to 0.9.15 .
  - Upgrade jqueryui-rails to 4.0.3 .

Fixes:

  - Simple form config for bootstrap.
