module ADCDownload
  class Client < Spaceship::Client
    attr_accessor :download_cookie

    def self.hostname
      "https://developer.apple.com/services-account/#{PROTOCOL_VERSION}/"
    end

    # Fetches the latest API Key from the Apple Dev Portal
    def api_key
      cache_path = "/tmp/spaceship_api_key.txt"
      begin
        cached = File.read(cache_path)
      rescue Errno::ENOENT
      end
      return cached if cached
      landing_url = "https://developer.apple.com/account/"
      logger.info("GET: " + landing_url)
      response = @client.get(landing_url)
      headers = response.headers
      results = headers['location'].match(/.*appIdKey=(\h+)/)
      if (results || []).length > 1
        api_key = results[1]
        File.write(cache_path, api_key) if api_key.length == 64
        return api_key
      else
        raise "Could not find latest API Key from the Dev Portal - the server might be slow right now"
      end
    end

    def get_cookies(user, password)
      jar = HTTP::CookieJar.new(store: :hash, filename: 'cookies.txt')
      params = {
        appIdKey: api_key,
        accNameLocked: "false",
        language: "US-EN",
        path: '/account/',
        rv: "1",
        Env: "PROD",
        appleId: user,
        accountPassword: password
      }
      response = request(:post, "https://idmsa.apple.com/IDMSWebAuth/authenticate", params)
      jar.parse(response['Set-Cookie'], "http://idmsa.apple.com")
      if response['Set-Cookie'] =~ /myacinfo=(\w+);/
        @cookie = "myacinfo=#{$1};"
      else
        raise InvalidUserCredentialsError.new, response
      end

      response = request(:get, "#{self.class.hostname}/downloadws/listDownloads.action")
      jar.parse(response['Set-Cookie'], "https://developer.apple.com")
      
      if response['Set-Cookie'] =~ /ADCDownloadAuth=([^;]+);/
        @download_cookie = "ADCDownloadAuth=#{$1};"
      else
        raise InvalidUserCredentialsError.new, response
      end
      
      jar.each {|c| c.httponly = false}
      jar.save(".adccookies", format: :cookiestxt, session: true)
    end

  end
end
