source 'https://rubygems.org'
ruby '2.5.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.0'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
# gem 'redis', '~> 3.0'
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  # .env
  gem 'dotenv-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # debug
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-stack_explorer'
  gem 'hirb'
  gem 'hirb-unicode'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'awesome_print'
  gem 'bullet'
  # x-ray
  # gem 'xray-rails'
  # security
  gem 'brakeman', require: false

  gem 'rails_best_practices'
end

group :test do
  gem 'faker'
  gem 'capybara', '~> 2.13'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'

  gem 'simplecov', :require => false
end

group :production do
  gem 'mysql2'
end


gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# slim
gem 'slim-rails'
gem 'haml2slim', :group => :development
# font
gem 'bootstrap-sass'
gem 'font-awesome-rails'
# pagination
gem 'kaminari'
# devise
gem 'devise'
# tag management
gem 'acts-as-taggable-on'
gem 'jquery-ui-rails'
gem 'gon'
# history management
gem 'paper_trail'
# jQuery turbolinks
gem 'jquery-turbolinks'
# selection
gem 'jquery-selection-rails'
# markdown
gem 'redcarpet'
# difference
gem 'diffy'
# admin
gem 'activeadmin'
# set meta tags for SNS
gem 'meta-tags'
# search
gem 'ransack'
