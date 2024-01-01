#### 将本地仓库推送到远程仓库
```
git fetch origin	//刷新远程分支
git branch -u origin/dev //将本地当前分支和远程origin/dev分支进行关联绑定
git push --set-upstream origin main // 将本地分支与远程分支关联，并立即推送
git push origin 本地分支名：远程分支名
git remote -v //查看远程仓库
git remote set-url origin git@github... //重新设置远程仓库的链接
```

