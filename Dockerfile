
# Use the Rocker tidyverse image as the base
FROM rocker/tidyverse:latest

# Install additional R packages
RUN R -e "install.packages(c('here', 'baseballr', 'argparse', 'progress', 'RcppParallel', 'janitor', 'snakecase', 'findpython'), dep = F)"

# Copy the R scripts into the container
COPY data/. /data/
COPY src/. /src/

# set working directory
WORKDIR /src

# define entrypoint
ENTRYPOINT ["bash", "docker-entrypoint.sh"]
