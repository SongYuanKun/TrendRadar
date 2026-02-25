# AI 优化文档格式规范

> 目标：减少 token 占用，保持关键信息完整。供人类编写、AI 解析。

---

## 1. 元数据（必选）

每份文档开头用 YAML frontmatter 声明上下文：

```yaml
---
ver: 1          # 格式版本
lang: zh        # zh|en
scope: repo    # repo|api|config|guide
updated: YYYY-MM-DD
---
```

| 字段 | 必选 | 说明 |
|------|------|------|
| ver | ✓ | 格式版本，便于解析器兼容 |
| lang | ✓ | 内容语言 |
| scope | ✓ | 文档类型/作用域 |
| updated | 建议 | 最后更新日期 |

---

## 2. 推荐结构：YAML 优先

- 用 **YAML** 表达结构化内容（比 JSON 省引号、逗号，可注释）。
- 键名用**小写 + 下划线**，控制在 2–3 词内。
- 列表项能用一个词说清的，直接写标量；否则用 `- key: val`。

```yaml
# 示例：配置说明
steps:
  - id: sync
    cmd: [checkout, fetch, merge]
    remote: upstream
  - id: merge_dev
    cmd: [checkout, merge]
    branch: master
```

---

## 3. 标准缩写与术语

在文档内或项目词表中统一使用，减少重复长词。

| 完整词 | 缩写/术语 | 用途 |
|--------|-----------|------|
| 仓库 / repository | repo | 泛指代码库 |
| 分支 | branch | 不缩写 |
| 合并 | merge | 不缩写 |
| 上游 | upstream | 远程仓库名 |
| 拉取/同步 | fetch + merge | 不写「从上游拉取并合并」 |
| 提交 | commit | 不缩写 |
| 远程 | remote | git remote |
| 工作流 / workflow | flow | 可选 |
| 配置 | config | 不缩写 |
| 文档 | doc | 可选 |
| 应用程序 | app | 可选 |
| 说明 / 描述 | desc | 仅在键名中 |
| 可选 / 非必选 | opt | 仅在表格/字段说明中 |
| 必选 / 必须 | req | 同上 |

---

## 4. 书写原则

1. **一句一事**：一句只表达一个动作或一个事实。
2. **先结论后条件**：先写「做什么」，再写「何时/何地/谁」。
3. **用列表代替段落**：能列点的不用长段描述。
4. **避免重复**：同一概念在一段内只写一次，用引用或键名复用。
5. **数字/日期用 ISO 或数字**：如 `2025-01-01`、`ver: 1`。

---

## 5. 示例：完整短文档

```yaml
---
ver: 1
lang: zh
scope: guide
updated: 2025-02-25
---

title: Fork 同步流程
desc: 从上游同步 master，再合并到 dev。

remotes:
  origin: "fork 仓库（己方）"
  upstream: "原仓库（同步源）"

steps:
  - id: sync_master
    desc: 同步主分支
    cmd:
      - git checkout master
      - git fetch upstream
      - git merge upstream/master
    opt: "git push origin master 推送到 fork"

  - id: merge_to_dev
    desc: master 合并到 dev
    cmd:
      - git checkout dev
      - git merge master
    on_conflict: "解决后 add + commit + push"
```

---

## 6. 元数据说明（给 AI）

- **ver**：解析时若 ver 大于当前支持版本，可回退到兼容逻辑或报错。
- **lang**：决定是否做翻译、是否用中文/英文提示。
- **scope**：决定文档被检索/注入的场景（如 repo=仓库说明，api=接口，config=配置项，guide=操作指南）。
- **updated**：用于缓存失效或「是否过期」判断。

---

## 7. 与 Markdown 混用

- 大段说明、步骤说明可用 Markdown 标题 + 列表。
- 结构化数据用 YAML 块（用 ` ```yaml ` 包裹）。
- 同一文件内：frontmatter 元数据 → 简短标题 → 以 YAML 为主、Markdown 为辅。

文档末尾可保留「本规范版本」「修订记录」等一行式信息，便于 AI 识别格式版本。
