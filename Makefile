report.html: report.Rmd analysis/03_render.R install output/tabular.rds output/graph.rds 
	Rscript analysis/03_render.R

.PHONY: install
install:
	Rscript -e 'if (!("renv" %in% row.names(installed.packages()))) {install.packages("renv")}'
	Rscript -e 'renv::restore()'
	
output/tabular.rds: analysis/01_tabular.R
	Rscript analysis/01_tabular.R 

output/graph.rds: analysis/02_graph.R
	Rscript analysis/02_graph.R

.PHONY: clean
clean:
	rm -f output/*.rds && rm -f report.html 
	
