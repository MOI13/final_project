report.html: report.Rmd analysis/03_render.R analysis/02_graph.R analysis/01_tabular.R
	Rscript analysis/03_render.R

.table: analysis/01_tabular.R
	Rscript analysis/01_tabular.R 

.graph: analysis/02_graph.R
	Rscript analysis/02_graph.R

.PHONY: clean
clean:
	rm -f output/*.rds && rm -f report.html