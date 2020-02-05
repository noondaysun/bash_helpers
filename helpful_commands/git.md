# Git

### Rebasing
```
git rebase -i # Interactive rebase -> This allows you to fixup/squash/remove commit(s)

# To fix a specific commit
git log --pretty=oneline
git rebase -i ${commit hash to be changed}  # OR # git rebase -i HEAD~${number of commits to rebase eg. 3}
# in the resulting editor change `pick` to `edit`
# if the branch has already been pushed to the remote you'll need to force push
git push --force # if the upstream has been set correctly
```

### Upstream
```
git branch --set-upstream-to=origin/${branch-name} ${branch-name}
```

### Stash
```
git stash list
git stash apply ${stash number to apply}
git stash push -m "Comment to describe stash" # Do this to get a better description when stashing changes
```