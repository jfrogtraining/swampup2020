###############################################
#Prepare your local environment
###############################################

#keep your git directory in memory for latest command
export SCRIPT_DIR=$(pwd)

#save your password

export ADMIN_PASSWORD=4dg7eAc36b

#save artifactory url
export ARTIFACTORY_URL=http://34.71.42.17:8082
curl $ARTIFACTORY_URL/artifactory/api/system/ping 


# OPTIONAL : delete default permissions target
#curl -uadmin:$ADMIN_PASSWORD -X DELETE $ARTIFACTORY_URL/artifactory/api/v2/security/permissions/Anything
#curl -uadmin:$ADMIN_PASSWORD -X DELETE $ARTIFACTORY_URL/artifactory/api/v2/security/permissions/Any%20Remote

# create repos with yaml configuration file
#curl -uadmin:$ADMIN_PASSWORD -X PATCH  $ARTIFACTORY_URL/artifactory/api/system/configuration -T $SCRIPT_DIR/json/repo.yaml

########### SEC & OPS GROUPS

# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/security/groups/security -H "content-type: application/vnd.org.jfrog.artifactory.security.Group+json" -T $SCRIPT_DIR/json/groups/group-sec.json
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/security/groups/ops -H "content-type: application/vnd.org.jfrog.artifactory.security.Group+json" -T $SCRIPT_DIR/json/groups/group.json
# curl -uadmin:$ADMIN_PASSWORD -X POST -H "content-type: application/json"  $ARTIFACTORY_URL/xray/api/v1/policies -T $SCRIPT_DIR/json/sec/policy.json

########### NINJA 

project="ninja"
# # create groups
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/security/groups/${project}-reader -H "content-type: application/vnd.org.jfrog.artifactory.security.Group+json" -T $SCRIPT_DIR/json/groups/group.json
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/security/groups/${project}-dev -H "content-type: application/vnd.org.jfrog.artifactory.security.Group+json" -T $SCRIPT_DIR/json/groups/group.json
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/security/groups/${project}-delivery -H "content-type: application/vnd.org.jfrog.artifactory.security.Group+json" -T $SCRIPT_DIR/json/groups/group-delivery.json

# # create users
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/security/users/dev1 -H "content-type: application/vnd.org.jfrog.artifactory.security.User+json" -T $SCRIPT_DIR/json/users/${project}/dev.json
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/security/users/deliv1 -H "content-type: application/vnd.org.jfrog.artifactory.security.User+json" -T $SCRIPT_DIR/json/users/${project}/delivery.json

# # create permissions
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/v2/security/permissions/${project}-reader -H "content-type: application/json" -T $SCRIPT_DIR/json/permissions/${project}/permission-reader.json
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/v2/security/permissions/${project}-dev -H "content-type: application/json" -T $SCRIPT_DIR/json/permissions/${project}/permission-dev.json
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/v2/security/permissions/${project}-delivery -H "content-type: application/json" -T $SCRIPT_DIR/json/permissions/${project}/permission-delivery.json

# CREATE watch
#curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/xray/api/v2/watches -H "content-type: application/json" -T $SCRIPT_DIR/json/sec/watch-${project}.json

# UPDATE watch
#curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/xray/api/v2/watches/${project}-dev -H "content-type: application/json" -T $SCRIPT_DIR/json/sec/watch-${project}.json


########### ASGARDIAN 

project="asgardian"
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/security/groups/${project}-reader -H "content-type: application/vnd.org.jfrog.artifactory.security.Group+json" -T $SCRIPT_DIR/json/groups/group.json
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/security/groups/${project}-dev -H "content-type: application/vnd.org.jfrog.artifactory.security.Group+json" -T $SCRIPT_DIR/json/groups/group.json
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/security/groups/${project}-delivery -H "content-type: application/vnd.org.jfrog.artifactory.security.Group+json" -T $SCRIPT_DIR/json/groups/group-delivery.json

# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/security/users/deva -H "content-type: application/vnd.org.jfrog.artifactory.security.User+json" -T $SCRIPT_DIR/json/users/${project}/dev.json
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/security/users/deliva -H "content-type: application/vnd.org.jfrog.artifactory.security.User+json" -T $SCRIPT_DIR/json/users/${project}/delivery.json

# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/v2/security/permissions/${project}-reader -H "content-type: application/json" -T $SCRIPT_DIR/json/permissions/${project}/permission-reader.json
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/v2/security/permissions/${project}-dev -H "content-type: application/json" -T $SCRIPT_DIR/json/permissions/${project}/permission-dev.json
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/v2/security/permissions/${project}-delivery -H "content-type: application/json" -T $SCRIPT_DIR/json/permissions/${project}/permission-delivery.json

# CREATE watches
# curl -uadmin:$ADMIN_PASSWORD -X POST -H "content-type: application/json"  $ARTIFACTORY_URL/xray/api/v2/watches -T $SCRIPT_DIR/json/sec/watch-${project}.json

# UPDATE watches
# curl -uadmin:$ADMIN_PASSWORD -X PUT -H "content-type: application/json"  $ARTIFACTORY_URL/xray/api/v2/watches/${project}-dev -T $SCRIPT_DIR/json/sec/watch-${project}.json

# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/security/users/jenkins -H "content-type: application/vnd.org.jfrog.artifactory.security.User+json" -T $SCRIPT_DIR/json/users/${project}/delivery.json

########### SEC & OPS PERMISSIONS

# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/security/users/sec1 -H "content-type: application/vnd.org.jfrog.artifactory.security.User+json" -T $SCRIPT_DIR/json/users/sec.json
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/security/users/ops1 -H "content-type: application/vnd.org.jfrog.artifactory.security.User+json" -T $SCRIPT_DIR/json/users/ops.json

# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/v2/security/permissions/sec -H "content-type: application/json" -T $SCRIPT_DIR/json/permissions/permission-sec.json
# curl -uadmin:$ADMIN_PASSWORD -X PUT $ARTIFACTORY_URL/artifactory/api/v2/security/permissions/ops -H "content-type: application/json" -T $SCRIPT_DIR/json/permissions/permission-ops.json

# CREATE watches
# curl -uadmin:$ADMIN_PASSWORD -X POST -H "content-type: application/json"  $ARTIFACTORY_URL/xray/api/v2/watches -T $SCRIPT_DIR/json/sec/watch-sec.json
# curl -uadmin:$ADMIN_PASSWORD -X POST -H "content-type: application/json"  $ARTIFACTORY_URL/xray/api/v2/watches -T $SCRIPT_DIR/json/sec/watch-ops.json

# UPDATE watches
# curl -uadmin:$ADMIN_PASSWORD -X PUT -H "content-type: application/json"  $ARTIFACTORY_URL/xray/api/v2/watches/sec -T $SCRIPT_DIR/json/sec/watch-sec.json
# curl -uadmin:$ADMIN_PASSWORD -X PUT -H "content-type: application/json"  $ARTIFACTORY_URL/xray/api/v2/watches/ops -T $SCRIPT_DIR/json/sec/watch-ops.json

