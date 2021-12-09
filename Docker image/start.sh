#!/bin/bash
set -e

cd /tmp
mkdir actions-runner && cd actions-runner
GITHUB_RUNNER_VERSION=$(curl --silent https://api.github.com/repos/actions/runner/releases/latest | grep '"tag_name":' | cut -d'"' -f4|sed 's/^.//')
sleep 5
curl -Ls https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz | tar -zx
sleep 5

PAT=$(aws secretsmanager get-secret-value --secret-id PAT --region ${AWS_REGION} --query SecretString --output text | jq -r '.PAT')
owner=$(aws secretsmanager get-secret-value --secret-id owner --region ${AWS_REGION} --query SecretString --output text | jq -r '.owner')
repo=$(aws secretsmanager get-secret-value --secret-id repo --region ${AWS_REGION} --query SecretString --output text | jq -r '.repo')

token=$(curl -s -XPOST \
    -H "authorization: token ${PAT}" \
    https://api.github.com/repos/${owner}/${repo}/actions/runners/registration-token |\
    jq -r .token)


./config.sh --url https://github.com/${owner}/${repo} --token $token --name "aws-runner-$(hostname)"  --work _work --labels ${RUNNER_LABELS} --ephemeral
./run.sh
