# Functions

Stereogram 模块是一个可以合成和解码**自动立体图**的程序包.

- 模块可单独加载

```haskell
Import["https://raw.githubusercontent.com/GalAster/Illusory/master/Packages/Module/Stereogram.wl"];
```

## StereogramEncode

- `StereogramEncode[bgi, depth, maxshift:24]`

### 参数说明

- bgi 类型为 `Image`, 表示背景图片模式
- depth 类型为 `Image`, 表示需要编码的深度图
- maxshift 类型为 `Real`, 表示最大视差位移

### 返回值

三维立体图



## StereogramDecode

- `StereogramDecode[img,shift]`

### 参数说明

- img 类型为 `Image`, 表示需要解码的立体图
- shift 类型为 `Real`, 表示视差位移

### 返回值

立体图内所隐藏物体的深度图, 类型为 `Image`.

### 标准示例

**测试代码:**
```haskell
img=URLExecute["https://view.moezx.cc/images/2018/08/02/093536p97booyf7i2bni88.jpg"];
Row[{img,StereogramDecode[img,shift=Last@ImageDimensions[img]/6]}]
```

**测试输出:**

![StereogramDecode_Output.png](https://i.loli.net/2018/08/02/5b6253ee8df11.png)

视差位移和图片中的重复模式有关, 一般重复几次就是图片宽度除几.

可以看到重校准以后显影出来是两只蟋蟀.
