#!/bin/bash
echo "Staring..."

cd $GITHUB_WORKSPACE

FILE_NAME=VERSION

current_tag=$(cat $FILE_NAME)
not_updated=$(git log --stat -1 | grep -q "$FILE_NAME |")

git_setup() {
    cat <<-EOF >$HOME/.netrc
        machine github.com
        login $GITHUB_ACTOR
        password $GITHUB_TOKEN
        machine api.github.com
        login $GITHUB_ACTOR
        password $GITHUB_TOKEN
EOF
    chmod 600 $HOME/.netrc
    git config --global user.email "$(git log -1 --pretty=format:'%ae')"
    git config --global user.name "$(git log -1 --pretty=format:'%an')"
}

echo "Configuring Github credentials"
git_setup

if [ -z "$current_tag" ]
then
    current_tag=0.0.1
fi
echo "Current tag version: $current_tag"

if [ -z "$not_updated" ]
then
    echo "Updating version"
    new_tag=$(semver bump patch $current_tag)
    echo "$new_tag" > $FILE_NAME
    echo "New version: "
    cat $FILE_NAME
    git add $FILE_NAME
    git commit -m "Auto tag $(new_tag)"
else
    new_tag=$(current_tag)
fi

git tag -f "$new_tag"

git log --format=oneline -2

echo "Sending commitss"
git push --set-upstream origin
git push --set-upstream origin --tags
echo "Successful work"