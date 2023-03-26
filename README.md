
# Botta-Bing - Make Your Bot Talk!
```
Author: Loree S.
Date: Febuary 22nd 2023
Email: lorees35@gmail.com
LinkedIn: https://tinyurl.com/49vu6zrs
```
Botta-Bing in a nutshell is Text to Speech AI Information Tool. It is driven by natural language AI technology processing Voice to Text with information integrations and corrections from popular API's including: **ChatGPT, OpenWeatherMaps.org, NewsData.io, Google Cloud**.

Once installed, you can simply speak to the **Botta-Bing** app and it will answer you back in its own conversational style. This project was created to integrate with the **"Micro Mini Monster"** and the **"Megha Monster"** line of SpyBots and Computer Enabled Rovers. However it will work as a standalone **Text to Speech AI Information Tool.** 

- **Learn More: Our Bots**
https://www.youtube.com/watch?v=8x4GLYNoKkE&t=2s
- **Learn More: Install Bota-Bing**
https://www.youtube.com/playlist?list=PLHaIqooBEjXhdVwQIrCLomTJwaucg_hV3
# Here Are Some Commands, Just Say
- **Computer, My Weather. or Computer, Local Weather.** # Current Weather for your Zip Code. Zip Code is specified in ther weather.sh file 
- **Computer, My day. or Computer, my date.** # Will give back the current Date 
- **Computer, My time.** # Will give back the current Time.
- **Computer, Weather for zip code XXXXX.** # Will give back weather for Zip Code specified 
- **Computer, Play Jeopardy.** # Will read back a Jeopardy Question.
- **Computer, Make me laugh.** # Will read back a Joke chosen by Botta Bing
- **Computer, Play a Podcast or Computer, Play My Podcast.** # Will Playback a Podcast. # Will Play. Podcast in the podcast Directory
- **Computer, Play Meditation Music or Computer, Play Relaxation Music or Computer, Play Calm Music.** # Will Play Calm Music From the Meditation Directory
- **Computer, Play Promo.** # Will play back a Promotion from the Announcement Directorys.
- **Computer, Random News.** # Will read back a news story chosen by Botta Bing
- **Computer, Talk Smack. or Computer, Talk Nasty.** # Will say something to repel.
- **Computer, We Have a Problem.** # Will Chase someone off. 
- **Computer, Emergency Emergency.** # Will play an Emergency Notification.
- **Computer, {Incert your Question}.** # Will reach out to ChatGPT for an Answer

# Getting Started
### Mac (Install Locally)
 1. Use Brew And Pip3 to Install Packages   
 2. brew install jq mpg123 curl vlc ffmpeg sox
 3. pip3 install gTTS   
 4. pip3 install -U openai-whisper (needs python version lower than 3.11 - run python --version first)
 5. Get Google Cloud installer from:
    https://cloud.google.com/sdk/docs/install   
 6.  Download this git repo & unzip it
    and unzip to a working directory   
 7. From here you can move on to the **"Loading API Keys Section"**.
 8. Make sure you load your API Keys into the **"params"** file in the root directory
 9. Make sure you enable the "Google Text To Speech" API. https://console.cloud.google.com/
 10. Lastly to enable the **Google Cloud SDK** you must run "gcloud init". You will be prompted to link your newly created API key to the SDK. 
  
### Mac (VirtualBox \ Vagrant)
  1. First Install VirtualBox - If you have an older version please upgrade to the most recent version http://virtualbox.org
  2. Install vagrant (a provisioner for Virtualbox) http://vagrantup.com
  3. Confirm that you have 4 gigs of memory available on your MAC
  4. Download this Git Repo & unzip it
  5. Move to the root directory and copy "Vagrantfile-mac" file over as "Vagrantfile"
  6. **RUN:** "vagrant up"
  7. Depending on your machine it may take 30+ mins to complete.
  8. Once Completed **RUN:** "vagrant reload". (The virtual machine's desktop should be visible).
  9. Login to Virtual machine.  Password is "vagrant".
  10. From here you can move on to the **"Loading API Keys Section"**. 
 11. Make sure you load your API Keys into the **"params"** file in the root directory
 12. Make Sure to Update your Zip Code in the **"params"** file also.
 13. Make sure you enable the "Google Text To Speech" API. https://console.cloud.google.com/
 14. If you use OPENAPI Whisper transcription, you DO NOT need to enable Google Cloud API.. - Edit your params file.
 15. Lastly to enable the **Google Cloud SDK** you must run "gcloud init". Do this from the Virtual Machines Desktop. You will be prompted to link your newly created Google Developer API Key to the Google Cloud SDK.
  
### Windows (VirtualBox \ Vagrant)
  1. First Install VirtualBox - If you have an older version please upgrade to the most recent version http://virtualbox.org
  2. Install vagrant (a provisioner for Virtualbox) http://vagrantup.com
  3. Confirm that you have 4 gigs of memory available on your Windows PC
  4. Download this Git Repo & unzip it
  5. Move to the root directory and copy "Vagrantfile-Win" file over as "Vagrantfile" 
  6. **RUN:** "vagrant up"
  7. Depending on your machine it may take 30+ mins to complete
  8. Once Completed **RUN:** "vagrant reload". (The virtual machine's desktop should be visible).
  9. Login to Virtual machine.  Password is "vagrant".
  10. From here you can move on to the **"Loading API Keys Section"**.
  11. Make sure you load your API Keys into the **"params"** file in the root directory
  12. Make Sure to Update your Zip Code in the **"params"** file also.
  13. Make sure you enable the "Google Text To Speech" API. https://console.cloud.google.com/
  14. If you use OPENAPI Whisper transcription, you DO NOT need to enable Google Cloud API.. - Edit your params file.
  15. Lastly to enable the **Google Cloud SDK** you must run "gcloud init". Do this from the Virtual Machines Desktop . You will be prompted to link your newly created Google Developer API Key to the Google Cloud SDK.

## Loading API Keys
Once the basic software packages are installed you need to obtain API Keys from the Below list if resources. First create a login and then either copy or create the keys for the below list:

**GET: Google Developer - API Key**   -- MAY NOT NEED THIS - IF you use OpenAI Transcription. See Params file for more info.
https://console.cloud.google.com/projectselector2/google/maps-apis
- Enable: Cloud Speech-to-Text API

**GET: Openweather Maps - API Key**
https://home.openweathermap.org/api_keys

**GET: NewData.io - API Key**
https://newsdata.io/api-key

**GET: ChatGPT - Api Key**
https://platform.openai.com/account/api-keys

Edit the **"params"** file in the root directory with you updated API Keys.
**Please Return To The Install Instructions.**

## More Information
*To Start Your Vagrant Instance Please use the command line. If you just start the box the mapped "/vagrant" folder will not be available.* 
***cd the downloaded "Botta-Bing" Folder***
- To Start your "Botta-Bing" Vagrant instance **RUN:** vagrant up
- To Restart your "Botta-Bing" Vagrant instance **RUN:** vagrant reload 
- To Turn-Off your "Botta-Bing" Vagrant instance **RUN:** vagrant halt 
- To Delete your "Botta-Bing" Vagrant instance **RUN:** vagrant destroy

## Troubleshooting
- My Bot is talking too slow - This is a system resource problem. If you are running VirtualBox and Vagrant add memory or additional cpus. 
- My Bot is talking too fast - This is a system resource problem. If you are running VirtualBox and Vagrant reduce memory or additional cpus. 
- My Bot is talking too low - Raise the volume on your computer
- My Bot can't hear me - Test your microphone. An amplified Microphone with an on\off switch works best.
- Do I have to say "Computer" all the time? Yes and No. The listener in Botta-Bing wakes up when it hears sound so you can say something else like. "Machine" or "Moca," or "Bot" or "Peter" etc. Practice with the name of your choosing.
- I can't get weather or news or it won't transcribe my voice info - There is a problem with your api keys. Check to see if they are entered correctly in the "params" file.  If there is a transcription error re-run "gcloud init" from the command line

#### Thank you ! Enjoy!
#### Sincerely,
##### Loree S.
