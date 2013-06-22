# Capistrano Go

Capistrano plugin that integrates Golang project tasks into capistrano deployment script.

WARNING: this capistrano plugin is still in development and may not work as expected.

## Installation

Install library from rubygems:

```
gem install capistrano-go
```

## Usage

### Setup

Add the library to your `Gemfile`:

```ruby
group :development do
  gem 'capistrano-go', :require => false
end
```

And load it into your deployment script `config/deploy.rb`:

```ruby
require 'capistrano-go'
```

Add Go build task hook:

```ruby
before 'deploy:restart', 'go:build'
before 'deploy:start',   'go:build'
```

Create a new configuration file `config/go/go.rb` or `config/go/STAGE.rb`, where stage is your deployment environment.

Example config - [examples/go.rb](https://github.com/snormore/capistrano-go/blob/master/examples/go.rb).

### Test

First, make sure you're running the latest release:

```
cap deploy
```

Then you can test each individual task:

```
cap go:build
```

## Configuration

You can modify any of the following options in your `deploy.rb` config.

- `go_env`             - Set unicorn environment. Default to `rails_env` variable.
- `go_bin`             - Set go executable file. Default to `go`.variable.
- `go_roles`           - Define which roles to perform go recpies on. Default to `:app`.
- `go_config_path`     - Set the directory where go config files reside. Default to `current_path/config`.
- `go_config_filename` - Set the filename of the go config file. Not used in multistage installations. Default to `go.rb`.

### Multistage

If you are using capistrano multistage, please refer to [Using capistrano Go with multistage environment](https://github.com/snormore/capistrano-go/wiki/Using-capistrano-go-with-multistage-environment).

## Available Tasks

To get a list of all capistrano tasks, run `cap -T`:

```
cap go:Build    # Build the Go application
cap go:clean    # Clean up the Go application build
```

## License

See LICENSE file for details.
