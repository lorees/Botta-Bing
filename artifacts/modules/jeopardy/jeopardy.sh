#!/usr/bin/env bash 
# Created by Loree Sebastien 2/20/2023
# Jeopardy Data Set https://knowledge.domo.com/Training/Self-Service_Training/Onboarding_Resources/Fun_Sample_Datasets
# Info on how to read a CSV https://www.cyberciti.biz/faq/unix-linux-bash-read-comma-separated-cvsfile/
# An example of how to use datasets presented in CSV format;

# Variables
source params;
JEOPARDY_CONFIG="artifacts/modules/jeopardy/JEOPARDY_CSV.csv";
OUTPUT_FILE="artifacts/modules/jeopardy/question.csv";

# Talk
CHAT_RESPONSE_MP3="response.mp3";
CHAT_RESPONSE_FILE="CHAT_RESPONSE.txt";
CHAT_LOG="../../../CHAT.log";
################# Functions #################
# Pick a random Question from the dataset
function GENERATE_RANDOM_QUESTION {
    # Get Questions
    QUESTIONS=`cat $JEOPARDY_CONFIG`;
    TOTAL_NUM_QUESTIONS=$(wc -l $JEOPARDY_CONFIG | awk '{ print $1 }'); # Get the total number of questions in data file
    
    # Print the whole data set on the screen
    # echo $QUESTIONS;

    # Get a  Random Number and use it to pick the Jeopardy Question;
    RANGE=$TOTAL_NUM_QUESTIONS;
    number=$RANDOM;
    let "number %= $RANGE";
    echo $LINE;

    # echo "RANGE:$RANGE";
    # echo "NUMBER: $number";

    # Grab the random line number from the Data file 
    PICKED_QUESTION=$(awk -v num=$number '{if(NR==num) print $0}' $JEOPARDY_CONFIG); 
    echo $PICKED_QUESTION>$OUTPUT_FILE && cat $OUTPUT_FILE && echo && echo;

    # Loop through the Questions
    while IFS=, read -r "show_num" "air_date" "round" "jeopardy_category" "value" "question" "answer"
    do
        
        # Fix on screen text - Convert to Uppercase the first letter of each word
        question=$(for i in $question; do B=`echo "${i:0:1}" | sed 's/[^a-zA-Z0-9]//g' | tr a-z A-Z`${i:1}; echo -n "$B "; done); # Clean Text
        answer=$(for i in $answer; do B=`echo "${i:0:1}" | sed 's/[^a-zA-Z0-9]//g' | tr a-z A-Z`${i:1}; echo -n "$B "; done); # Clean Text
        
        echo "Show Number: $show_num";
        echo "Air Date: "$air_date"";
        echo "Line Number: $number";
        echo "Round: "$round"";
        echo "Category: "$jeopardy_category"";
        echo "Question Value: "$value"";
        echo "The Question: "$question"";
        echo "The Answer: "$answer"";
        echo $LINE;
        FORMAT_QUESTION;
    done < $OUTPUT_FILE && rm $OUTPUT_FILE;
 
}

function FORMAT_QUESTION {
    # Question
    #mpg123 -q -f -9500 "artifacts/modules/sounds/this-just-in-980709-PREVIEW.mp3";
    echo "OKAY Here is Your Question. The Round Is ${round}. The Category is ${jeopardy_category}. The Question Value Is: ${value} dollars." > ${CHAT_RESPONSE_FILE};
    echo "${question}?" >> ${CHAT_RESPONSE_FILE};
    READ_RESPONSE;
    
    # Wait time
    mpg123 -q -f -10500 "artifacts/modules/sounds/Jeopardy_Think_Music.mp3";
    mpg123 -q -f -10500 "artifacts/modules/sounds/Times_up.mp3";
    
    # Answer
    echo && echo "The Answer Is: ${answer}" > ${CHAT_RESPONSE_FILE};
    READ_RESPONSE;
    WRITE_TO_LOG;
}

function READ_RESPONSE {
    # Remove Old Response
    rm -f ${CHAT_RESPONSE_MP3}; 

    # Make New Response
    gtts-cli -f ${CHAT_RESPONSE_FILE} --lang en --tld ${LOCALIZATION} --output ${CHAT_RESPONSE_MP3};

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
################## Functions END #################
GENERATE_RANDOM_QUESTION;
exit;
