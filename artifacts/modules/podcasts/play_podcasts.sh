#!/usr/bin/env bash 
# Loree Sebastien 2/26/2023;

source params;
################# Functions Begin #################
function PLAY_PODCAST {
    # Get Podcasts 
    PODCAST_DIR="artifacts/modules/podcasts";
    PODCAST_LIST=(`ls $PODCAST_DIR/*.mp3`);

    # Get total number of elements in the array
    TOTAL_PODCASTS=${#PODCAST_LIST[@]};

    # Get a Random Number and use it to pick;
    RANGE=$TOTAL_PODCASTS;
    R_COMMENT=$RANDOM; 
    let "R_COMMENT %= $TOTAL_PODCASTS"; # generate random integer

    # make Random comment.
    echo "COMMENT: ${PODCAST_LIST[$R_COMMENT]}";

    if [ ! -z $TOTAL_PODCASTS ]; then 
        CHAT_RESPONSE_MP3="podcast.mp3";
        gtts-cli "${OWNER_NAME}, your podcast will start shortly and will play to the end. \
            If you would like to stop the podcast please quit the VLC process on your desktop \
            and I will return. Otherwise I will return once the podcasts completes. Thank you." \
            --lang en --tld ${LOCALIZATION} --output ${CHAT_RESPONSE_MP3};
        mpg123 -q "${CHAT_RESPONSE_MP3}" && rm -rf ${CHAT_RESPONSE_MP3};
        vlc --play-and-stop --play-and-exit "${PODCAST_LIST[$R_COMMENT]}";
    fi
}
################# Functions End #################
PLAY_PODCAST;