#!/usr/bin/env bash

__git_hook_builder_commit_msg() {
 echo "[INFO] Adding commit-msg"
 echo "Enter your JIRA prefix (for example WAP) or empty for skipe:"
 read JIRA

 if [ -n "$JIRA" ]; then
  echo "[INFO] Loading 'commit-msg' template..."
  base_dir=$(git rev-parse --show-toplevel);
  cp $GIT_HOOK_BUILDER_BASE_PATH/commit-msg.tmpl $base_dir/.git/hooks/commit-msg
  sed -i -e "s;%JIRA%;$JIRA;g" $base_dir/.git/hooks/commit-msg
 else
  echo "[WARNING] Adding commit-msg skiped."
 fi
}

__git_hook_builder_maven() {
 __git_hook_builder_commit_msg
 echo "[INFO] Adding pre-push"
 base_dir=$(git rev-parse --show-toplevel);
 echo "[INFO] Loading 'pre-push' template..."
 cp $GIT_HOOK_BUILDER_BASE_PATH/pre-push.tmpl $base_dir/.git/hooks/pre-push
}

__git_hook_builder() {
type=NONE
base_dir=$(git rev-parse --show-toplevel);

if [ -f "$base_dir/pom.xml" ]; then
 type=MAVEN
fi

case $type in
"MAVEN")
 echo "[INFO] Project type is is MAVEN.";
 __git_hook_builder_maven
 ;;
*)
 echo "[ERROR] Project type is undefined.";
esac
};

if [ "$1" = "" ]; then
 GIT_HOOK_BUILDER_BASE_PATH=`dirname $BASH_SOURCE`
 git config --global alias.hook '! env GIT_HOOK_BUILDER_BASE_PATH='`echo $GIT_HOOK_BUILDER_BASE_PATH`' sh '`echo $GIT_HOOK_BUILDER_BASE_PATH`'/git-hook-builder.sh run'
elif [ "$1" = "run" ]; then
 echo $GIT_HOOK_BUILDER_BASE_PATH
  __git_hook_builder
fi
