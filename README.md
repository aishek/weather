# Weather

[![Build Status](https://travis-ci.org/aishek/weather.svg?branch=master)](https://travis-ci.org/aishek/weather)

Утилита командной строки, которая возвращает информацию о погоде для указанного города.

    bin/weather --service openweathermap --city berlin

## Использование библиотеки

    require 'weather'

    weather = Weather.new(service: service, api_key: api_key)
    details = weather.get_details(city: city)

    puts "Температура воздуха — #{details[:temperature]} градуса цельсия, ветер #{details[:wind][:speed]} м/с, давление — #{details[:air_pressure]} мм ртутного столба."

## Добавление нового сервиса

1. напишите код сервиса в `lib/weather/serivce/myservice.rb`
2. в `lib/weather.rb` добавьте `require 'weather/service/myservice'`
