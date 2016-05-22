namespace :codemirror do

  desc "Load all available modes"
  task load: :environment do

    BLACKLIST = ['dockerfile', 'factor', 'handlebars', 'nsis', 'rust']

    puts "Remove old files"
    `rm app/assets/javascripts/codemirror/*.js`

    puts "Updating submodules ..."
    `git submodule foreach git pull origin master`
    a=`find vendor/codemirror/mode/* -name "*.js" -type f -printf '%f\n' | sed 's/\.js//g'`
    valid_modes = []
    a.split("\n").each do |y|
      unless BLACKLIST.include? y
        `mkdir -p app/assets/javascripts/codemirror`
        `cp -rf vendor/codemirror/mode/#{y}/#{y}.js app/assets/javascripts/codemirror/#{y}.js 2> /dev/null`
        if $?.success?
          valid_modes << y
          puts "#{y.inspect} detected as valid mode ..."
        end
      end
    end
    `cp -rf vendor/codemirror/lib/codemirror.js app/assets/javascripts/ 2> /dev/null`
    `cp -rf vendor/codemirror/lib/codemirror.css app/assets/stylesheets/ 2> /dev/null`
    File.open('config/codemirror.yml', 'w+') do |f| 
      f.write ({modes: valid_modes}).to_yaml
    end

  end

end
