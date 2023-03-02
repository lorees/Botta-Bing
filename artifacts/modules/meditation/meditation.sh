#!/usr/bin/env bash 
# Loree Sebastien 2/26/2023;
# Play Meditation Music downloaded to the artifacts\modules\meditation folder.
# reference: https://pixabay.com/music/search/mood/relaxing/

source params;
################# Functions Begin #################
function PLAY_MEDITATION {
    # Get Podcasts 
    MEDITATION_DIR="artifacts/modules/meditation";
    MEDITATION_LIST=(`ls $MEDITATION_DIR/*.mp3`);

    # Get total number of elements in the array
    TOTAL_MEDITATIONS=${#MEDITATION_LIST[@]};

    # Get a Random Number and use it to pick;
    RANGE=$TOTAL_MEDITATIONS;
    R_COMMENT=$RANDOM; 
    let "R_COMMENT %= $TOTAL_MEDITATIONS"; # generate random integer

    # make Random comment.
    echo "COMMENT: ${MEDITATION_LIST[$R_COMMENT]}";

    if [ ! -z $TOTAL_MEDITATIONS ]; then 
        CHAT_RESPONSE_MP3="meditation.mp3";
        gtts-cli "${OWNER_NAME}, relaxation is on the way. \
            If you would like to stop the track please quit the VLC process on your desktop \
            and I will return. Otherwise I will return once the Track completes. Please Enjoy!." \
            --lang en --tld ${LOCALIZATION} --output ${CHAT_RESPONSE_MP3};
        mpg123 -q "${CHAT_RESPONSE_MP3}" && rm -rf ${CHAT_RESPONSE_MP3};
        vlc --play-and-stop --play-and-exit "${MEDITATION_LIST[$R_COMMENT]}";
    fi
}
################# Functions End #################
PLAY_MEDITATION;