###############################################
#DRAFT
###############################################

###############################################
#Prepare your local environment
###############################################
#keep your git directory in memory for latest command
export SCRIPT_DIR=$(pwd)

#save your password

export ADMIN_PASSWORD=<password>

#save artifactory url
export ARTIFACTORY_URL=<url>

curl http://$ARTIFACTORY_URL/artifactory/api/system/ping 



##############
## 1st Lab
##############

# OPTIONAL : delete default permissions target
curl -uadmin:$ADMIN_PASSWORD -X DELETE http://$ARTIFACTORY_URL/artifactory/api/v2/security/permissions/Anything
curl -uadmin:$ADMIN_PASSWORD -X DELETE http://$ARTIFACTORY_URL/artifactory/api/v2/security/permissions/Any%20Remote


# Create base needed repository for gradle (gradle-dev-local, jcenter, libs-release)
curl -uadmin:$ADMIN_PASSWORD -X PUT http://$ARTIFACTORY_URL/artifactory/api/repositories/gradle-dev-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/module1/repository-gradle-dev-local-config.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://$ARTIFACTORY_URL/artifactory/api/repositories/gradle-staging-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/module1/repository-gradle-dev-local-config.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://$ARTIFACTORY_URL/artifactory/api/repositories/gradle-prod-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/module1/repository-gradle-dev-local-config.json

curl -uadmin:$ADMIN_PASSWORD -X PUT http://$ARTIFACTORY_URL/artifactory/api/repositories/jcenter -H "content-type: application/vnd.org.jfrog.artifactory.repositories.RemoteRepositoryConfiguration+json" -T $SCRIPT_DIR/module1/jcenter-remote-config.json

curl -uadmin:$ADMIN_PASSWORD -X PUT http://$ARTIFACTORY_URL/artifactory/api/repositories/libs-releases -H "content-type: application/vnd.org.jfrog.artifactory.repositories.VirtualRepositoryConfiguration+json" -T $SCRIPT_DIR/module1/repository-gradle-release-virtual-config.json

#create all with yaml configuration file
curl -uadmin:$ADMIN_PASSWORD -X PATCH  http://$ARTIFACTORY_URL/artifactory/api/system/configuration -T $SCRIPT_DIR/module1/repo.yaml

#create backend-dev, front-end dev, framework maintainer and release groups
curl -uadmin:$ADMIN_PASSWORD -X PUT http://$ARTIFACTORY_URL/artifactory/api/security/groups/dev-team -H "content-type: application/vnd.org.jfrog.artifactory.security.Group+json" -T $SCRIPT_DIR/module1/group.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://$ARTIFACTORY_URL/artifactory/api/security/groups/release-team -H "content-type: application/vnd.org.jfrog.artifactory.security.Group+json" -T $SCRIPT_DIR/module1/group.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://$ARTIFACTORY_URL/artifactory/api/security/groups/security-team -H "content-type: application/vnd.org.jfrog.artifactory.security.Group+json" -T $SCRIPT_DIR/module1/group.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://$ARTIFACTORY_URL/artifactory/api/security/groups/delivery-team -H "content-type: application/vnd.org.jfrog.artifactory.security.Group+json" -T $SCRIPT_DIR/module1/group.json

#create a new user for the dev team
export USER_LOGIN=<SetUserName>

curl -uadmin:$ADMIN_PASSWORD -X PUT http://$ARTIFACTORY_URL/artifactory/api/security/users/$USER_LOGIN -H "content-type: application/vnd.org.jfrog.artifactory.security.User+json" -T $SCRIPT_DIR/module1/user.json

#a release engineer
curl -uadmin:$ADMIN_PASSWORD -X PUT http://$ARTIFACTORY_URL/artifactory/api/security/users/release -H "content-type: application/vnd.org.jfrog.artifactory.security.User+json" -T $SCRIPT_DIR/module1/qa.json

#a consumer for prod
curl -uadmin:$ADMIN_PASSWORD -X PUT http://$ARTIFACTORY_URL/artifactory/api/security/users/prod -H "content-type: application/vnd.org.jfrog.artifactory.security.User+json" -T $SCRIPT_DIR/module1/delivery.json

#Login with user and show tree view (it is empty)

#create permission
curl -uadmin:$ADMIN_PASSWORD -X PUT http://$ARTIFACTORY_URL/artifactory/api/v2/security/permissions/perm-dev -H "content-type: application/json" -T $SCRIPT_DIR/module1/permission-dev.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://$ARTIFACTORY_URL/artifactory/api/v2/security/permissions/perm-release -H "content-type: application/json" -T $SCRIPT_DIR/module1/permission-release.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://$ARTIFACTORY_URL/artifactory/api/v2/security/permissions/perm-prod -H "content-type: application/json" -T $SCRIPT_DIR/module1/permission-prod.json

#Refresh session with new user and show the repos

#Get Api key for user
curl -u$USER_LOGIN:password31 -X POST http://$ARTIFACTORY_URL/artifactory/api/security/apiKey

export API_KEY=<apiKey>
##############
## 2nd Lab
##############
#configure the cli for dev profile
jfrog rt c orbitera

#Upload generic libs to Artifactory with props
#profile for release with write permission on tomcat-local
jfrog rt c orbitera-release
jfrog rt use orbitera-release

jfrog rt u ....
# jfrog rt u /Users/jon/workspace/kubernetes_example/docker-framework/tomcat/apache-tomcat-8.tar.gz tomcat-local/

# Find largest and not in use
curl -uadmin:$ADMIN_PASSWORD -X POST http://$ARTIFACTORY_URL/artifactory/api/search/aql -T $SCRIPT_DIR/module2/largestFile.aql
#or
jfrog rt s --spec module2/largestSpec.spec

# Find the latest released artifacts from specific build
jfrog rt s --spec module2/latest-webservice.json


#AQl to find all archive with specific jar in it
 curl -uadmin:$ADMIN_PASSWORD -X POST http://$ARTIFACTORY_URL/artifactory/api/search/aql -T $SCRIPT_DIR/module2/junitfilter.aql

#AQL for cleanup
curl -uadmin:$ADMIN_PASSWORD -X POST http://$ARTIFACTORY_URL/artifactory/api/search/aql -T $SCRIPT_DIR/module2/cleanup.aql

##############
## 3nd Lab
##############
export BUILD_NUMBER=1
export IMAGE_TAG=$BUILD_NUMBER

# Configure cli for gradle
jfrog rt gradlec

# run build 
jfrog rt gradle "clean artifactoryPublish -b build.gradle --info" --build-name=gradle --build-number=$BUILD_NUMBER

# build info
jfrog rt bp gradle $BUILD_NUMBER

# Find the latest released artifacts from specific build
jfrog rt s --spec $SCRIPT_DIR/module3/latest-webservice.json

#Now we go on QA (use release user)
jfrog rt use orbitera-release

#Test run and promote ?
jfrog rt bpr gradle $BUILD_NUMBER gradle-staging-local --status=staged --copy=true

# Find the latest released artifacts from specific build (now in dev and staging repo)
jfrog rt s --spec $SCRIPT_DIR/module3/latest-webservice.json

#security
#add build to scan
curl -uadmin:$ADMIN_PASSWORD -X PUT -H "content-type: application/json"  http://$ARTIFACTORY_URL/xray/api/v1/binMgr/default/builds -T $SCRIPT_DIR/module3/indexed.json

#scan
jfrog rt bs gradle $BUILD_NUMBER

#no alert
#create some watches and policies
curl -uadmin:$ADMIN_PASSWORD -X POST -H "content-type: application/json"  http://$ARTIFACTORY_URL/xray/api/v1/policies -T $SCRIPT_DIR/module3/policy.json
curl -uadmin:$ADMIN_PASSWORD -X POST -H "content-type: application/json"  http://$ARTIFACTORY_URL/xray/api/v2/watches -T $SCRIPT_DIR/module3/watch.json

#scan again
jfrog rt bs gradle $BUILD_NUMBER

#promote the build
jfrog rt bpr gradle $BUILD_NUMBER gradle-prod-local --status=released --copy=true

jfrog rt s --spec $SCRIPT_DIR/module3/latest-webservice.json

#switch to release user
jfrog rt c orbitera-delivery

jfrog rt use orbitera-delivery

#Can access qualified artifact (and not form non prod repo)
jfrog rt s --spec $SCRIPT_DIR/module3/latest-webservice.json


#docker framework

#jfrog rt dpl $ARTIFACTORY_URL/docker-virtual/openjdk:11-jdk docker --build-name=docker --build-number=1
jfrog rt dl --spec framework-download.json --build-name=docker-framework --build-number=$BUILD_NUMBER --module=framework

#we are dev
jfrog rt use orbitera
#For now use my own fork with insecure mode in it
./jfrog1 rt dpl $ARTIFACTORY_URL/docker-virtual/openjdk:11-jdk docker-virtual --build-name=docker-framework --build-number=$BUILD_NUMBER --module=framework


docker build . -t $ARTIFACTORY_URL/docker-virtual/jfrog-docker-framework:$IMAGE_TAG -f Dockerfile --build-arg REGISTRY=$ARTIFACTORY_URL/docker-virtual

jfrog rt dp $ARTIFACTORY_URL/docker-virtual/jfrog-docker-framework:$IMAGE_TAG docker-virtual --build-name=docker-framework --build-number=1 --module=framework

jfrog rt bp docker-framework $BUILD_NUMBER


#scan
jfrog rt use orbitera-release

jfrog rt bs docker-framework $BUILD_NUMBER

#promote

jfrog rt bpr docker-framework $BUILD_NUMBER docker-prod-local --status=released --copy=true


#docker app
./jfrog1 rt dpl $ARTIFACTORY_URL/docker-virtual/jfrog-docker-framework:1 docker-virtual --build-name=docker-app --build-number=$BUILD_NUMBER --module=app 

jfrog rt dl --spec appmodules-download.json --build-name=docker-app --build-number=$BUILD_NUMBER --module=app

#build
jfrog rt use orbitera

docker build . -t $ARTIFACTORY_URL/docker-virtual/jfrog-docker-app:$IMAGE_TAG  -f Dockerfile --build-arg REGISTRY=$ARTIFACTORY_URL/docker-virtual --build-arg BASE_TAG=$IMAGE_TAG

jfrog rt dp $ARTIFACTORY_URL/docker-virtual/jfrog-docker-app:$IMAGE_TAG docker-virtual --build-name=docker-app --build-number=$BUILD_NUMBER --module=app

jfrog rt bp docker-app $BUILD_NUMBER

#scan
jfrog rt use orbitera-release

jfrog rt bs docker-app $BUILD_NUMBER

#promote

jfrog rt bpr docker-app $BUILD_NUMBER docker-prod-local --status=released --copy=true

#helm
jfrog rt use orbitera

sed -ie 's/0.1.1/0.1.'"$BUILD_NUMBER"'/' docker-app-chart/Chart.yaml
sed -ie 's/latest/'"$IMAGE_TAG"'/g' docker-app-chart/values.yaml

jfrog rt bce helm-build $BUILD_NUMBER

jfrog rt dl docker-prod-local/jfrog-docker-app/$IMAGE_TAG/manifest.json --build-name=helm-build --build-number=$BUILD_NUMBER --module=app

helm package ./docker-app-chart/

jfrog rt u '*.tgz' helm-virtual --build-name=helm-build --build-number=$BUILD_NUMBER --module=app

jfrog rt bp helm-build $BUILD_NUMBER

#security 
curl -uadmin:$ADMIN_PASSWORD -X POST -H "content-type: application/json"  http://$ARTIFACTORY_URL/xray/api/v1/policies -T $SCRIPT_DIR/module4/security-policy.json
curl -uadmin:$ADMIN_PASSWORD -X POST -H "content-type: application/json"  http://$ARTIFACTORY_URL/xray/api/v1/policies -T $SCRIPT_DIR/module4/license-policy.json
curl -uadmin:$ADMIN_PASSWORD -X POST -H "content-type: application/json"  http://$ARTIFACTORY_URL/xray/api/v2/watches -T $SCRIPT_DIR/module4/watch.json

# redo the whole thing or show it in pipelines and trigger a build on docker framework
#or just use delivery to pull
jfrog rt use orbitera-delivery

jfrog rt dpl $ARTIFACTORY_URL/docker-virtual/jfrog-docker-app:1 docker-virtual


# distribution 

curl -uadmin:$ADMIN_PASSWORD -X PUT http://$ARTIFACTORY_URL/artifactory/api/v2/security/permissions/perm-delivery -H "content-type: application/json" -T $SCRIPT_DIR/module5/permission-delivery.json

jfrog rt rbc myApp 1.0.$BUILD_NUMBER --sign=true --spec=$SCRIPT_DIR/module5/rb-spec.json --spec-vars BUILD_NUMBER=$BUILD_NUMBER

#need to create target repositories for distribution on edge
export EDGE_URL=<edgeUrl>

curl -uadmin:$ADMIN_PASSWORD -X PATCH  http://$EDGE_URL/artifactory/api/system/configuration -T $SCRIPT_DIR/module1/repo.yaml

curl -uadmin:$ADMIN_PASSWORD -H "content-type: application/json"  -X PUT http://$ARTIFACTORY_URL/distribution/api/v1/security/permissions/perm-delivery -T $SCRIPT_DIR/module5/permission-destination.json 

jfrog rt rbd myApp 1.0.$BUILD_NUMBER --dist-rules=$SCRIPT_DIR/module5/dist-rules.json


#maintenance


#AQl to find all archive with specific jar in it
curl -uadmin:$ADMIN_PASSWORD -X POST http://$ARTIFACTORY_URL/artifactory/api/search/aql -T $SCRIPT_DIR/module6/junitfilter.aql

#AQL for stats
curl -uadmin:$ADMIN_PASSWORD -X POST http://$ARTIFACTORY_URL/artifactory/api/search/aql -T $SCRIPT_DIR/module6/stats.aql

curl -uadmin:$ADMIN_PASSWORD -X POST http://$ARTIFACTORY_URL/artifactory/api/search/aql -T $SCRIPT_DIR/module6/largestFile.aql
#or
jfrog rt s --spec $SCRIPT_DIR/module6/cleanup.spec