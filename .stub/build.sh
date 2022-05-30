terraform fmt
terraform validate
tobuild=$(grep 'data\|resource' *.tf | grep '"' | grep  '{' | cut -f2 -d ':' | grep -v '#\|=' | grep aws_ |  wc -l)
rc=0
terraform state list 2> /dev/null | grep aws_ > /dev/null
if [ $? -eq 0 ]; then
        rc=$(terraform state list | grep aws_ | wc -l ) 
fi
echo "to build=$tobuild built=$rc"
if [ $rc -ge $tobuild ]; then echo "$rc in tf state expected $tobuild so skipping build ..." && continue; fi
rm -rf .terraform* backend.tf
terraform init -no-color -force-copy > /dev/null

echo "Terraform Plan"
terraform plan -out tfplan -no-color > /dev/null

# more control
#terraform apply -target="module.aws_vpc"
#terraform apply -target="module.eks_blueprints"
#terraform apply -target="module.eks_blueprints_kubernetes_addons"
#terraform apply -target="module.aws_load_balancer_controller"
#terraform apply -target="module.ingress_nginx"


terraform apply tfplan -no-color && terraform init -force-copy -no-color > /dev/null



rc=$(terraform state list | grep aws_ | wc -l)

if [ $rc -lt $tobuild ]; then echo "only $rc in tf state expected $tobuild .. exit .." && exit; fi
echo "check state counts"
    rsc=`terraform state list | wc -l`
    lsc=`terraform state list -state=terraform.tfstate | wc -l`
    echo "$rsc $lsc"
    if [ $rsc -ne $lsc ]; then
        echo "Remote state != local state count ... exit ..."
        exit
    fi

echo "PASSED: all ok to proceed"
    