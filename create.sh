account_id=$(aws sts get-caller-identity --output text --query 'Account')

# Create a Function
zip function.zip function.sh bootstrap

aws lambda create-function --function-name bash-runtime \
--zip-file fileb://function.zip --handler function.handler --runtime provided \
--role arn:aws:iam::${account_id}:role/lambda-role

aws lambda invoke --function-name bash-runtime --payload '{"text":"Hello"}' response.txt

# Create a Layer
zip runtime.zip bootstrap

aws lambda publish-layer-version --layer-name bash-runtime --zip-file fileb://runtime.zip

LayerVersionArn=$(aws lambda publish-layer-version --layer-name bash-runtime --zip-file fileb://runtime.zip |jq -r .LayerVersionArn)

aws lambda update-function-configuration --function-name bash-runtime \
--layers ${LayerVersionArn}

