# CheckVersion

[![LICENSE](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/AYJk/AYPageControl/blob/master/License)&nbsp;
[![SUPPORT](https://img.shields.io/badge/support-iOS8-blue.svg)](https://en.wikipedia.org/wiki/IOS_8)&nbsp;
![CocoaPods Version](https://img.shields.io/badge/pod-v1.2.0-brightgreen.svg)

# 要求
Swift 3.0 , iOS 8.0+

# 介绍
1. 简单地调用一个方法，即可检测APP的新版本特性。
2. 默认使用系统的弹框，也支持自定义的弹框。

# 安装

### 手动添加
* 将 CheckVersion 文件夹拖入到你的工程目录中

### CocoaPods安装
* 推荐使用[CocoaPods](http://cocoapods.org/)进行安装。`pod install` or `pod update`。将会安装最新版本的CheckVersion。


# 用法

使用默认属性进行版本的检测。

```swift

```

自定义警示框的标题，下次提示的标题，立即更新的标题。

```swift

```

自定义警示框的标题，下次提示的标题，立即更新的标题，跳过该版本的标题。

```swift

```

如果你想在当前应用中以模态视图的形式打开AppStore，请设置`openAPPStoreInsideAPP`，默认从应用跳转出去到AppStore。

```swift

```


# 许可证

使用 MIT 许可证，详情见 LICENSE 文件。	


