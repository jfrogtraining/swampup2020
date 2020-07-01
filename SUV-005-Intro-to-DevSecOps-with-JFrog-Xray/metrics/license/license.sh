#!/bin/sh

# the URL should include /xray/api/v1
# example : https://artifactory-eu.jfrog.io/xray/api/v1"
xray_url="<CHANGE_ME>"
xray_user="<CHANGE_ME>"
xray_pass="<CHANGE_ME>"

input_file="artifact_summary.json"

build_mode=0
build_name="mvn-example"
build_number="36"

while getopts "r:bi:n:p:u:h" option; do
  case $option in
    r) xray_url=$OPTARG;;
    u) xray_user=$OPTARG;;  
    p) xray_pass=$OPTARG;;  
    b) build_mode=1;;  
    i) build_name=$OPTARG;; 
    n) build_number=$OPTARG;; 
  esac 
done

echo "------------- LICENSES  ------------------"
mkdir output

if [[ $build_mode -eq 0 ]]; then
  cat input/$input_file
  echo "---------------------------------------------------"
  echo "[INFO] querying artifact summary Rest API ..."
  curl -s \
  -H 'Content-Type: application/json' \
  -XPOST \
  -u$xray_user:$xray_pass \
  -T input/$input_file \
  $xray_url/summary/artifact > output/artifact_lvl_licenses.json
  echo "[INFO] saved result in output/artifact_lvl_licenses.json"
  echo "[INFO] processing artifact_lvl_licenses.json ..."
  jq '[.artifacts[].licenses[] | {Name: .name, Count: (.components | length)}] | unique' output/artifact_lvl_licenses.json 
else
  echo "build name : $build_name"
  echo "build number : $build_number"
  echo "---------------------------------------------------"
  echo "[INFO] querying build summary Rest API ..."
  curl -s  -u$xray_user:$xray_pass "$xray_url/summary/build?build_name=${build_name}&build_number=${build_number}" > output/license_list.json
  echo "[INFO] saved result in output/build_lvl_licenses.json"
  echo "[INFO] processing build_lvl_licenses.json ..."
  jq '[.licenses[] | {Name: .name, Count: (.components | length)}] | unique' output/license_list.json
fi
