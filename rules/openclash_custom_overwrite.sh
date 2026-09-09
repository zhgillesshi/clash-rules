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

ruby_merge_hash "$CONFIG_FILE" "['rule-providers']" \
"'steam-pico'=>{'type'=>'http','behavior'=>'classical','format'=>'yaml','path'=>'./rule_provider/steam-pico.yaml','url'=>'https://raw.githubusercontent.com/zhgillesshi/clash-rules/main/rules/providers/steam-pico.yaml','interval'=>86400,'proxy'=>'auto'}"

ruby_arr_insert "$CONFIG_FILE" "['rules']" "3" "RULE-SET,steam-pico,Steam"

exit 0
