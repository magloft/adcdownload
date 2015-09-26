module ADCDownload
  module Command
    class Get
      include Commander::Methods
      include Helper::LogHelper
      
      def run
        command :get do |c|
          c.syntax = "adbdownload get [filename]"
          c.summary = "Download file from ADC"
          c.option "--user String", String, "[optional]"
          c.option "--pass String", String, "[optional]"
          c.action do |args, options|
            
            # arguments and validation
            store_path = File.expand_path("~/.adcdownload")
            download_url = args[0]
            download_file = File.basename(download_url)
            error!("Invalid download URL") if !download_url or download_url[0..28] != "http://adcdownload.apple.com/"
            
            # load stored login information
            if !options.user or !options.pass
              if File.exists?(store_path)
                store_contents = JSON.parse(File.open(store_path).read)
                options.user = store_contents["user"]
                options.pass = store_contents["pass"]
              end
            end
            
            # collect login information
            if !options.user or !options.pass
              options.user = ask("User:  ")
              options.pass = ask("Pass:  ") { |q| q.echo = "*" }
            end
            
            # create cookie
            while !valid_cookie?
              info "creating download cookie"
              client = Client.new()
              client.get_cookies(options.user, options.pass)
            end
            
            # store account information
            File.open(store_path, "w") {|f| f.write(JSON.dump({user: options.user, pass: options.pass})) }
            
            # download file
            info "downloading #{download_file}"
            system "wget -c --load-cookies .adccookies -p '#{download_url}' -O #{download_file}"
          end
        end
      end
      
      def valid_cookie?
        if File.exists?(".adccookies")
          existing_cookies = File.open(".adccookies").read
          if existing_cookies =~ /([0-9]+)\tADCDownloadAuth/
            expires = $1
            if Time.at(expires.to_i) > Time.now
              return true
            end
          end
        end
        false
      end
      
    end
  end
end
