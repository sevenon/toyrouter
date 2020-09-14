#!/bin/sh

# use www.urlencoder.org to url encode username and password
ddns_username="myemail%40gmail.com"
ddns_password="mypassword%21"

update_url="https://$ddns_username:$ddns_password@updates.dnsomatic.com/nic/update"
update_response_regex="^good\|^nochg"

echo $$ >"/var/run/`basename $0`.pid" 

sleep 10s
while :
do
    success=""
    while [ -z "$success" ]
    do
        logger "$0 request: $update_url"

        response=`wget -O - $update_url`
        success=`echo "$response" | grep $update_response_regex`

        logger "$0 response: $response"
        sleep 1h
    done

    sleep 1d
done
