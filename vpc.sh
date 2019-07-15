cd /terraform/vpc/
terraform init -input=false 
terraform plan -out=tfplan -input=false 
terraform apply -input=false tfplan
sleep 60s
sed -e "s/\${hv-private-1}/` cat terraform.tfstate |jq '.modules[0] .resources."aws_subnet.hv-private-1".primary.id' | sed 's/"//g'`/" /terraform/vpc/test > test1
sleep 5s
sed -e "s/\${hv-public-1}/` cat terraform.tfstate |jq '.modules[0] .resources."aws_subnet.hv-public-1".primary.id' | sed 's/"//g'`/" /terraform/vpc/test1 > /ansible/kafka/tasks/main.yml
