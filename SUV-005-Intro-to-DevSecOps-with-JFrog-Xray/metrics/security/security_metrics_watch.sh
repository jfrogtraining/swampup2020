#!/bin/sh

# the URL should include /xray/api/v1
# example : https://artifactory-eu.jfrog.io/xray/api/v1"
xray_url="<CHANGE_ME>"
xray_user="<CHANGE_ME>"
xray_pass="<CHANGE_ME>"

input_file="get_violations.json"
listing_mode=0

while getopts "r:p:u:lh" option; do
  case $option in
    r) xray_url=$OPTARG;;
    u) xray_user=$OPTARG;;  
    p) xray_pass=$OPTARG;;  
    l) listing_mode=1;;  
  esac 
done

echo "------------- SECURITY VIOLATION ------------------"
cat input/$input_file
echo "---------------------------------------------------"
curl -s \
-H 'Content-Type: application/json' \
-XPOST \
-u$xray_user:$xray_pass \
-T  input/$input_file \
$xray_url/violations  > output/get_violations.json

if [[ $listing_mode -eq 0 ]]; then
#  jq '[.violations[] | select(.impacted_artifacts[]|contains("build")|not) | select(.type=="Security")] | group_by(.severity) | map({Severity: .[0].severity, ViolationCount: length}) ' output/get_violations.json
  jq '[.violations[] | select(.type=="Security")] | group_by(.severity) | map({Severity: .[0].severity, ViolationCount: length}) ' output/get_violations.json
else 
  jq '[.violations[] | select(.type=="Security") | select(.severity=="High") ] ' output/get_violations.json
#  jq '[.violations[] | select(.type=="Security") | select(.severity=="Medium") ] ' output/get_violations.json
#  jq '[.violations[] | select(.type=="Security") | select(.severity=="Low") ] ' output/get_violations.json

fi
