git co gh-pages
git reset --hard master
./build.sh
git add -f index.html
git ci -m "Publish latest"
git push -f
git co -
