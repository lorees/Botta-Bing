#!/usr/bin/env bash 
# Created by Loree Sebastien 2/18/2023
# Gets the current weather based on ZIP Code from openweather maps
# GET API KEY https://home.openweathermap.org/api_keys

source params;
WEATHER_FILE="weather.json";
TIME_INTERVAL="1800"; # Check Once 30mins

# while [ 1 -eq 1 ]
# do
    cat "$WEATHER_FILE";
    rm -f ${ICON} *.png*;

    # Get Current Weather File
    # https://api.openweathermap.org/data/2.5/weather?zip=11433,us&appid=ad8ccb3f9e9b5c3bb8a803eadbd0ee87
    wget "https://api.openweathermap.org/data/2.5/weather?zip=${ZIP},us&appid=${WEATHER_APPID}" -O "$WEATHER_FILE";
    
    # Generate JSON Values from Weather File
    WEATHER_CONDITIONS=(`jq -r '.weather[].main' $WEATHER_FILE`);
    WEATHER_ICON=(`jq -r '.weather[].icon' $WEATHER_FILE`);
    WEATHER_DESCRIPTION=(`jq -r '.weather[].description' $WEATHER_FILE`);
    VALUES=(`jq -r '.main[]' $WEATHER_FILE`);

    # Temperture Values
    K_TEMP=${VALUES[0]};
    K_FEELS_LIKE=${VALUES[1]};
    K_TEMP_MIN=${VALUES[2]};
    K_TEMP_MAX=${VALUES[3]};
    PRESSURE=${VALUES[4]};
    HUMIDITY=${VALUES[5]};

    # Convert Kelvin to Farenheit
    # ($TEMP − 273.15) × 9/5 + 32 = 37.13°F
    TEMP=$(echo "scale=2;$K_TEMP-273.15" | bc);
    TEMP=$(echo "scale=2;$TEMP*(9/5)+32" | bc);
    TEMP=${TEMP%.*};
    
    FEELS_LIKE=$(echo "scale=2;$K_FEELS_LIKE-273.15" | bc);
    FEELS_LIKE=$(echo "scale=2;$FEELS_LIKE*(9/5)+32" | bc);
    FEELS_LIKE=${FEELS_LIKE%.*};
    
    TEMP_MIN=$(echo "scale=2;$K_TEMP_MIN-273.15" | bc);
    TEMP_MIN=$(echo "scale=2;$TEMP_MIN*(9/5)+32" | bc);
    TEMP_MIN=${TEMP_MIN%.*};

    TEMP_MAX=$(echo "scale=2;$K_TEMP_MAX-273.15" | bc);
    TEMP_MAX=$(echo "scale=2;$TEMP_MAX*(9/5)+32" | bc);
    TEMP_MAX=${TEMP_MAX%.*};
    
    # Wind
    WIND_SPEED=(`jq -r '.wind.speed' $WEATHER_FILE`);
    WIND_SPEED=${WIND_SPEED%.*};
    
    WIND_GUST=(`jq -r '.wind.gust' $WEATHER_FILE`);
    WIND_GUST=${WIND_GUST%.*};

    WIND_DEG=(`jq -r '.wind.deg' $WEATHER_FILE`);

    if [[ $WIND_DEG -ge 0 ]] && [[ $WIND_DEG -le 44 ]];then
        WIND_CARDINAL_DIRECTION="NORTH";

    elif [[ $WIND_DEG -ge 45 ]] && [[ $WIND_DEG -le 89 ]];then
        WIND_CARDINAL_DIRECTION="NORTH-EAST";

    elif [[ $WIND_DEG -ge 90 ]] && [[ $WIND_DEG -le 134 ]];then
        WIND_CARDINAL_DIRECTION="EAST";

    elif [[ $WIND_DEG -ge 135 ]] && [[ $WIND_DEG -le 179 ]];then
        WIND_CARDINAL_DIRECTION="SOUTH-EAST";

    elif [[ $WIND_DEG -ge 180 ]] && [[ $WIND_DEG -le 224 ]];then
        WIND_CARDINAL_DIRECTION="SOUTH";

    elif [[ $WIND_DEG -ge 225 ]] && [[ $WIND_DEG -le 315 ]];then
        WIND_CARDINAL_DIRECTION="SOUTH-WEST";

    elif [[ $WIND_DEG -ge 315 ]] && [[ $WIND_DEG -le 360 ]] ;then
        WIND_CARDINAL_DIRECTION="SOUTH-EAST";
    else 
        WIND_CARDINAL_DIRECTION="No Wind Direction Available";
    fi
  
    # Publish Values 
    echo "export ZIP_CODE=$ZIP">cweather;
    echo "export COUNTRY=$COUNTRY_CODE">>cweather;
    echo "export TEMP=$TEMP">>cweather;
    echo "export FEELS=$FEELS_LIKE">>cweather;
    echo "export LOW=$TEMP_MIN">>cweather;
    echo "export HIGH=$TEMP_MAX">>cweather;
    echo "export PRESSURE=$PRESSURE">>cweather;
    echo "export HUMIDITY=$HUMIDITY">>cweather;

    echo "export WIND_SPEED=$WIND_SPEED">>cweather;
    echo "export WIND_GUST=$WIND_GUST">>cweather;
    echo "export WIND_DEG=$WIND_DEG">>cweather;
    echo "export WIND_CARDINAL_DIRECTION=$WIND_CARDINAL_DIRECTION">>cweather;

    echo "export CONDITIONS=$WEATHER_CONDITIONS">>cweather;
    echo "export DESCRIPTION=$WEATHER_DESCRIPTION">>cweather;
    echo "export ICON=${WEATHER_ICON}.png">>cweather;
    echo "export ICON_URL=http://openweathermap.org/img/w/${WEATHER_ICON}.png">>cweather;
    
    # Get Weather Icon and resize
    chmod 777 "cweather";
    #sudo mv "cweather" $HOME;
    source "cweather";
    wget "${ICON_URL}";
    
    # List Everything 
    cat "cweather";
    ls -alt "cweather" *.png;
    
    # echo "Now Sleeping $TIME_INTERVAL ....";
    rm ${WEATHER_FILE};
   # sleep $TIME_INTERVAL;
# done

