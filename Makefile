report.html: report.Rmd analysis/03_render.R analysis/02_graph.R analysis/01_tabular.R output/graph.rds output/tabular.rds
	Rscript analysis/03_render.R

output/tabular.rds: analysis/01_tabular.R
	Rscript analysis/01_tabular.R 

output/graph.rds: analysis/02_graph.R
	Rscript analysis/02_graph.R

.PHONY: clean
clean:
	rm -f output/*.rds && rm -f report.html