# Botta-Bing
Voice to Text AI Software - Integrates several api's including ChatGPT, OpenWeatherMaps.org, NewsData.io, Google Cloud.
Once installled you can simply speak to the Botta-Bing app and it will answer you back verbally.

## Here are some commands, Just Say:
- Computer, My Weather. # Current Weather for your Zip Code. Zip Code is specified in ther weather.sh file 
- Computer, My day. or Computer, my date. # Will give back the current Date 
- Computer, My time. # Will give back the current Time.
- Computer, Weather for zip code XXXXX. # Will give back weather for Zip Code specified 
- Computer, Play Jeopardy. # Will read back a Jeopardy Question.
- Computer, Make me laugh. # Will read back a Joke chosen by Botta Bing
- Computer, Random News. # Will read back a news story chosen by Botta Bing
- Computer, Talk Smack. or Computer, Talk Nasty. # Will say something to repel.
- Computer, We Have a Problem. # Will Chase someone off. 
- Computer, Emergency Emergency. # Will play an Emergency Notification.
- Computer, {Incert your Question}. # Will reach out to ChatGPT for an Answer

## Getting Started
- Mac (Install Locally)
  * 1. Use Brew to Install Packages
  * 2. brew install jq mpg123 curl
  * 3. pip3 install gTTS
  * 4. Get Google Cloud installer from: https://cloud.google.com/sdk/docs/install
  * 5. Download this git repo and unzip to a working directory
  * 6. Go Section on Configuring API Keys
    
- Mac (VirtualBox \ Vagrant)
  * 1. First Install VirtualBox - If you have an older version please upgrade to the most recent version http://vitualbox.org
  * 2. Install vagrant (a provisioner for Virtualbox) http://vagrantup
  * 3. Confirm that you have 4 gigs of memory available on your MAC
  * 4. Download this Git Repo
  * 5. Move to the root directory 
  * 6. RUN: ./vagrant_mac.sh
  * 7. Depending on your machine it may take 30+ mins to complete

- Windows (VirtualBox \ Vagrant)
  * 1. First Install VirtualBox - If you have an older version please upgrade to the most recent version http://vitualbox.org
  * 2. Install vagrant (a provisioner for Virtualbox) http://vagrantup
  * 3. Confirm that you have 4 gigs of memory available on your Windows PC
  * 4. Download this Git Repo
  * 5. Move to the root directory 
  * 6. RUN: ./vagrant_win.sh
  * 7. Depending on your machine it may take 30+ mins to complete
