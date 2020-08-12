# CONFIGURE 

specify Xray url and credentials in license.sh or by directly passing them as parameters of the script

```
xray_user=yann
xray_pass=chaysinh
xray_url="http://artifactory-eu.mydomain.com/xray/api/v1"
```

## Artifact level  

```
input_file="artifact_summary.json"
```

## Build level  

```
build_name="mvn-example"
build_number="36"
```

# EXECUTE 

## Artifact level 

```
./license.sh 
// OR 
./license.sh -r http://artifactory.mydomain.com/xray/api/v1 -u yann -p yann
```

## Build level 

```
./license.sh -b 
// OR 
./license.sh -b -r http://artifactory.mydomain.com/xray/api/v1 -u yann -p yann
```

