# Botta-Bing - Make Your Bot Talk!
```
Author: Loree Sebastien
Date: Febuary 22nd 2023
Email: lorees35@gmail.com
```
Botta-Bing in a nutshell is Text to Speech AI Information Tool. It is driven by natural language AI technology processing Voice to Text with information integrations and corrections from popular API's including like: **ChatGPT, OpenWeatherMaps.org, NewsData.io, Google Cloud**.

Once installed, you can simply speak to the **Botta-Bing** app and it will answer you back in its own conversational style. This project was created to integrate with the **"Micro Mini Monster"** and the **"Megha Monster"** line of SpyBots and Computer Enabled Rovers. However it will work as a standalone **Text to Speech AI Information Tool.** 

**Learn More:**
https://www.youtube.com/watch?v=8x4GLYNoKkE&t=2s

# Here Are Some Commands, Just Say
- **Computer, My Weather. or Computer, Local Weather.** # Current Weather for your Zip Code. Zip Code is specified in ther weather.sh file 
- **Computer, My day. or Computer, my date.** # Will give back the current Date 
- **Computer, My time.** # Will give back the current Time.
- **Computer, Weather for zip code XXXXX.** # Will give back weather for Zip Code specified 
- **Computer, Play Jeopardy.** # Will read back a Jeopardy Question.
- **Computer, Make me laugh.** # Will read back a Joke chosen by Botta Bing
- **Computer, Random News.** # Will read back a news story chosen by Botta Bing
- **Computer, Talk Smack. or Computer, Talk Nasty.** # Will say something to repel.
- **Computer, We Have a Problem.** # Will Chase someone off. 
- **Computer, Emergency Emergency.** # Will play an Emergency Notification.
- **Computer, {Incert your Question}.** # Will reach out to ChatGPT for an Answer

# Getting Started
### Mac (Install Locally)
 1. Use Brew And Pip3 to Install Packages   
 2. brew install jq mpg123 curl   
 3. pip3 install gTTS   
 4. Get Google Cloud installer from:
    https://cloud.google.com/sdk/docs/install   
 5.  Download this git repo & unzip it
    and unzip to a working directory   
 6. From here you can move on to the **"Loading API Keys Section"**.
 7. Make sure you load your API Keys into the **"params"* file in the root directory
  8. Lastly to enable the **Google Cloud SDK** you must run "gcloud init". You will be prompted to link your newly created API key to the SDK. 
  
### Mac (VirtualBox \ Vagrant)
  1. First Install VirtualBox - If you have an older version please upgrade to the most recent version http://virtualbox.org
  2. Install vagrant (a provisioner for Virtualbox) http://vagrantup.com
  3. Confirm that you have 4 gigs of memory available on your MAC
  4. Download this Git Repo & unzip it
  5. Move to the root directory 
  6. **RUN:** ./vagrant_mac.sh
  7. Depending on your machine it may take 30+ mins to complete.
  8. Once Completed **RUN:** "vagrant reload". (The virtual machine's desktop should be visible.
  9. Login to Virtual machine.  Password is "vagrant".
  10. From here you can move on to the **"Loading API Keys Section"**. 
 11. Make sure you load your API Keys into the **"params"** file in the root directory
 12. Make Sure to Update your Zip Code in the **"params"** file also.
 13. Lastly to enable the **Google Cloud SDK** you must run "gcloud init". Do this from the Virtual Machines Desktop. You will be prompted to link your newly created Google Developer API Key to the Google Cloud SDK.
  
### Windows (VirtualBox \ Vagrant)
  1. First Install VirtualBox - If you have an older version please upgrade to the most recent version http://virtualbox.org
  2. Install vagrant (a provisioner for Virtualbox) http://vagrantup.com
  3. Confirm that you have 4 gigs of memory available on your Windows PC
  4. Download this Git Repo & unzip it
  5. Move to the root directory 
  6. **RUN:** ./vagrant_win.sh
  7. Depending on your machine it may take 30+ mins to complete
  8. Once Completed **RUN:** "vagrant reload". (The virtual machine's desktop should be visible.
  9. Login to Virtual machine.  Password is "vagrant".
  10. From here you can move on to the **"Loading API Keys Section"**.
  11. Make sure you load your API Keys into the **"params"** file in the root directory
  12. Make Sure to Update your Zip Code in the **"params"** file also.
  13. Lastly to enable the **Google Cloud SDK** you must run "gcloud init". Do this from the Virtual Machines Desktop . You will be prompted to link your newly created Google Developer API Key to the Google Cloud SDK.

##Loading API Keys
Once the basic software packages are installed you need to obtain API Keys from the Below list if resources. First create a login and then either copy or create the keys for the below list:

**GET: Google Developer - API Key**
https://console.cloud.google.com/projectselector2/google/maps-apis

**GET: Openweather Maps - API Key**
https://home.openweathermap.org/api_keys

**GET: NewData.io - API Key**
https://newsdata.io/api-key

**GET: ChatGPT - Api Key**
https://platform.openai.com/account/api-keys

Edit the **"params"** file in the root directory with you updated API Keys.
**Please Return To The Install Instructions.**
