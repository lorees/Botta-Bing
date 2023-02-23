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
source ../../../params;
NEWS_CATEGORY="top";
NEWS_COUNTRIES="us"; # us,ca
NEWS_FILE="artifacts/news/LATEST_NEWS.json";
NEWS_CATEGORY_FILE="artifacts/news/category";
NEWS_FOLDER="artifacts/news";

# Talk
CHAT_RESPONSE_MP3="response.mp3";
CHAT_RESPONSE_FILE="CHAT_RESPONSE.txt";
CHAT_LOG="../../../CHAT.log";

#################### Functions Begin ####################
function CHOOSE_CATEGORY {
    NEWS_CATEGORYS=(top business health politics science technology world);
    
    RANGE="${#NEWS_CATEGORYS[@]}";
    FIND_CATEGORY=$RANDOM;
    let "FIND_CATEGORY %= $RANGE";
    NEWS_CATEGORY=${NEWS_CATEGORYS[$FIND_CATEGORY]};
    echo "$NEWS_CATEGORY" > $NEWS_CATEGORY_FILE;

    LATEST_NEWS_API_URL="https://newsdata.io/api/1/news?apikey=${NEWS_API}&country=${NEWS_COUNTRIES}&q=${NEWS_CATEGORY}&language=en";
}

# Get Newss
function GET_TOP_NEWS {
    find ${NEWS_FOLDER} -name '*.*' -mmin +60 -delete > /dev/null;
    if [ ! -f ${NEWS_FILE} ]; then
        # Pick a news category
        CHOOSE_CATEGORY;
        wget ${LATEST_NEWS_API_URL} -O "${NEWS_FILE}";
    fi
}

function READ_ARTICLE {
    # Pick and articale
    TOTAL_ARTICLES=`cat ${NEWS_FILE} | jq length`;
    RANGE=$TOTAL_ARTICLES;
    FIND_ARTICLE=$RANDOM;
    let "FIND_ARTICLE %= $RANGE";

    MY_ARTICLE=`cat ${NEWS_FILE} | jq -r '.results['$FIND_ARTICLE'].description'`;
    ARTICLE_CATEGORY=`cat $NEWS_CATEGORY_FILE`;
    
    echo ${MY_ARTICLE} | sed 's/Read more\.\.\.//';

    echo "It's Time For A Short News Bite For Category ${ARTICLE_CATEGORY} News." > ${CHAT_RESPONSE_FILE};
    echo "Data Provided By, News Data dot I O." >> ${CHAT_RESPONSE_FILE};
    echo "$MY_ARTICLE" >> ${CHAT_RESPONSE_FILE};
    PROCESS_RESPONSE;
    mpg123 -q -f -10500 "artifacts/modules/sounds/this-just-in-980709-PREVIEW.mp3";
    READ_RESPONSE;
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
GET_TOP_NEWS;
READ_ARTICLE;    
exit;


