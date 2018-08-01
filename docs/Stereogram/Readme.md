# Functions

Stereogram 模块是一个可以合成和解码**自动立体图**的程序包.

- 可单独加载

```haskell
Import[]
```

## StereogramEncode



## StereogramDecode

### `StereogramDecode[img,shift]`

#### 参数说明

- img 类型为 `Image`, 表示需要解码的立体图
- shift 类型为 `Integer`, 表示视差位移

#### 返回值

立体图内所隐藏物体的深度图, 类型为 `Image`.

#### 标准示例

测试图片, 被标记为 img.

测试代码:
```haskell
StereogramDecode[img,shift]
```

#### 巧妙范例




