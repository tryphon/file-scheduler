require "bundler/gem_tasks"

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov = true
  t.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/}
end

namespace :dist do
  task :playbox do
    dist_dir = "dist/playbox"

    mkdir_p dist_dir
    cp "bin/liquidsoap_demo.liq", "#{dist_dir}/playbox.liq"

    mkdir_p "#{dist_dir}/bin"
    cp "bin/file-scheduler", "#{dist_dir}/bin/file-scheduler"

    sh "rsync -aq --delete --exclude='*~' lib/ #{dist_dir}/lib/"
    
    mkdir_p "#{dist_dir}/files"
  end
end
