#!/bin/bash
# Inshackle v1.0
# recoded by: CYBER KALLAN
# github.com/cyberkallan/inshackle-bot
# If you use any part from this code, give me the credits, please, read the License


string4=$(openssl rand -hex 32 | cut -c 1-4)
string8=$(openssl rand -hex 32  | cut -c 1-8)
string12=$(openssl rand -hex 32 | cut -c 1-12)
string16=$(openssl rand -hex 32 | cut -c 1-16)
device="android-$string16"
uuid=$(openssl rand -hex 32 | cut -c 1-32)
phone="$string8-$string4-$string4-$string4-$string12"
guid="$string8-$string4-$string4-$string4-$string12"
header='Connection: "close", "Accept": "*/*", "Content-type": "application/x-www-form-urlencoded; charset=UTF-8", "Cookie2": "$Version=1" "Accept-Language": "en-US", "User-Agent": "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'
var=$(curl -i -s -H "$header" https://i.instagram.com/api/v1/si/fetch_headers/?challenge_type=signup&guid=$uuid > /dev/null)
var2=$(echo $var | grep -o 'csrftoken=.*' | cut -d ';' -f1 | cut -d '=' -f2)
ig_sig="4f8732eb9ba7d1c8e8897a75d6474d4eb3f5279137431b2aafb71fafe2abe178"

login()
{
  if [[ $user == "" ]]; then
  printf "LOGIN"
  read -p $'Enter UserName: ' user
  fi
  
if [[ -e cookie.$user ]]; then

printf "\e[1;31m[\e[0m\e[1;77m*\e[0m\e[1;31m]\e[0m\e[1;93m Cookies found for user\e[0m\e[1;77m %s\e[0m\n" $user

default_use_cookie="Y"

read -p $'\e[1;31m[\e[0m\e[1;77m+\e[0m\e[1;31m]\e[0m\e[1;93m Use it?\e[0m\e[1;77m [Y/n]\e[0m ' use_cookie

use_cookie="${use_cookie:-${default_use_cookie}}"

if [[ $use_cookie == *'Y'* || $use_cookie == *'y'* ]]; then
printf "\e[1;31m[\e[0m\e[1;77m*\e[0m\e[1;31m]\e[0m\e[1;93m Using saved credentials\e[0m\n"
else
rm -rf cookie.$user
login
fi

  else
   read -s -p $'Enter Password: ' pass
    data='{"phone_id":"'$phone'", "_csrftoken":"'$var2'", "username":"'$user'", "guid":"'$guid'", "device_id":"'$device'", "password":"'$pass'", "login_attempt_count":"0"}'

IFS=$'\n'

hmac=$(echo -n "$data" | openssl dgst -sha256 -hmac "${ig_sig}" | cut -d " " -f2)
useragent='User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'

printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Trying to login as\e[0m\e[1;93m %s\e[0m\n" $user
IFS=$'\n'
var=$(curl -c cookie.$user -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/accounts/login/" | grep -o "logged_in_user\|challenge\|many tries\|Please wait" | uniq ); 
if [[ $var == "challenge" ]]; then printf "\e[1;93m\n[!] Challenge required\n" ; exit 1; elif [[ $var == "logged_in_user" ]]; then printf "\e[1;92m \n[+] Login Successful\n" ; elif [[ $var == "Please wait" ]]; then echo "Please wait"; fi; 

fi

}


login
