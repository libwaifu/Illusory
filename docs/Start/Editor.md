# Editor

## 文档编写指南 v0.1

网页文档使用 Vuepress 编写.

注意使用 UTF-8 作为字符编码, CRLF 作为换行符.

使用 Markdown 语法编写文档, SM.MS 作为图床.

暂时 Haskell 模式作为代码高亮.

## 工作流程

### Fork



### Edit




#### New Page
如果要创建新的页面, 那么除了需要创建文件夹与 Readme 文件以外, 还要修改config.

一般新文件夹的命名与源函数包的名称相同, 且必须要有一个 `Readme.md` 文件作为入口

```yaml
Start
  Readme.md
  Developer.md
  Editor.md
```

Readme 以 `# Functions` 开头, 其他样式仿照现有文件即可, 你觉得有更美观的写法自创也行.

一般要求包含**输入值**, **返回值**, 以及**可选项**.

同时修改 `.vuepress/config.js` 中的 `sidebar` 字段:

```JavaScript
{
	title: '简介',
	children: [
		'/Start/',
		'/Start/Developer.md',
		'/Start/Editor.md'
	]
}
```

`title` 是实际显示的标题.

### Push
