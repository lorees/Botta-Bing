#!/usr/bin/env bash 
# Loree Sebastien 3/06/2023;
# Music Reference : https://pixabay.com/music/search/circus/

START_MP3="startup.mp3";
source params;
################# Functions Begin #################
function CALIBRATION {
    START_UP="Hello, This Is ${BOT_NAME}, your computerized assistant. \
        And It has been determined that this system needs sound and CPU calibration.\
        Please Stand By, it should only take a few minutes. \
        Now Starting Calibration. Thank you!";
    
    mpg123 -q artifacts/modules/sounds/magic.mp3;
    spx synthesize --text "${START_UP}" --voice "$AZURE_VOICE";
    mpg123 -q "artifacts/modules/introduction/welcome-to-china-139329.mp3";
    spx synthesize --text "The sound and CPU calibration has completed! Thank you." --voice "$AZURE_VOICE";
}
################# Functions End #################
CALIBRATION;  # Calibration 
exit;