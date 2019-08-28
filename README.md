# Backup and Recovery Features (B.A.R.F)

## What is this?

A system to do backups of resources in AWS. Using deployspec.

## CodeCommit Backups

Uses a CodeBuild job in automation account to run a bash script that uses awscli to clone repos, zip them up and upload them to s3.

Backups will go into comp account as part of a multi-account resilience design (harder to trash everything).

## TODO

* Backup topic in automation account - send status update content there.
* Metric filter alarms for failed backups etc?
* More backup systems.
