# Scaling and Performance:

## 1. Scaling and performance levels

- Use auto-scaling based on traffic flow.
- Use Elastic Load Balancer (ELB) to distribute traffic.
- Use CloudFront to cache static content forlower load.
- Enable CloudWatch to see the performance and cause scaling to start.

## 2. Cost-control decisions

- Use Spot Instances, it can save up to 90% for work loads.
- right-size EC2 instances to use based on uses performance check and avoid over-provisioning.
- Use Auto Scaling to use resources only when needed.
- Use AWS Budgets to monitor the cloud expenditures.