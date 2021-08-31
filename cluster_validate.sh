#!/bin/bash
kops validate cluster --name ivan.k8s.local --state s3://ibutsko --wait 10m
