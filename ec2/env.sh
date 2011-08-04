# Source this file from your profile to set up Amazon EC2 command-line tools.
# e.g. "source ~/projects/reportgrid/infrastructure/ec2/env.sh"
#
# Download tools at: http://aws.amazon.com/developertools
#

EC2_INF_HOME=~/reportgrid/infrastructure/ec2
EC2_ROOT=~/bin/ec2

export EC2_HOME=${EC2_ROOT}/ec2-api-tools
export EC2_AMITOOL_HOME=${EC2_ROOT}/ec2-ami-tools
export AWS_ELB_HOME=${EC2_ROOT}/ElasticLoadBalancing
export AWS_IAM_HOME=${EC2_ROOT}/IAMCli

export PATH=$PATH:${EC2_HOME}/bin:${EC2_AMITOOL_HOME}/bin:${AWS_ELB_HOME}/bin:${AWS_IAM_HOME}/bin

export AWS_CREDENTIAL_FILE=${EC2_INF_HOME}/AWS_CREDENTIAL_FILE
export EC2_PRIVATE_KEY=${EC2_INF_HOME}/pk-4BW2DIHA5GCKJGO6YJWKFK27OX7Q3HCK.pem
export EC2_CERT=${EC2_INF_HOME}/cert-4BW2DIHA5GCKJGO6YJWKFK27OX7Q3HCK.pem
