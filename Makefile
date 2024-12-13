# report associated rules
report.html: install output/tabular.rds output/graph.rds report.Rmd 
	Rscript analysis/03_render.R

.PHONY: install
install:
	Rscript -e 'if (!("renv" %in% row.names(installed.packages()))) {install.packages("renv")}' &&\
	Rscript -e 'renv::restore(prompt=FALSE)'
	
output/tabular.rds: analysis/01_tabular.R
	Rscript analysis/01_tabular.R 

output/graph.rds: analysis/02_graph.R
	Rscript analysis/02_graph.R

.PHONY: clean
clean:
	rm -f output/*.rds && rm -f report.html && rm -f final_report/report.html
	

# Docker associated rules
# files that if changed, we would want to rebuild image 
PROJECTFILES = report.Rmd analysis/01_tabular.R analysis/02_graph.R Makefile
RENVFILES = renv.lock renv/activate.R 

# rule to build image
project_image: Dockerfile $(PROJECTFILES) $(RENVFILES)
	docker build -t project_image .
	touch $@  

# rule to build the report automatically in our container
final_report/report.html: 
	docker run -v "$$(pwd)/final_report":/home/rstudio/project/final_report project_image
    
window_final_report/report.html: 
	docker run -v \"$$(pwd)/final_report":/home/rstudio/project/final_report project_image
    