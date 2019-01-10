zip runtime.zip bootstrap
LayerVersionArn=$(aws lambda publish-layer-version --layer-name bash-runtime --zip-file fileb://runtime.zip |jq -r .LayerVersionArn)

aws lambda update-function-configuration --function-name bash-runtime \
--layers ${LayerVersionArn}
