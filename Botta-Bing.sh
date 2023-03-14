#!/usr/bin/env bash 
# Loree Sebastien 2/20/2023
# Botta-Bing AI Chatbot for Robots
# Joke Reference https://parade.com/1040121/marynliles/one-liners/

WAV_FILE="sound_detected.wav";
JSON_TRANSCRIPT="transcription.json";
TIMEOUT="7";
CHAT_LOG="CHAT.log";
LINE="------------------------------";

# Variables - Answer Query 
source params;
AI_URL="https://api.openai.com/v1/completions";
################# Functions Begin #################
function MEET_GREET {
    clear;
    GET_DATE_TIME;
    rm -rf cweather && ./artifacts/modules/weather/weather.sh; # Get local weather and cache it
    # Now Listening Message
    greeting_file_name="listening.mp3";
    gtts-cli "Good ${TIME_GREETING}. This is ${BOT_NAME}, What can I help you with?" --lang ${LANG} --tld ${LOCALIZATION} --output "${greeting_file_name}";
    mpg123 -q "${greeting_file_name}" && rm -f "${greeting_file_name}"; 
}

function LISTEN_TRANSCRIBE {
    # rec -b 16 ${WAV_FILE} channels 1 rate 16k silence 1 0.1 .3% -1 4.0 .1% &
    rec -b 16 ${WAV_FILE} channels 1 rate 16k silence 1 0.1 1% -1 5.2 1% &
    p=$!
    
    # Check to see if the file is growing if it does then sound is detected
    sleep 1
    until [ "$var1" != "$var2" ]; do
        var1=`du "${WAV_FILE}"`;
        sleep 1;
        var2=`du "${WAV_FILE}"`;
    done
    echo "Sound Detected"

    # Check for silience, if silene is detected then end recording
    until [ "$var1" == "$var2" ]; do
        var1=`du "${WAV_FILE}"`;
        sleep 1;
        var2=`du "${WAV_FILE}"`;
    done
    echo "Silence Detected";
    kill $p;
  
    # Capture output
    ON_HOLD_MESSAGE; # On Hold Confirmation Message
    
    # Choose Transcription Model from "params file"
    if [ "${TRANSCRIBE}" = "OPENAI_WHISPER" ]; then
        OPENAI_WHISPER;  # Whisper Transcribe 
    else
        GOOGLE_CLOUD_TRANSCRIBE; # Google Transcription API Based
    fi
    CALL_MODULES; # Call Modules
}

# google API based transcription service. requires API keys and setup 
function GOOGLE_CLOUD_TRANSCRIBE {
    # Transcribe Recording
    gcloud ml speech recognize ${WAV_FILE} \
        --language-code=en-US \
        --enable-automatic-punctuation \
        --filter-profanity > ${JSON_TRANSCRIPT};
    QUESTION=`cat ${JSON_TRANSCRIPT} | jq -r '.results[0].alternatives[0].transcript'`;
}

# New Openai Whisper Transcription - No API key Needed
function OPENAI_WHISPER {
    whisper ${WAV_FILE} --task transcribe --model tiny.en --output_format txt > /dev/null 2>&1;
    QUESTION=`cat ${WAV_FILE}.txt`;
    rm -f ${WAV_FILE}.txt;
}

function SEND_TO_CHATGPT {
    # Adjust Output
    PREFIX="You:";
    POSTFIX="?\nFriend:";
    QUERY_CHATBOT="${PREFIX} ${QUESTION} ${POSTFIX}";
    printf "\n\n${QUESTION}\n";
    ANSWER_QUESTION;
}

function ANSWER_QUESTION {
    curl "${AI_URL}" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d '{
        "model": "text-davinci-003",
        "prompt": "'"${QUERY_CHATBOT}"'",
        "temperature": 0.2,
        "max_tokens": 500,
        "top_p": 1.0,
        "frequency_penalty": 0.5,
        "presence_penalty": 0.0,
        "stop": ["You:"]
    }'>${OUTPUT_FILE};

    # Get chat response text
    CHAT_RESPONSE=`cat chat_response.json | jq -r '.choices[0].text'`;
    echo ${CHAT_RESPONSE}>${CHAT_RESPONSE_FILE};
    PROCESS_RESPONSE;

    # Information Credits
    greeting_file_name="info_provied_by.mp3";
    gtts-cli "This Information Was Provided By ChatGPT." --lang ${LANG} --tld ${LOCALIZATION} --output "${greeting_file_name}";
    mpg123 -q "${greeting_file_name}" && rm -f "${greeting_file_name}"; 
    READ_RESPONSE;

    # Print Question and Answer
    clear; # Clear the screen
    printf "\n\nQUESTION:\n";
    printf "${QUESTION}?";
    printf "\n\nANSWER:\n";
    printf "${CHAT_RESPONSE}";
}

function PROCESS_RESPONSE {
    # Remove Old Response
    rm -f ${CHAT_RESPONSE_MP3}; 

    # Make New Response
    gtts-cli -f ${CHAT_RESPONSE_FILE} --lang ${LANG} --tld ${LOCALIZATION} --output ${CHAT_RESPONSE_MP3};
}

function READ_RESPONSE {

    # For Windows use mpg123 https://www.mpg123.de/download
    mpg123 -q ${CHAT_RESPONSE_MP3};
    
    # Make Comments Randomly 1 out of 3 X's
    RANGE="5"; 
    yes_no=$RANDOM;
    let "yes_no %= $RANGE";

    if [ $yes_no = "1" ];then 
        MAKE_COMMENTS;
    fi
}

# Modules 
function CALL_MODULES {     
    # Read back what you heard
    # gtts-cli "I heard ${QUESTION}. Thank you, Now Checking" --lang ${LANG} --tld ${LOCALIZATION} --output "${greeting_file_name}";

    GET_DATE_TIME; # Date_Time Module
    if [[ $QUESTION == *"y day"* ]] || [[ $QUESTION == *"hat's today"* ]] || [[ $QUESTION == *"today's dat"* ]] || [[ $QUESTION == *"today's date"* ]] || [[ $QUESTION == *"y date"* ]]  || [[ $QUESTION == *"hat day is it"* ]] || [[ $QUESTION == *"hat is the day"* ]] || [[ $QUESTION == *"hat is today"* ]]  ; then
        echo "Today is the ${MY_DAY}${DAY_POST_FIX} day of ${LONG_MONTH} in the year ${MY_YEAR}.">${CHAT_RESPONSE_FILE};
        PROCESS_RESPONSE;
        READ_RESPONSE;
    elif [[ $QUESTION == *"y time"* ]] || [[ $QUESTION == *"he time"* ]] || [[ $QUESTION == *"hat time is"* ]]; then
        echo "The current time is: $MY_HOUR:$MY_MIN $SUFFIX">${CHAT_RESPONSE_FILE};
        PROCESS_RESPONSE;
        READ_RESPONSE;
    elif [[ $QUESTION == *"y weather"* ]] || [[ $QUESTION == *"he weather"* ]] || [[ $QUESTION == *"hat weather"* ]] || [[ $QUESTION == *"y local weather"* ]]; then
        GET_WEATHER;
    elif [[ $QUESTION == *"eather by city"* ]] || [[ $QUESTION == *"eather for City"* ]]; then
        GET_WEATHER_BY_CITY;
    elif [[ $QUESTION == *"eather by zip"* ]] || [[ $QUESTION == *"eather for Zip"* ]] || [[ $QUESTION == *"eather for ZIP"* ]]; then
        GET_WEATHER_BY_ZIP;
    elif [[ $QUESTION == *"e a jok"* ]] || [[ $QUESTION == *"eed a joke"* ]] || [[ $QUESTION == *"e laugh"* ]] || [[ $QUESTION == *"tell me a funny"* ]]; then
        MAKE_JOKES;
    elif [[ $QUESTION == *"lay Jeopardy"* ]] || [[ $QUESTION == *"lay jeopardy"* ]]; then
        ./artifacts/modules/jeopardy/jeopardy.sh;
    elif [[ $QUESTION == *"andom New"* ]] || [[ $QUESTION == *"andom new"* ]]; then
        ./artifacts/modules/news/news_api.sh;
    elif [[ $QUESTION == *"mergency call"* ]] || [[ $QUESTION == *"mergency Call"* ]] || [[ $QUESTION == *"mergency emergency"* ]] || [[ $QUESTION == *"mergency Emergency"* ]] || [[ $QUESTION == *"elp help"* ]] || [[ $QUESTION == *"all for help"* ]]; then
        CALL_FOR_HELP;
    elif [[ $QUESTION == *"e have a problem"* ]] || [[ $QUESTION == *"e Have a problem"* ]]; then 
        WE_HAVE_A_PROBLEM;
    elif [[ $QUESTION == *"alk nast"* ]] || [[ $QUESTION == *"alk Nast"* ]] || [[ $QUESTION == *"alk smack"* ]] || [[ $QUESTION == *"alk Smack"* ]]; then 
        TALK_SMACK;
    elif [[ $QUESTION == *"lay podcast"* ]] || [[ $QUESTION == *"lay a podcast"* ]] || [[ $QUESTION == *"lay my podcast"* ]]; then 
        ./artifacts/modules/podcasts/play_podcasts.sh;
    elif [[ $QUESTION == *"lay meditati"* ]] || [[ $QUESTION == *"lay relaxati"* ]] || [[ $QUESTION == *"lay cal"* ]]; then 
         ./artifacts/modules/meditation/meditation.sh;
    elif [[ $QUESTION == *"tore promotion"* ]] || [[ $QUESTION == *"tore Promotion"* ]] || [[ $QUESTION == *"y promo"* ]] || [[ $QUESTION == *"y Promo"* ]]; then 
         ./artifacts/modules/announcement/play_announcement.sh;
    elif [[ $QUESTION == "null" ]] || [[ $QUESTION == "" ]]; then         greeting_file_name="Heard_Nothing.mp3";
        gtts-cli "Please Repeat, I Don't Think I Heard You Properly." --lang ${LANG} --tld ${LOCALIZATION} --output "${greeting_file_name}";
        mpg123 -q "${greeting_file_name}" && rm -f "${greeting_file_name}"; 
    else 
        SEND_TO_CHATGPT;
    fi
}

function GET_DATE_TIME {
    # Variables Time & Date
    MY_HOUR=$(date +%H); # Hour
    MY_MIN=$(date +%M); # Min
    SUFFIX="AM ${TIME_ZONE}";
    FIND_DATE_INFO; # Adjust the month to the long month

    # Set GREETING
    if [ $MY_HOUR -le 11 ]; then
    TIME_GREETING="Morning";
    elif [ $MY_HOUR -le 17 ]; then
    TIME_GREETING="Afternoon";
    elif [ $MY_HOUR -gt 17 ]; then
    TIME_GREETING="Evening";
    fi

    # Convert 24hr Time to 12hr Time
    if [ $MY_HOUR -gt 11 ]; then 
        SUFFIX="PM ${TIME_ZONE}";
        MY_HOUR=$(($MY_HOUR-12));
    fi  
}

function FIND_DATE_INFO {
    # Date
    MY_MONTH=$(date +%m); # Month
    MY_DAY=$(date +%d); # The day \ date
    DOW=$(date +%u); # Day of the week
    MY_YEAR=$(date +20%y); # tThe Year
    
    if [[ $MY_DAY == 11 ]];then 
        DAY_POST_FIX="th";    
    elif [[ $MY_DAY == *1 ]];then 
        DAY_POST_FIX="st";
    elif [[ $MY_DAY == *2 ]];then 
        DAY_POST_FIX="nd";
    elif [[ $MY_DAY == *3 ]];then 
        DAY_POST_FIX="rd";
    else  
        DAY_POST_FIX="th";
    fi

    # Day of the Wook
    if [ $DOW -eq "01" ]; then
        LONG_DOW="Monday";
    elif [ $DOW -eq "02" ]; then
        LONG_DOW="Tuesday";
    elif [ $DOW -eq "03" ]; then
        LONG_DOW="Wednesday";
    elif [ $DOW -eq "04" ]; then
        LONG_DOW="Thursday";
    elif [ $DOW -eq "05" ]; then
        LONG_DOW="Friday";
    elif [ $DOW -eq "06" ]; then
        LONG_DOW="Saturday";
    elif [ $DOW -eq "07" ]; then
        LONG_DOW="Sunday";
    fi

    # Month 
    if [ $MY_MONTH -eq "01" ]; then
        LONG_MONTH="January";
    elif [ $MY_MONTH -eq "02" ]; then
        LONG_MONTH="Febuary";
    elif [ $MY_MONTH -eq "03" ]; then
        LONG_MONTH="March";
    elif [ $MY_MONTH -eq "04" ]; then
        LONG_MONTH="April";
    elif [ $MY_MONTH -eq "05" ]; then
        LONG_MONTH="May";
    elif [ $MY_MONTH -eq "06" ]; then
        LONG_MONTH="June";
    elif [ $MY_MONTH -eq "07" ]; then
        LONG_MONTH="July";
    elif [ $MY_MONTH -eq "08" ]; then
        LONG_MONTH="August";
    elif [ $MY_MONTH -eq "09" ]; then
        LONG_MONTH="September";
    elif [ $MY_MONTH -eq "10" ]; then
        LONG_MONTH="October";
    elif [ $MY_MONTH -eq "11" ]; then
        LONG_MONTH="November";
    elif [ $MY_MONTH -eq "12" ]; then
        LONG_MONTH="December";
    fi
}

function GET_WEATHER {
    FIND_DATE_INFO;

    # Check age of weather file
    find . -name 'cweather' -mmin +180 -delete > /dev/null; # Get weather everry 3 hrs
    if [ ! -f cweather ]; then
           ./artifacts/modules/weather/weather.sh;
    fi
    
    source cweather;
    echo "All Weather Information Was Provided By, Open Weather Map Dot Org." > ${CHAT_RESPONSE_FILE};
    echo "The Current Weather for Zip Code ${ZIP_CODE} is as follows:" >> ${CHAT_RESPONSE_FILE};
    echo "The Current Temperture is ${TEMP} Degrees Farenheight, but it Feels Like ${FEELS} Degrees Farenheight." >> ${CHAT_RESPONSE_FILE}; 
    echo "Winds are from the ${WIND_CARDINAL_DIRECTION} direction. Wind Speed is ${WIND_SPEED} Miles Per Hour and Wind Gusts are at ${WIND_GUST} Miles Per Hour.">>${CHAT_RESPONSE_FILE};
    echo "The High Temperture for Today is ${HIGH} Degrees Farenheight with a Low of ${LOW} Degrees Farenheight." >> ${CHAT_RESPONSE_FILE};
    echo "The Conditions are ${CONDITIONS} with a Humidity of ${HUMIDITY} percent" >> ${CHAT_RESPONSE_FILE};
    echo "The Barometer or Rather the Atmospheric Pressure measures ${PRESSURE} Bars. Please Dress Accordingly." >> ${CHAT_RESPONSE_FILE};
    PROCESS_RESPONSE;
    READ_RESPONSE;
}

function GET_WEATHER_BY_CITY {
    CITY=`echo $QUESTION | \
        sed 's/[cC]omputer //'| \
        sed 's/[Ww]eather for //'| \
        sed 's/\.//' | \
        sed 's/[Pp]ewter, //' | \
        sed 's/[Uu][Ss] //' | \
        sed 's/[Cc]ity //' | \
        sed 's/[Ff][Oo][Rr]//' | \
        sed 's/\,//' | \
        sed 's/\?//' | \
        sed 's/ /+/'`;
    echo $CITY;

    FIND_DATE_INFO;
    ./artifacts/modules/weather/weather_by_city.sh ${CITY};
    CITY=`echo $CITY | sed 's/+//'`;
    source cweather;
    echo "All Weather Information Was Provided By, Open Weather Map Dot Org." > ${CHAT_RESPONSE_FILE};
    echo "The Current Weather for City ${CITY} is as follows:" >> ${CHAT_RESPONSE_FILE};
    echo "The Current Temperture is ${TEMP} Degrees Farenheight, but it Feels Like ${FEELS} Degrees Farenheight." >> ${CHAT_RESPONSE_FILE}; 
    echo "Winds are from the ${WIND_CARDINAL_DIRECTION} direction. Wind Speed is ${WIND_SPEED} Miles Per Hour and Wind Gusts are at ${WIND_GUST} Miles Per Hour.">>${CHAT_RESPONSE_FILE};
    echo "The High Temperture for Today is ${HIGH} Degrees Farenheight with a Low of ${LOW} Degrees Farenheight." >> ${CHAT_RESPONSE_FILE};
    echo "The Conditions are ${CONDITIONS} with a Humidity of ${HUMIDITY} percent" >> ${CHAT_RESPONSE_FILE};
    echo "The Barometer or Rather the Atmospheric Pressure measures ${PRESSURE} Bars." >> ${CHAT_RESPONSE_FILE};
    rm -f cweather;
    PROCESS_RESPONSE;
    READ_RESPONSE;
}

function GET_WEATHER_BY_ZIP {
    ZIP_CODE=`echo $QUESTION | \
        sed 's/[cC]omputer //'| \
        sed 's/[Ss]hooter //'| \
        sed 's/[Ww]eather [Ff]or //'| \
        sed 's/\.//' | \
        sed 's/[Pp]ewter, //' | \
        sed 's/[Zz][Ii][Pp] //' | \
        sed 's/[Cc][Oo][Dd][Ee]//' | \
        sed 's/ //' | \
        sed 's/\,//g' | \
        sed 's/\?//g'`;
    echo $ZIP_CODE;
    FIND_DATE_INFO;
    ./artifacts/modules/weather/weather_by_zip.sh ${ZIP_CODE};
    source cweather;
    echo "All Weather Information Was Provided By, Open Weather Map Dot Org." > ${CHAT_RESPONSE_FILE};
    echo "The Current Weather for Zip Code ${ZIP_CODE} is as follows:" >> ${CHAT_RESPONSE_FILE};
    echo "The Current Temperture is ${TEMP} Degrees Farenheight, but it Feels Like ${FEELS} Degrees Farenheight." >> ${CHAT_RESPONSE_FILE}; 
    echo "Winds are from the ${WIND_CARDINAL_DIRECTION} direction. Wind Speed is ${WIND_SPEED} Miles Per Hour and Wind Gusts are at ${WIND_GUST} Miles Per Hour.">>${CHAT_RESPONSE_FILE};
    echo "The High Temperture for Today is ${HIGH} Degrees Farenheight with a Low of ${LOW} Degrees Farenheight." >> ${CHAT_RESPONSE_FILE};
    echo "The Conditions are ${CONDITIONS} with a Humidity of ${HUMIDITY} percent" >> ${CHAT_RESPONSE_FILE};
    echo "The Barometer or Rather the Atmospheric Pressure measures ${PRESSURE} Bars. Please Dress Accordingly." >> ${CHAT_RESPONSE_FILE};
    rm -f cweather; 
    PROCESS_RESPONSE;
    READ_RESPONSE;
}

function MAKE_COMMENTS {
    # Get remarks 
    REMARKS_FILE="artifacts/modules/remarks/remarks";

    # Make array out of line in remarks file
    IFS=$'\r\n' GLOBIGNORE='*' command eval  'ALL_REMARKS=($(cat $REMARKS_FILE))';

    # Get total mnumber of elements in the array
    TOTAL_REMARKS=${#ALL_REMARKS[@]};

    # Get a  Random Number and use it to pick;
    RANGE=$TOTAL_REMARKS;
    R_COMMENT=$RANDOM; 
    let "R_COMMENT %= $TOTAL_REMARKS"; # generate random integer

    # make Random comment.
    echo "COMMENT: ${ALL_REMARKS[$R_COMMENT]}";
    
    # GoodBye Message
    greeting_file_name="helpful.mp3";
    gtts-cli "HEY! ${ALL_REMARKS[$R_COMMENT]}" --lang ${LANG} --tld ${LOCALIZATION} --output "${greeting_file_name}";
    mpg123 -q "artifacts/modules/sounds/chime.mp3";
    mpg123 -q "${greeting_file_name}" && rm -f "${greeting_file_name}"; 
}

function TALK_SMACK {
    # Get remarks 
    REMARKS_FILE="artifacts/modules/remarks/remarks_harsh";

    # Make array out of line in remarks file
    IFS=$'\r\n' GLOBIGNORE='*' command eval  'ALL_REMARKS=($(cat $REMARKS_FILE))';

    # Get total mnumber of elements in the array
    TOTAL_REMARKS=${#ALL_REMARKS[@]};

    # Get a  Random Number and use it to pick;
    RANGE=$TOTAL_REMARKS;
    R_COMMENT=$RANDOM; 
    let "R_COMMENT %= $TOTAL_REMARKS"; # generate random integer

    # make Random comment.
    echo "COMMENT: ${ALL_REMARKS[$R_COMMENT]}";
    
    # GoodBye Message
    greeting_file_name="rude.mp3";
    mpg123 -q "artifacts/modules/sounds/beep-05.mp3";
    gtts-cli "HELLO! HI! ${ALL_REMARKS[$R_COMMENT]}" --lang ${LANG} --tld ${LOCALIZATION} --output "${greeting_file_name}";
    mpg123 -q "${greeting_file_name}" && rm -f "${greeting_file_name}"; 
}

function MAKE_JOKES {
    # Get remarks 
    JOKES_FILE="artifacts/modules/jokes/jokes";

    # Make array out of line in remarks file
    IFS=$'\r\n' GLOBIGNORE='*' command eval  'ALL_JOKES=($(cat $JOKES_FILE))';

    # Get total mnumber of elements in the array
    TOTAL_JOKES=${#ALL_JOKES[@]};

    # Get a  Random Number and use it to pick;
    RANGE=$TOTAL_JOKES;
    FIND_JOKE=$RANDOM;
    let "FIND_JOKE %= $RANGE";

    # make Random comment.
    echo && echo "JOKE: ${ALL_JOKES[$FIND_JOKE]}" && echo;
    
    # Tell a Joke
    greeting_file_name="jokes.mp3";
    gtts-cli "HERE IS A JOKE FOR YOU. ${ALL_JOKES[$FIND_JOKE]}  " --lang ${LANG} --tld ${LOCALIZATION} --output "${greeting_file_name}";
    mpg123 -q ${greeting_file_name} && mpg123 -q "artifacts/modules/sounds/very-infectious-laughter-117727.mp3" && rm -f "${greeting_file_name}"; 
}

function ON_HOLD_MESSAGE {
    # Get remarks 
    CONFIRM_FILE="artifacts/modules/on_hold/on_hold";

    # Make array out of line in remarks file
    IFS=$'\r\n' GLOBIGNORE='*' command eval 'ALL_CONFIRM=($(cat $CONFIRM_FILE))';

    # Get total mnumber of elements in the array
    TOTAL_CONFIRMATIONS=${#ALL_CONFIRM[@]};

    # Get a  Random Number and use it to pick.
    RANGE=$TOTAL_CONFIRMATIONS;
    FIND_CONFIRMATION=$RANDOM;
    let "FIND_CONFIRMATION %= $RANGE";

    # Make a  Random Comment.
    echo && echo "WAIT MESSAGE: ${ALL_CONFIRM[$FIND_CONFIRMATION]}" && echo;
    
    # Hold Message
    greeting_file_name="please_wait.mp3";
    # gtts-cli "HERE IS YOUR JOKE!" --lang ${LANG} --tld ${LOCALIZATION} --output "${greeting_file_name}";
    gtts-cli "${ALL_CONFIRM[$FIND_CONFIRMATION]}  " --lang ${LANG} --tld ${LOCALIZATION} --output "${greeting_file_name}";
    mpg123 -q ${greeting_file_name} && rm -f "${greeting_file_name}"; 
}

function READ_NEWS {
    # Default value if value is missing
    if [ -z ${NEWS_FREQUENCY} ];then
        NEWS_FREQUENCY="10";
    fi  
    
    # Pick a number ad play news if it equals 1
    RANGE="${NEWS_FREQUENCY}"; 
    yes_no=$RANDOM;
    let "yes_no %= $RANGE";
    # echo $yes_no;

    if [ $yes_no = "1" ];then 
        ./artifacts/modules/news/news_api.sh; 
    fi
}

function CALL_FOR_HELP {
    QUESTION=`echo $QUESTION > sed 's/\.//'`;

    # Help Message
    echo "HELP! THERE IS SOMEONE IN DISTRESS! HELP! PLEASE CALL FOR HELP!" > ${CHAT_RESPONSE_FILE};
    echo "I JUST RECEIVED A DISTRESS CALL! HELP! THERE IS SOMEONE IN DISTRESS! HELP! PLEASE CALL FOR HELP!" >> ${CHAT_RESPONSE_FILE};
    echo "MY OWNER MAY NEED YOUR HELP! HELP! THERE IS SOMEONE IN DISTRESS! HELP! PLEASE CALL FOR HELP!" >> ${CHAT_RESPONSE_FILE};
    echo "BYSTANDERS PLEASE DO NOT IGNORE THIS DISTRESS CALL. PLEASE CALL FOR HELP!" >> ${CHAT_RESPONSE_FILE};
 
    counter="1";
    max_count="${ANNOUNCEMENT_LOOP}";

    # Remove Old Response
    rm -f ${CHAT_RESPONSE_MP3}; 

    # Make New Response
    gtts-cli -f ${CHAT_RESPONSE_FILE} --lang en --tld ${LOCALIZATION} --output ${CHAT_RESPONSE_MP3};
      
    until [ $counter -gt $max_count ]; do
    mpg123 -q "artifacts/modules/sounds/low_high_tones.mp3";

    # For Windows use mpg123 https://www.mpg123.de/download
    mpg123 -q ${CHAT_RESPONSE_MP3};
    ((counter++));
    done;    
}

function WE_HAVE_A_PROBLEM {
    QUESTION=`echo $QUESTION | sed 's/\.//'`;
    
    # Leave Area Message
    echo "KINDLY LEAVE THE AREA, YOUR PRESENCE IS NOT WANTED!" > ${CHAT_RESPONSE_FILE};
    echo "KINDLY LEAVE THE AREA, YOUR PRESENCE IS NOT WANTED!" >> ${CHAT_RESPONSE_FILE};
    echo "KINDLY LEAVE THE AREA, YOUR PRESENCE IS NOT WANTED!" >> ${CHAT_RESPONSE_FILE};
    
    counter="1";
    max_count="3";

    # Remove Old Response
    rm -f ${CHAT_RESPONSE_MP3}; 

    # Make New Response
    gtts-cli -f ${CHAT_RESPONSE_FILE} --lang ${LANG} --tld ${LOCALIZATION} --output ${CHAT_RESPONSE_MP3};

    until [ $counter -gt $max_count ]; do
    # For Windows use mpg123 https://www.mpg123.de/download
    mpg123 -q "artifacts/modules/sounds/beep-11.mp3";
    mpg123 -q ${CHAT_RESPONSE_MP3};
    ((counter++));
    done;    
    mpg123 -q "artifacts/modules/sounds/Game_Over.mp3";
    mpg123 -q "artifacts/modules/sounds/chicken.mp3";
}
###########################################
function WRITE_TO_LOG {
    CUR_DATE=$(date +%m-%d-20%y-%H-%M-%S);
    echo "$LINE" >> ${CHAT_LOG};
    echo "$CUR_DATE" >> ${CHAT_LOG};
    echo "${QUESTION}" >> ${CHAT_LOG};
    echo "${CHAT_RESPONSE}" >> ${CHAT_LOG};
}

function CLEAN_UP {
    WRITE_TO_LOG; 
    # Remove Extra Files
    rm -f ${OUTPUT_FILE} ${CHAT_RESPONSE_MP3} ${CHAT_RESPONSE_FILE} ${WAV_FILE} ${JSON_TRANSCRIPT};
    
    # play ready prompt
    # mpg123 -f -7500 "artifacts/sounds/jetsons-doorbell.mp3"; # Jetson's Doorbell
    mpg123 -q -f -7500 "artifacts/modules/sounds/magic.mp3"; # Nice Chime
    rm -f *.png;
    
    # Clear Resources
    history -p;
    clear;
}

################# Functions End #################
if [ ${SOUND_CPU_CALIBRATION} = "true" ]; then
    ./artifacts/modules/introduction/calibration.sh;
fi

MEET_GREET; # initial announcement 
 
until [ "2" == "1" ]; do
    LISTEN_TRANSCRIBE; # Listens for sound then Transcribes with Google Speech to Text
    READ_NEWS; # Read News Broadcast
    CLEAN_UP; # Remove Files from last run
done