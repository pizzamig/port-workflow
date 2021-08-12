# FreeBSD git primer

With FreeBSD ports moved to git, the workflow didn't move to a PR based one, but we commit directly to `main`

I've locally configure my freebsd-ports repo with 2 remotes:
```
git remote -v
freebsd	    https://git.freebsd.org/ports.git (fetch)
freebsd	    ssh://git@gitrepo.FreeBSD.org/ports.git (push)
pizzamig	git@github.com:pizzamig/freebsd-ports.git (fetch)
pizzamig	git@github.com:pizzamig/freebsd-ports.git (push)

```

I have my dev branches in my github fork pizzamig/freebsd-ports.

## Before to commit

Update the local repo with:
```console
pre-commit
# or explicitely
git checkout main
git pull --ff-only
git fecth pizzamig
```

## Prepare to merge the PR

In the my fork, I have a branch, called `my-branch` that I want to commit.

Do the merge with:
```
git merge --squash --no-commit pizzamig/my-branch
```

Check the diff with:
```
git status
git diff HEAD
```

Undo changes with
```
git restore --staged <file>
git restore <file>
```

## Commit and push
Now, be prepared to write the commit message:

```
git commit
git log -1 # to get the hash
git push freebsd $hash:main
```

If committing a PR submitted by a contributor:
```
git commit --author="Jose Luis Duran <jlduran@gmail.com>"
git log -1 # to get the hash
git push --push-option=confirm-author freebsd $hash:main
```
If the push failed because in the meantime someone else committed something else:
```
git pull --rebase
git log -1 # to get the new hash
git push freebsd $hash:main
```
