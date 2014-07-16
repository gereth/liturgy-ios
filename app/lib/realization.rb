
class Realization
  class <<self

    def get(location, channels, &callback)

      url = config[:api_url] + "?location=#{location}&channels=#{channels}"
      BW::HTTP.get(url, credentials: {username: 'api', password: config[:api_key]}) do |resp|
        realization = if resp.ok?
          BW::JSON.parse(resp.body)
        else
          # The poller is terminated and UI should go back to prev screen
          {error: resp}
        end
        callback.call(realization)
      end
    end

    def format_channels(channels)
      channels
    end

    def config
      @config ||= {
        api_key: config_get("API_KEY"),
        api_url: config_get("API_URL")
      }
    end

    def config_get(key)
      NSBundle.mainBundle.infoDictionary[key]
    end
  end

end