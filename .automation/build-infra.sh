echo "circa 45 minutes ..."
rm -f build.log
date >> build.log
cur=`pwd`
cd ~/environment/tfekscode/Launch/lb2
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json -s
cd $cur
buildok=1
#dirs="tfinit Launch/net Launch/iam Launch/c9net Launch/cluster Launch/nodeg Launch/lb2 Launch/cicd  Beginner/fargate Intermediate/Bottlerocket extra/nodeg2 extra/eks-cidr2"
#dirs="tfinit Launch/net Launch/iam Launch/c9net Launch/cluster Launch/nodeg Launch/lb2 Launch/cicd  Beginner/fargate Intermediate/Bottlerocket"
dirs="tfinit Launch/net Launch/c9net"

for i in `echo $dirs`;do
    echo $i
    ./build-stage.sh $i 2>&1 | tee -a build.log
    grep Error: build.log
    if [[ $? -eq 0 ]];then
        echo "Error: in build.log"
        exit
    fi
done
date >> build.log

