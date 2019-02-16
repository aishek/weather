# Weather

[![Build Status](https://travis-ci.org/aishek/weather.svg?branch=master)](https://travis-ci.org/aishek/weather)

Утилита командной строки, которая возвращает информацию о погоде для указанного города.

    bin/weather --service openweathermap --city berlin

## Использование библиотеки

    require 'weather'
    Weather.get_details(service: 'metaweather', city: 'moscow')

## Добавление нового сервиса

1. напишите код сервиса в `lib/weather/serivce/myservice.rb`
2. в `lib/weather.rb` добавьте `require 'weather/service/myservice'`
