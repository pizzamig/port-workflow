#!/bin/sh -e

: ${GIT:="git"}
: ${FREEBSD_MIRROR:="https://github.com/freebsd/freebsd-ports.git"}
: ${GITHUB_ORIGIN:="git@github.com:pizzamig/freebsd-ports.git"}

: ${FLAG_VERBOSE:=0}
: ${WKDIR:=freebsd-ports}

wkdir_checkout()
{
  git clone "${GITHUB_ORIGIN}" "${WKDIR}"
  (
  	cd "${WKDIR}"
	git remote add upstream "${FREEBSD_MIRROR}"
	git fetch upstream
  )
}

init_check()
{
  # git tool checkt
  if ! command -v ${GIT} ; then
	  echo No $GIT found && exit 1
  fi
  # working copy of freebsd port check
  if [ ! -d "${WKDIR}" ]; then
    echo "Missing the Working dir - checking it out"
    wkdir_checkout
  fi

}

upstream_update()
{
  (
    cd ${WKDIR}
	echo git fetch upstream
    git fetch upstream
	echo git checkout main
    git checkout main
	echo git merge upstream/master
    git pull --ff-only upstream main
  )
}

branches_update()
{
  (
    cd ${WKDIR}
    for B in $(git branch | grep -v main) ; do
      echo git checkout "$B"
      git checkout "$B"
      echo git rebase main
      git rebase main
    done
	git checkout main
  )
}

push_branches()
{
  (
    cd ${WKDIR}
    echo git push main
    git push origin main
    for B in $(git branch | grep -v main) ; do
      echo git push "$B"
      git push --force origin "$B"
    done
  )
}

usage()
{
  echo "$(basename ${0}) [-hv]"
  echo '	-h print this help'
  echo '	-v verbose'
}

args=$(getopt hv $*)

if [ $? -ne 0 ]; then
  usage
  exit
fi

set -- $args

while true; do
  case "$1" in
  -h)
    usage
    exit 0
    ;;
  -v)
    FLAG_VERBOSE=1
    shift
    ;;
  --)
    break
    shift
    ;;
  *)
    usage
    exit 1
    ;;
  esac
done

init_check
upstream_update
branches_update
push_branches
