Assignment 1: CPU-bound background job processor
================================================

This is a take home assignment where you will build a background job processor on an elastically-scaled Kubernetes cluster on AWS. You will expose a public-facing API endpoint which solely queues a job on the cluster. This job performs a CPU-bound process, for the purpose of this assignment, you do not need to know the details or implement the job, you only need to understand it is a CPU-bound process which pins a single core for a period of time. 

We have provided two python environments with the following functionality:
 1. A HTTP server which has an API endpoint for scheduling new jobs on the cluster. See [here](./api-server/).
 2. The job script which pins a single CPU core for a period of time. See [here](./background-job/).

You will need to build all the necessary components to provision and deploy the cluster and the service running on it. We expect the following characteristics of the solution you provide:

 [x] The API endpoint should always remain available, regardless of the number of jobs in the queue.
 [X] The underlying compute nodes should be elastic and the compute capacity must tightly fit the actual load on the cluster. We do not want to see massively over-provisioned nodes.
 [X] The kubernetes stack must be hosted on AWS. You can use 3rd party tools for anything outside of the main cluster, including provisioning and deployment.
 [X] Deployment of the stack and code is to be automated, using the CI/CD platform of your choice.
 [] It must be a simple task to deploy your stack on another AWS account or region.
 [X] There must be a way to view and search stdout/err logs from active and terminated pods in the cluster.

In order to assess the scaling behaviour of the infrastructure you will need to configure monitoring for nodes in your cluster. In this case we expect the following metrics:
 [] CPU-utilisation for all active nodes in the cluster
 [] The total CPU-utilisation of the entire cluster. 
 [] You may use any monitoring or observability tool of your choice.

You will be assessed on the quality of your solution according to the prior criteria, with a particular focus on the scaling behaviour of your cluster.

All code and scripts must be put in a public GitHub repository. Include a README.md with instructions for provisioning and any other information you feel is relevant. 


# Quickstart

## Boostrap
First we need to do some bootstrapping

* Created an aws access key pair and add them to your environment.  They should be named AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
* `$ cd infrastructure && terraform init && terraform apply`
* `$ helm install aws-load-balancer-controller eks/aws-load-balancer-controller --set clusterName=recall -n kube-system`

## Deploy
To deploy the app, make sure you have a valid and working `~/.kube/config` file for the k8s cluster you want to deploy to.  You can check this by running: `kubectl cluster-info`.  If you get information about a k8s cluster you are ready to go.

Make sure to push to github to ensure that dockerhub has the version tied to this git commit hash, then simply run:
`$ ./deploy.sh`

