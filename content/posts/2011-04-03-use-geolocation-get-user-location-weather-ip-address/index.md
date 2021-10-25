---
title: "How To: Use geolocation to get a user's location and weather from IP address"
author: Myles Gray
type: posts
date: 2011-04-03T18:11:47+00:00
lastmod: 2021-09-02T13:45:00+00:00
description: "This is a post about how to use geolocation to get a user's location and weather from their IP address."
url: /miscellaneous/use-geolocation-get-user-location-weather-ip-address/
aliases: /software/use-geolocation-get-user-location-weather-ip-address/
categories:
  - Miscellaneous
tags:
  - php
  - website
---

For those of you wondering how weather detection works (had it on the old site), it works through using a geolocation API to look up your IP address and map it against a database of IP locations, which then queries the Yahoo! Weather API. This can be handy for changing your site's background to match the weather or the local time of the user. 

_Updated 15/05/2012 - Changes to Yahoo! APIs fixed in newest version below._

First we need to assign the user's IP address from the user agent to a variable.

```php
if (!empty($_SERVER['HTTP_CLIENT_IP']))
  {
    $ip=$_SERVER['HTTP_CLIENT_IP'];
  }
  elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR']))
  {
    $ip=$_SERVER['HTTP_X_FORWARDED_FOR'];
  }
  else
  {
    $ip=$_SERVER['REMOTE_ADDR'];
  }
```

Now we need to get define the variable that passes the string from here to the master PHP file.

```php
$weather = getWeather($ip);
```

Next we implement the main function of this file that contains the whole process, and calls all the other functions and requests.

```php
function getWeather($ip){
```

Next we use [ipinfodb.com](https://www.ipinfodb.com)'s API to get the latitude and longitude for the user's IP address. We then get the XML response from the server and assign it to the $location_xml variable. You will need to get an API key from them [here](https://www.ipinfodb.com/register) (it's free). Don't forget to plug in your API key into the below URL.

```php
$url = "http://api.ipinfodb.com/v2/ip_query.php?key=[YOUR-API-KEY-HERE]&ip=".$ip."&timezone=false";
$location_xml = get_response($url);
```

Then we parse the XML response with regex to find the latitude and longitude and assign them to variables.

```php
$lat = get_match('/(.*)(.*)
```

We then plug the latitude and longitude into the reverse geo-coder from Yahoo!, this will give us Yahoo!'s WOEID for the location (we use this to lookup the Yahoo! weather API later). And get the response from the server.

```php
$api_url = "http://where.yahooapis.com/geocode?q=".$lat.",+".$long."&gflags=R&appid=[YOUR-APP-ID]";
$response = get_response($api_url);
```

Next up, regex to match the WOEID from the XML response

```php
$woeid =  get_match('/(.*)
```

The WOEID is then passed into the Yahoo! weather API.

```php
$yahoo_url = "http://weather.yahooapis.com/forecastrss?w=".$woeid;
```

The response is retrieved from the Yahoo weather server.

```php
$yahoo_response = get_response($yahoo_url);
```

Regex again, this time to extract the weather code from Yahoo!'s XMl response. This is then passed into the getWeather function.

```php
$weather_code = get_match('/  code="(.*)"/isU',$yahoo_response);
return getWeatherCode($weather_code);
}
```

This function is very simplistic. All it really does is group the weather codes into arrays, this way we don't have to write a comment for every weather condition as we have grouped the similar ones together. It then takes the groups and assigns a text response to them.

```php
function getWeatherCode($code){
    $storm          = array(0,1,2,3,4,17,35,37,38,39,40,45,47);
    $snow           = array(13,14,15,16,18,25,41,42,46);
    $fog            = array(19,20,21,22);
    $windy          = array(23,24);
    $rain           = array(5,6,7,8,9,10,11,12);
    $cloudy         = array(26,28,27);
    $partlycloudy       = array(29,30,44);
    $clear          = array(33,34,32,31,36);
```

Here we use `if` statements to assign the text responses to the grouped weather code arrays. _Smart/sarcastic responses are optional._

```php
  if(in_array($code,$storm)){
        return "Storms in movies never end well, so get inside. NOW.";
    } else if(in_array($code,$snow)){
        return "It's either Eyjafjallajokull or it's snowing";
    }else if(in_array($code,$fog)){
        return "Foggy... like Stevie Wonder in a maze";
    }else if(in_array($code,$windy)){
        return "Dayum it's windy outside";
    }else if(in_array($code,$rain)){
        return "It's wetter than a rainforst outside";
    }else if(in_array($code,$cloudy)){
        return "Dark and dingey, don't you love where you live?";
    }else if(in_array($code,$partlycloudy)){
        return "Partly Cloudy, like last nights memories";
    }else if(in_array($code,$clear)){
        return "Ahh tranquility :)";
    }else{
        return "Your location is so remote I don't know what the weather is...";
    }
  }
```

This function takes the URL's inserted above and then parses the info so just what we need from the page remains.

```php
function get_response($url){
    $request = $url;
        $postargs = 'u='.urlencode('c').'&p='.urlencode('GMXX6091');
        $ch = curl_init($request);

        curl_setopt($ch, CURLOPT_VERBOSE, 1);
        curl_setopt($ch, CURLOPT_NOBODY, 0);
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_USERAGENT, '');
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

        $response = curl_exec($ch);
        $responseInfo = curl_getinfo($ch);
        curl_close($ch);
        return $response;
}
```

This last function regex's the parameters passed into it and returns only one match.

```php
function get_match($regex,$content){
    preg_match($regex,$content,$matches);
    return $matches[1];
}
```

You will then need to include the file in your page above where you call it using (assuming you called it `weather.php`):

```php
include "weather.php";
```

Then call the function from the file:

```php
echo $weather_class;
```

Why not follow [@mylesagray on Twitter][1] for more like this!

 [1]: https://twitter.com/mylesagray