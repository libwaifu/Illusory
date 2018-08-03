# Functions

TextArt 模块

- 模块可单独加载

```haskell
$head="https://raw.githubusercontent.com/GalAster/Illusory/master/Packages/Module/";
Import[$head<>"TextArt.wl"];
```

## TextifyChars

### 参数说明

::: tip `TextifyChars[lang]`
- lang 类型为 `String`, 表示所使用的字母表, 等价于使用 `Alphabet`.
:::


::: tip `TextifyChars[chars]`
- chars 类型为 `List`, 表示需要渲染的字符列表.
:::


### 可选项

- FontFamily -> "Source Sans Pro"
	- 字体
- FontSize -> 12
	- 字号, 最好不要超过渲染大小的一半
- RasterSize -> 50
	- 渲染大小, 越大计算遮盖度越精确.
- ClearAll -> False
	- 是否清除字体渲染缓存
	- 一般来说字体字号字符不同都会产生缓存, 低于上千时无需清除.

### 返回值

`Association`, 包含下一步 Textify 所需的各种信息.


默认情况下渲染每个字符需要 75-90 毫秒, 但是只有第一遍需要渲染.



### 标准示例

**测试代码:**
```haskell
Import[]
```

**测试输出:**


## Textify
