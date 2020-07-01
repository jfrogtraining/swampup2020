# CONFIGURE 

specify Xray url and credentials in license.sh or by directly passing them as parameters of the script

```
xray_user=yann
xray_pass=chaysinh
xray_url="http://artifactory-eu.mydomain.com/xray/api/v1"
```

## Artifact level  

edit input/artifact_comp_details.json  


## Build Info level

edit input/build_info_comp_details.json


## Watch level

edit input/get_violations.json level 


# EXECUTE 

## Artifact level 

```
./security_metrics.sh 

# OR 
./security_metrics.sh -r http://artifactory.mydomain.com/xray/api/v1 -u yann -p yann
```

## Build level 

```
./security_metrics.sh -b 

# OR 
./security_metrics.sh -b -r http://artifactory.mydomain.com/xray/api/v1 -u yann -p yann
```

## Watch level

```
./security_metrics_watch.sh 

# OR 
./security_metrics_watch.sh -r http://artifactory.mydomain.com/xray/api/v1 -u yann -p yann
```
