#!/bin/bash

set -ex

# variable CodeCommitBackupsS3Bucket is exported into CodeBuild environment variables from CFN output.
backup_s3_base_path="${CodeCommitBackupsS3Bucket}/codecommit"

git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

declare -a repos=(`aws codecommit list-repositories | jq -r '.repositories[].repositoryName'`)

for codecommitrepo in "${repos[@]}"
do
	# Comment out for testing, selectively re-enable.
    echo "[===== TODO Cloning repository: ${codecommitrepo} in region: ${AWS_REGION} =====]"
    git clone -q "https://git-codecommit.${AWS_REGION}.amazonaws.com/v1/repos/${codecommitrepo}"

    dt=$(date -u '+%Y_%m_%d_%H_%M')
    zipfile="${codecommitrepo}_backup_${dt}_UTC.tar.gz"
    echo "Compressing repository: ${codecommitrepo} into file: ${zipfile} and uploading to S3 bucket: ${backup_s3_base_path}/${codecommitrepo}"

    tar -zcf "${zipfile}" "${codecommitrepo}/"
    aws s3 cp "${zipfile}" "s3://${backup_s3_base_path}/${codecommitrepo}/${zipfile}" --region $AWS_REGION --acl bucket-owner-full-control

    rm $zipfile
    rm -rf "$codecommitrepo"
done
