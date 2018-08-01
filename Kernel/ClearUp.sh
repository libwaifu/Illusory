#!/usr/bin/env bash
# grep + 需要删除的 tag 头
git tag | grep "untagged" |xargs git tag -d
git show-ref --tag | grep "untagged"| awk '{print $2}'|xargs git push origin --delete
