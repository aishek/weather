# frozen_string_literal: true

require 'test_helper'

class WeatherTest < Minitest::Test
  def test_return_correct_weather_from_metaweather
    http_client = Module.new do
      def self.get(url)
        case url.to_s
        when 'https://www.metaweather.com/api/location/search/?query=tver'
          '[{"title":"Tver","location_type":"City","woeid":1,"latt_long":"52.516071,13.376980"}]'
        when 'https://www.metaweather.com/api/location/1/'
          '{"consolidated_weather":[{"id":4760592648765440,"weather_state_name":"Light Cloud","weather_state_abbr":"lc","wind_direction_compass":"S","created":"2019-02-17T15:46:52.280246Z","applicable_date":"2019-02-17","min_temp":-0.2733333333333334,"max_temp":13.303333333333333,"the_temp":23,"wind_speed":2,"wind_direction":180,"air_pressure":746,"humidity":70,"visibility":7.7370034001431645,"predictability":70},{"id":4744211911933952,"weather_state_name":"Light Cloud","weather_state_abbr":"lc","wind_direction_compass":"S","created":"2019-02-17T15:46:55.608924Z","applicable_date":"2019-02-18","min_temp":0.6566666666666666,"max_temp":12.123333333333335,"the_temp":11.125,"wind_speed":3.599917891012487,"wind_direction":190.72597017860164,"air_pressure":1024.48,"humidity":73,"visibility":9.414394933587847,"predictability":70},{"id":5832347983282176,"weather_state_name":"Showers","weather_state_abbr":"s","wind_direction_compass":"WSW","created":"2019-02-17T15:46:58.403723Z","applicable_date":"2019-02-19","min_temp":2.3966666666666665,"max_temp":9.293333333333333,"the_temp":7.42,"wind_speed":8.344811324978128,"wind_direction":248.8744433320873,"air_pressure":1019.0799999999999,"humidity":83,"visibility":8.900210272011453,"predictability":73},{"id":4726580030996480,"weather_state_name":"Showers","weather_state_abbr":"s","wind_direction_compass":"W","created":"2019-02-17T15:47:01.836974Z","applicable_date":"2019-02-20","min_temp":4.456666666666666,"max_temp":8.793333333333333,"the_temp":7.365,"wind_speed":9.055275197667621,"wind_direction":270.2496140694236,"air_pressure":1024.815,"humidity":80,"visibility":10.87741340571065,"predictability":73},{"id":4601936724623360,"weather_state_name":"Heavy Cloud","weather_state_abbr":"hc","wind_direction_compass":"WNW","created":"2019-02-17T15:47:04.374618Z","applicable_date":"2019-02-21","min_temp":1.0599999999999998,"max_temp":7.13,"the_temp":5.96,"wind_speed":8.074380475994193,"wind_direction":287.31460711707655,"air_pressure":1031.8200000000002,"humidity":87,"visibility":8.659118249423368,"predictability":71},{"id":5777862296600576,"weather_state_name":"Light Cloud","weather_state_abbr":"lc","wind_direction_compass":"NE","created":"2019-02-17T15:47:07.219478Z","applicable_date":"2019-02-22","min_temp":-1.8200000000000003,"max_temp":6.246666666666667,"the_temp":4.24,"wind_speed":5.63926495930433,"wind_direction":56.13728301035569,"air_pressure":1047.35,"humidity":76,"visibility":9.997862483098704,"predictability":70}],"time":"2019-02-17T16:50:40.521151+01:00","sun_rise":"2019-02-17T07:19:27.420642+01:00","sun_set":"2019-02-17T17:22:21.901009+01:00","timezone_name":"LMT","parent":{"title":"Germany","location_type":"Country","woeid":23424829,"latt_long":"51.164181,10.454150"},"sources":[{"title":"BBC","slug":"bbc","url":"http://www.bbc.co.uk/weather/","crawl_rate":180},{"title":"Forecast.io","slug":"forecast-io","url":"http://forecast.io/","crawl_rate":480},{"title":"HAMweather","slug":"hamweather","url":"http://www.hamweather.com/","crawl_rate":360},{"title":"Met Office","slug":"met-office","url":"http://www.metoffice.gov.uk/","crawl_rate":180},{"title":"OpenWeatherMap","slug":"openweathermap","url":"http://openweathermap.org/","crawl_rate":360},{"title":"Weather Underground","slug":"wunderground","url":"https://www.wunderground.com/?apiref=fc30dc3cd224e19b","crawl_rate":720},{"title":"World Weather Online","slug":"world-weather-online","url":"http://www.worldweatheronline.com/","crawl_rate":360},{"title":"Yahoo","slug":"yahoo","url":"http://weather.yahoo.com/","crawl_rate":180}],"title":"Berlin","location_type":"City","woeid":1,"latt_long":"52.516071,13.376980","timezone":"Europe/Moscow"}' # rubocop:disable LineLength
        else raise NotImplementedError
        end
      end
    end

    assert do
      Weather.new(
        Weather::Service::Metaweather.new(http_client: http_client)
      ).get_details(city: 'tver') == {
        temperature: 23,
        wind: {
          speed: 2,
          direction: 180
        },
        air_pressure: 746
      }
    end
  end

  def test_raise_on_no_city_metaweather
    http_client = Module.new do
      def self.get(url)
        case url.to_s
        when 'https://www.metaweather.com/api/location/search/?query=vavilon'
          '[]'
        else raise NotImplementedError
        end
      end
    end

    assert_raises Weather::Service::Metaweather::NoCityFoundError do
      Weather.new(
        Weather::Service::Metaweather.new(http_client: http_client)
      ).get_details(city: 'vavilon')
    end
  end

  def test_raise_on_no_weather_metaweather
    http_client = Module.new do
      def self.get(url)
        case url.to_s
        when 'https://www.metaweather.com/api/location/search/?query=vavilon'
          '[{"title":"Vavilon","location_type":"City","woeid":2,"latt_long":"52.516071,13.376980"}]'
        when 'https://www.metaweather.com/api/location/2/'
          '{"title":"Vavilon","location_type":"City","woeid":1,"latt_long":"52.516071,13.376980","timezone":"Europe/Moscow"}' # rubocop:disable LineLength
        else raise NotImplementedError
        end
      end
    end

    assert_raises Weather::Service::Metaweather::NoWeatherDetailsError do
      Weather.new(
        Weather::Service::Metaweather.new(http_client: http_client)
      ).get_details(city: 'vavilon')
    end
  end
end
