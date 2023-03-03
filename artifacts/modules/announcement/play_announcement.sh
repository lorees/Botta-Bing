#!/usr/bin/env bash 
# Loree Sebastien 2/26/2023;
# Music Reference : https://pixabay.com/music/search/circus/

CHAT_RESPONSE_MP3="response.mp3";
CHAT_RESPONSE_FILE="CHAT_RESPONSE.txt";
source params;
################# Functions Begin #################
function PLAY_ANNOUNCEMENT_FILE {
    # Get Announcements 
    ANNOUNCEMENT_FILE="artifacts/modules/announcement/text/read_text";

    # Check if the file is empty
    if [ ! -s "${ANNOUNCEMENT_FILE}" ]; then
        echo "No Announcement"
    else
        echo "Announcement Found"
        gtts-cli --file "${ANNOUNCEMENT_FILE}" --lang ${LANG} --tld ${LOCALIZATION} --output "announcement.mp3";
        mpg123 -q announcement.mp3;
    fi
}

function PLAY_ANNOUNCEMENT_MP3 {
    # Get Podcasts 
    ANNOUNCEMENT_DIR="artifacts/modules/announcement/files";
    ANNOUNCEMENT_LIST=(`ls $ANNOUNCEMENT_DIR/*.mp3`);

    # Get total number of elements in the array
    TOTAL_ANNOUNCEMENTS=${#ANNOUNCEMENT_LIST[@]};

    # Get a Random Number and use it to pick;
    RANGE=$TOTAL_ANNOUNCEMENTS;
    R_COMMENT=$RANDOM; 
    let "R_COMMENT %= $TOTAL_ANNOUNCEMENTS"; # generate random integer

    # make Random comment.
    echo "COMMENT: ${ANNOUNCEMENT_LIST[$R_COMMENT]}";

    if [ ! -z $TOTAL_ANNOUNCEMENTS ]; then 
        mpg123 -q "${ANNOUNCEMENT_LIST[$R_COMMENT]}";
    fi
}

function LOOP_PLAY {
    counter=1;
    max_count=${ANNOUNCEMENT_LOOP}; # play for the specified number of times.

    until [ $counter -eq $max_count ]; do
        PLAY_ANNOUNCEMENT_MP3;
        PLAY_ANNOUNCEMENT_FILE;
    ((counter++));
    done;    
    rm -f announcement.mp3;
}
################# Functions End #################
LOOP_PLAY;  # Play announcements in a loop
