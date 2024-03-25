
# Scrape Baseballr

A simple repo to scrape data from baseball savant using the baseballr package.

## Running Code

To run the pipeline locally

```
Rscript src/scrape-baseballr.R --start_date=2023-07-01 --end_date=2023-07-05 --level=lowa
```

To build the pipeline locally

```
make build
make scrape
```

To push docker image to AWS

```
aws configure
aws ecr-public get-login-password --region region | docker login --username AWS --password-stdin public.ecr.aws/path
docker tag scrape-baseballr:latest public.ecr.aws/path/scrape-baseballr:latest
docker push public.ecr.aws/path/scrape-baseballr:latest
```

