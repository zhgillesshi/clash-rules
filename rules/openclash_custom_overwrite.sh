#!/bin/sh
. /usr/share/openclash/ruby.sh
. /usr/share/openclash/log.sh
. /lib/functions.sh

# Persistent ChatGPT, Reddit and Steam routing.
CONFIG_FILE="$1"

ruby_arr_insert_hash "$CONFIG_FILE" "['proxy-groups']" "-1" \
"{'name'=>'ChatGPT','type'=>'select','include-all'=>true,'filter'=>'(?i)(^JP-|日本|东京|大阪|Japan|Tokyo|Osaka)'}"

ruby_merge_hash "$CONFIG_FILE" "['rule-providers']" \
"'oc_openai'=>{'type'=>'http','behavior'=>'domain','format'=>'yaml','path'=>'./rule_provider/oc_openai.yaml','url'=>'https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/openai.yaml','interval'=>86400,'proxy'=>'auto'}"

ruby_arr_insert "$CONFIG_FILE" "['rules']" "0" "RULE-SET,oc_openai,ChatGPT"

ruby_arr_insert_hash "$CONFIG_FILE" "['proxy-groups']" "-1" \
"{'name'=>'Reddit','type'=>'select','include-all'=>true}"

ruby_arr_insert "$CONFIG_FILE" "['rules']" "0" "DOMAIN-SUFFIX,reddit.com,Reddit"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "1" "DOMAIN-SUFFIX,redditstatic.com,Reddit"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "2" "DOMAIN-SUFFIX,redditmedia.com,Reddit"

ruby_arr_insert_hash "$CONFIG_FILE" "['proxy-groups']" "-1" \
"{'name'=>'Steam','type'=>'select','proxies'=>['auto','DIRECT'],'include-all'=>true}"

ruby_arr_insert "$CONFIG_FILE" "['rules']" "3" "DOMAIN-SUFFIX,steampowered.com,Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "4" "DOMAIN-SUFFIX,steamcommunity.com,Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "5" "DOMAIN-SUFFIX,steamstatic.com,Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "6" "DOMAIN-SUFFIX,steamcontent.com,Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "7" "DOMAIN-SUFFIX,steamusercontent.com,Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "8" "DOMAIN-SUFFIX,steamserver.net,Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "9" "DOMAIN-SUFFIX,steamgames.com,Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "10" "DOMAIN-SUFFIX,steam-chat.com,Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "11" "DOMAIN-SUFFIX,valvesoftware.com,Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "12" "DOMAIN-SUFFIX,valve.net,Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "13" "DOMAIN-SUFFIX,akamaihd.net,Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "14" "IP-ASN,32590,Steam,no-resolve"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "15" "AND,((NETWORK,UDP),(DST-PORT,3478)),Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "16" "AND,((NETWORK,UDP),(DST-PORT,4379-4380)),Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "17" "AND,((NETWORK,UDP),(DST-PORT,27000-27250)),Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "18" "AND,((NETWORK,TCP),(DST-PORT,27015-27050)),Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "19" "DOMAIN-SUFFIX,photonengine.com,Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "20" "DOMAIN-SUFFIX,photonengine.io,Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "21" "DOMAIN,ns.photonengine.cn,Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "22" "AND,((NETWORK,UDP),(DST-PORT,5055-5058)),Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "23" "AND,((NETWORK,TCP),(DST-PORT,4530-4533)),Steam"
ruby_arr_insert "$CONFIG_FILE" "['rules']" "24" "AND,((NETWORK,TCP),(DST-PORT,9090-9093)),Steam"

exit 0
