# Git

### Rebasing
```shell
git rebase -i # Interactive rebase -> This allows you to fixup/squash/remove commit(s)

# To fix a specific commit
git log --pretty=oneline
git rebase -i ${commit hash to be changed}  # OR # git rebase -i HEAD~${number of commits to rebase eg. 3}
# in the resulting editor change `pick` to `edit`
# if the branch has already been pushed to the remote you'll need to force push
git push --force # if the upstream has been set correctly
```

### Upstream
```shell
git branch --set-upstream-to=origin/${branch-name} ${branch-name}
```

### Stash
```shell
git stash list
git stash apply ${stash number to apply}
git stash push -m "Comment to describe stash" # Do this to get a better description when stashing changes
```

### Running commands against all branches
```shell
@see [Github Filtering docuemntation](https://help.github.com/en/github/authenticating-to-github/removing-sensitive-data-from-a-repository)
Path="path to file you need delete"
git filter-branch --force --index-filter \
    "git rm --cached --ignore-unmatch ${Path}" \
    --prune-empty --tag-name-filter cat -- --all
touch .gitignore
vim .gitignore
git add .gitignore
git commit -m "Ignored files in current directory"
```
