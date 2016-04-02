all: serve

serve:
	@echo "Serving the static pages using Jekyll"
	bundle exec jekyll serve --incremental
