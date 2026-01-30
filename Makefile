PAGES_BRANCH=gh-pages
MAIN=main
SLIDES_DIR=./../Slides/

all: update-slides

update-slides:
    git checkout $(PAGES_BRANCH)
    rsync -av --delete --exclude '.git/' $(SLIDES_DIR) ./
    git add .
    git commit -m "Automatic slides update"
    git push origin $(PAGES_BRANCH)
    git checkout $(MAIN)