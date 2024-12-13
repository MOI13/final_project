FROM rocker/rstudio AS base
RUN apt-get update && apt-get -y install pandoc \
    libcurl4-openssl-dev \
    libxml2-dev \
    zlib1g-dev \
    g++ \
    cmake \
    libfontconfig1-dev \
    libfreetype6-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev

RUN mkdir /home/rstudio/project
WORKDIR /home/rstudio/project

RUN mkdir -p renv
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R

RUN mkdir renv/.cache
ENV RENV_PATHS_CACHE=renv/.cache

RUN Rscript -e "renv::restore(prompt = FALSE)"


###### DO NOT EDIT STAGE 1 BUILD LINES ABOVE ######
FROM rocker/rstudio

WORKDIR /home/rstudio/project
COPY --from=base /home/rstudio/project .

ENV WHICH_CONFIG=default

RUN mkdir final_report 
RUN mkdir analysis
RUN mkdir output
RUN mkdir data
RUN mkdir data/intermediate

COPY analysis analysis
COPY Makefile .
COPY report.Rmd .
COPY data/raw/surveysDepreST-CAT.csv data/raw/surveysDepreST-CAT.csv


CMD make && mv report.html final_report/


