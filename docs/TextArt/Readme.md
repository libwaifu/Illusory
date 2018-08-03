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

中文有上万字符, 建议手动截取到上千常用字.

### 标准示例

**测试代码:**
```haskell
TextifyChars["Hiragana",FontFamily->"华文楷体"]
```

**测试输出:**

![TextArt_1](https://i.loli.net/2018/08/03/5b644a371a512.png)

## Textify

### 参数说明

::: tip `Textify[img, chars]`
- img 类型为 `Image`, 表示需要转化的图片.
- chars 类型为 `Association`, 表示预渲染的字符信息.
:::

::: tip `Textify[pics, chars]`
- pics 类型为 `List`, 表示需要转化的图片列表, 比如 GIF 动图的分解.
- chars 类型为 `Association`, 表示预渲染的字符信息.
:::

### 可选项

- Colorize -> True
	- 是否染色, False 则是黑白渲染
	- 黑白渲染并不意味着是二值图片
- ColorNegate -> False
	- 是否反色
- Magnify -> 1
	- 放大系数, 是否要放大字体, 可设置为缩小
- Text -> False
	- 是否直接返回字符样式, False 则渲染为图片

### 返回值

`Image`, 默认设置下

`List`, 如果开启 Text -> True

::: danger Tip
chars 由 TextifyChars 函数给出, 必须对字符进行预渲染.
Colorize -> True 非常缓慢, 因为每个字符颜色改变, 需要重新渲染
Text -> True 有可能返回一个缩略形式, 需要手动展开
:::

### 标准示例

**测试代码:**
```haskell
char=TextifyChars[Append[Alphabet["Hiragana"]," "],FontFamily->"华文楷体"];
img=Import["https://view.moezx.cc/images/2018/08/03/d34ecf73c99d66312e7408e6c159feb5485b15b8.md.jpg"];
text=Textify[Binarize[img,0.75],char,Colorize->False,Magnify->0.33,Text->True]
```

**测试输出:**

![TextArt_2](https://i.loli.net/2018/08/03/5b64513a1d089.png)
