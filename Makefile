all: serve

serve: build
	@echo "Serving the static pages using Jekyll"
	bundle exec jekyll serve --incremental

build: clean
	@echo "Building the site ..."
	bundle exec jekyll build --verbose --watch &

clean:
	@echo "Cleaning the project"
	bundle exec jekyll clean
