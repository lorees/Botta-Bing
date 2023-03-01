#!/usr/bin/env bash 
# Created by Loree Sebastien 2/202023
# Retreives News Data and reads it
# https://newsdata.io/documentation
# Possible Categories
    # business
    # entertainment
    # environment
    # food
    # health
    # politics
    # science
    # sports
    # technology
    # top
    # world

# Reference 
source params;
NEWS_COUNTRIES="us"; # us,ca
NEWS_FILE="artifacts/modules/news/LATEST_NEWS.json";
NEWS_CATEGORY_FILE="artifacts/modules/news/category";
NEWS_FOLDER="artifacts/news";

# Talk
CHAT_RESPONSE_MP3="response.mp3";
CHAT_RESPONSE_FILE="CHAT_RESPONSE.txt";
CHAT_LOG="/CHAT.log";

#################### Functions Begin ####################
function RANDOM_NEWS {
    NEWS_CATEGORYS=(top business food entertainment health politics science technology world);
    
    RANGE="${#NEWS_CATEGORYS[@]}";
    FIND_CATEGORY=$RANDOM;
    let "FIND_CATEGORY %= $RANGE";
    NEWS_CATEGORY=${NEWS_CATEGORYS[$FIND_CATEGORY]};
    echo "$NEWS_CATEGORY" > $NEWS_CATEGORY_FILE;

    LATEST_NEWS_API_URL="https://newsdata.io/api/1/news?apikey=${NEWS_API}&country=${NEWS_COUNTRIES}&q=${NEWS_CATEGORY}&language=en";
    wget ${LATEST_NEWS_API_URL} -O "${NEWS_FILE}";
}

function READ_ARTICLE {
    # Pick and articale
    TOTAL_ARTICLES=`cat ${NEWS_FILE} | jq length`;
    RANGE=$TOTAL_ARTICLES;
    FIND_ARTICLE=$RANDOM;
    let "FIND_ARTICLE %= $RANGE";

    MY_ARTICLE=`cat ${NEWS_FILE} | jq -r '.results['$FIND_ARTICLE'].description'`;
    MY_DESKTOP_LINK=`cat ${NEWS_FILE} | jq -r '.results['$FIND_ARTICLE'].link'`;
    ARTICLE_CATEGORY=`cat $NEWS_CATEGORY_FILE`;
    
    echo ${MY_ARTICLE} | sed 's/Read more\.\.\.//';
    echo "LINK: ${MY_DESKTOP_LINK}";
    ARTICLE_OPEN="";

    if [ $OPEN_NEWS_LINK = "true" ]; then    
        # Will open news link on desktop 
        OPEN_LINK;
        ARTICLE_OPEN="The Full News article will open on your desktop";
    fi

    echo "It's Time For A Short Bite For Category ${ARTICLE_CATEGORY} News." > ${CHAT_RESPONSE_FILE};
    echo "Data Provided By, News Data dot I O. ${ARTICLE_OPEN}" >> ${CHAT_RESPONSE_FILE};
    echo "$MY_ARTICLE" >> ${CHAT_RESPONSE_FILE};
    PROCESS_RESPONSE;
    mpg123 -q -f -10500 "artifacts/modules/sounds/this-just-in-980709-PREVIEW.mp3"
    READ_RESPONSE;
}

function OPEN_LINK {
    # Open link on linux desktop 
    OS_VER="/etc/os-release";
    if [ -f $OS_VER ]; then
        xdg-open "${MY_DESKTOP_LINK}";
    else
        open "${MY_DESKTOP_LINK}";
    fi 
 }   

function PROCESS_RESPONSE {
    # Remove Old Response
    rm -f ${CHAT_RESPONSE_MP3}; 

    # Make New Response
    gtts-cli -f ${CHAT_RESPONSE_FILE} --lang en --tld ${LOCALIZATION} --output ${CHAT_RESPONSE_MP3};
}

function READ_RESPONSE {
    # For Windows use mpg123 https://www.mpg123.de/download
    mpg123 -q ${CHAT_RESPONSE_MP3};
}

function WRITE_TO_LOG {
    CUR_DATE=$(date +%m-%d-20%y-%H-%M-%S);
    echo "$LINE" >> ${CHAT_LOG};
    echo "$CUR_DATE" >> ${CHAT_LOG};
    echo "${QUESTION}" >> ${CHAT_LOG};
    echo "${CHAT_RESPONSE}" >> ${CHAT_LOG};
}
#################### Functions End #################### 
RANDOM_NEWS;
READ_ARTICLE;    
exit;


