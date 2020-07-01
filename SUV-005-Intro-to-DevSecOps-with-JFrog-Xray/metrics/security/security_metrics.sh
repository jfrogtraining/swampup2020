#!/bin/sh

# the URL should include /xray/api/v1
# example : https://artifactory-eu.jfrog.io/xray/api/v1"
xray_url="<CHANGE_ME>"
xray_user="<CHANGE_ME>"
xray_pass="<CHANGE_ME>"

input_file="artifact_comp_details.json"

listing_mode=0

while getopts "r:bp:u:lh" option; do
  case $option in
    r) xray_url=$OPTARG;;
    u) xray_user=$OPTARG;;  
    p) xray_pass=$OPTARG;;  
    l) listing_mode=1;;  
    b) input_file="build_info_comp_details.json";;  
  esac 
done

rm -rf export_summary.zip export/ output/res_violations.json
mkdir export output

echo "------------- SECURITY VIOLATION ------------------"
cat input/$input_file
echo "---------------------------------------------------"
echo "[INFO] downloading export_summary.zip ..."
curl -s \
-H 'Content-Type: application/json' \
-XPOST \
-u$xray_user:$xray_pass \
-T input/$input_file \
-o export_summary.zip \
$xray_url/component/exportDetails

echo "[INFO] unzipping export_summary.zip..."
unzip export_summary.zip -d export

echo "------------- METRICS ------------------"

if [[ $listing_mode -eq 0 ]]; then
  echo "[INFO] Generating violation metric ..."
  jq '[.[] | select(.type=="security")] | group_by(.severity) | map({Severity: .[0].severity, ViolationCount: length})' export/*Violations_Export.json | tee output/res_violations.json
  echo "[INFO] output/res_violations.json generated"

  echo "[INFO] Nb of fixes per component (infected by a high vulnerability)"
  jq '[.data[] | select(.severity=="High") | select(.component_versions.fixed_versions|arrays)] | group_by(.source_comp_id) | map({compid: .[0].source_comp_id, Count: length})' export/*Security_Export.json

  # list of fixes for High
  echo "[INFO] Adding up nb of fixes per severity level using reduce ..."
  nb_fix_high=`jq '[.data[] | select(.severity=="High") | select(.component_versions.fixed_versions|arrays)] | group_by(.source_comp_id) | map({compid: .[0].source_comp_id, Count: length}) | reduce .[].Count as $item (0; . + $item)' export/*Security_Export.json`
  nb_fix_med=`jq '[.data[] | select(.severity=="Medium") | select(.component_versions.fixed_versions|arrays)] | group_by(.source_comp_id) | map({compid: .[0].source_comp_id, Count: length}) | reduce .[].Count as $item (0; . + $item)' export/*Security_Export.json`
  nb_fix_low=`jq '[.data[] | select(.severity=="Low") | select(.component_versions.fixed_versions|arrays)] | group_by(.source_comp_id) | map({compid: .[0].source_comp_id, Count: length}) | reduce .[].Count as $item (0; . + $item)' export/*Security_Export.json`
  nb_fix_unk=`jq '[.data[] | select(.severity=="Unknown") | select(.component_versions.fixed_versions|arrays)] | group_by(.source_comp_id) | map({compid: .[0].source_comp_id, Count: length}) | reduce .[].Count as $item (0; . + $item)' export/*Security_Export.json`

  echo "[INFO] nb of fixes for HIGH severity level:  $nb_fix_high"
  echo "[INFO] nb of fixes for MEDIUM severity level:  $nb_fix_med"
  echo "[INFO] nb of fixes for LOW severity level:  $nb_fix_low"
  echo "[INFO] nb of fixes for UNKNOWN severity level:  $nb_fix_unk"

  # add number of fixes per severity level
  jq --arg high $nb_fix_high --arg med $nb_fix_med  --arg low $nb_fix_low --arg unk $nb_fix_unk \
'[.[] | select(.Severity=="High") += {"AvailableFixCount": $high|tonumber} | select(.Severity=="Medium") += {"AvailableFixCount": $med|tonumber } | select(.Severity=="Low") += {"AvailableFixCount": $low|tonumber } | select(.Severity=="Unknown") += {"AvailableFixCount": $unk|tonumber }]' output/res_violations.json

else
echo "------------- LISTING ------------------"

  jq '[.[] | select(.type=="security") | select(.severity=="High") ] ' export/*Violations_Export.json
#  jq '[.[] | select(.type=="security") | select(.severity=="Medium") ] ' export/*Violations_Export.json
#  jq '[.[] | select(.type=="security") | select(.severity=="Low") ] ' export/*Violations_Export.json

fi
