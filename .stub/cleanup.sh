rm -f  backend.tf
terraform init -no-color -migrate-state -force-copy 
terraform destroy -auto-approve -no-color 
rc=$(terraform state list | wc -l)
if [ $rc -gt 0 ];then
    echo "**** Unexpected resources left in state exit ...."
    exit
else
    echo "OK - $rc resources left, cleaning directory"
fi
rm -f terraform.tfstate* tfplan 
rm -rf .terraform
echo "Done"
