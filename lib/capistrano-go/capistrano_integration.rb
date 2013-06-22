require 'capistrano'
require 'capistrano/version'

module CapistranoGo
  class CapistranoIntegration
    TASKS = [
      'go:deploy'
    ]

    def self.load_into(capistrano_config)
      capistrano_config.load do
        before(CapistranoIntegration::TASKS) do
          _cset(:go_path)               { fetch(:go_path) }
          _cset(:go_app_package)        { fetch(:go_app_package) }
          _cset(:app_env)               { (fetch(:env) rescue 'production') }
          _cset(:go_env)                { fetch(:app_env) }
          _cset(:go_bin)                { "go" }
          _cset(:go_bundle)             { fetch(:bundle_cmd) rescue 'bundle' }
          _cset(:go_user)               { nil }
          _cset(:go_config_path)        { "#{fetch(:current_path)}/config" }
          _cset(:go_config_filename)    { "go.rb" }
        end

        def build_app
          go_app_package_path = File.join(:go_path, 'src', :go_app_package)
          go_app_package_parent_path = File.expand_path("..", go_app_package_path)
          run "mkdir -p #{go_app_package_parent_path}"
          run "rm -Rf #{previous_release} && mv #{go_app_package_path} #{previous_release}" if previous_release
          run "mv #{current_release} #{go_app_package_path} && ln -s #{go_app_package_path} #{current_release}"
          run "cd #{go_app_package_path} && mkdir -p #{current_path}/bin && rm -Rf #{go_path}/pkg/* && go get && go build -o #{current_path}/bin/#{application}"
        end

        def go_roles
          fetch(:go_roles, :app)
        end

        #
        # Go cap tasks
        #
        namespace :go do
          desc 'Build the Go application'
          task :start, :roles => go_roles, :except => {:no_release => true} do
            run build_app
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  CapistranoGo::CapistranoIntegration.load_into(Capistrano::Configuration.instance)
end
