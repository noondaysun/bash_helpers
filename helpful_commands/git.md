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

A note on rebasing and .git/hooks/post-checkout. It can result in the rebase resulting in a detached head state.<br />
Might be worth doing someting like the following
```shell
mv .git/hooks/post-checkout .git/hooks/post-checkout-rebase
git rebase -i branch
mv .git/hooks/post-checkout-rebase .git/hooks/post-checkout
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
