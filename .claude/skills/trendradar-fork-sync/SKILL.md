---
name: trendradar-fork-sync
description: Git 工作流：从上游同步 master（fork 主分支）、将 master 合并到 dev。在用户说「同步 fork」「拉取上游」「merge master 到 dev」「fork 到 master」或询问 fork/分支同步时使用。
---

# TrendRadar Fork 与分支同步

本仓库约定：**master** 仅用于与上游同步，不做自定义修改；**dev** 为自用开发分支。

## 1. 从上游同步主分支（fork 主分支 / fork 到 master）

当需要把原仓库（sansan0/TrendRadar）的最新改动同步到本地的 master 时：

```bash
git checkout master
git fetch upstream
git merge upstream/master
```

可选：把更新后的 master 推送到你自己的 GitHub fork：

```bash
git push origin master
```

**前置**：已配置远程 `upstream` 指向原仓库：

```bash
git remote add upstream https://github.com/sansan0/TrendRadar.git
```

- **origin**：你的 fork（如 `https://github.com/SongYuanKun/TrendRadar.git`）
- **upstream**：原仓库（`https://github.com/sansan0/TrendRadar.git`）

---

## 2. 把 master 合并到 dev

在 dev 上开发时，需要把已同步好的 master 合进来：

```bash
git checkout dev
git merge master
```

若有冲突，解决后：

```bash
git add -A
git commit -m "merge: master 合并到 dev"
git push origin dev
```

---

## 常用顺序

1. 先做「1. 同步主分支」更新 master。
2. 再做「2. 合并到 dev」，在 dev 上继续开发并推送。
