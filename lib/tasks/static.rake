namespace :static do
  desc "Export static HTML site to docs/ for GitHub Pages"
  task export: :environment do
    require "fileutils"

    OUTPUT = Rails.root.join("docs")
    BASE_URL = "/poultry_monitor"

    FileUtils.rm_rf(OUTPUT)
    FileUtils.rm_rf(Rails.root.join("public/assets"))

    Rake::Task["db:seed:replant"].invoke
    Rake::Task["tailwindcss:build"].invoke
    Rake::Task["assets:precompile"].invoke

    app = ActionDispatch::Integration::Session.new(Rails.application)
    app.host! "localhost"

    save_page = lambda do |session, relative_path|
      path = OUTPUT.join(relative_path)
      FileUtils.mkdir_p(path.dirname)

      html = session.response.body

      html.gsub!(/(href|src)="\//, '\1="')
      html.gsub!('"/assets/', '"assets/')

      html.sub!("</title>", "</title><base href=\"#{BASE_URL}/\">")

      path.write(html)
      puts "  #{relative_path}"
    end

    puts "Rendering pages..."

    app.get("/")
    save_page.call(app, "index.html")
    save_page.call(app, "farms/index.html")

    Farm.find_each do |farm|
      app.get("/farms/#{farm.id}")
      save_page.call(app, "farms/#{farm.id}/index.html")
    end

    Zone.find_each do |zone|
      app.get("/zones/#{zone.id}")
      save_page.call(app, "zones/#{zone.id}/index.html")
    end

    app.get("/alerts")
    save_page.call(app, "alerts/index.html")

    FileUtils.cp_r Rails.root.join("public/assets/."), OUTPUT.join("assets")
    FileUtils.rm_rf(Rails.root.join("public/assets"))

    puts "\nDone! Static site exported to #{ OUTPUT }"
  end
end
