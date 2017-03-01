# CheckVersion

[![LICENSE](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/AYJk/AYPageControl/blob/master/License)&nbsp;
[![SUPPORT](https://img.shields.io/badge/support-iOS8-blue.svg)](https://en.wikipedia.org/wiki/IOS_8)&nbsp;
![CocoaPods Version](https://img.shields.io/badge/pod-v1.2.0-brightgreen.svg)

# 要求
Swift 3.0 , iOS 8.0+

# 介绍
1. 简单地调用一个方法，即可检测APP的新版本特性的提示。
2. 默认使用系统的弹框，也支持自定义的弹框。

# 安装

### 手动添加
* 将 CheckVersion 文件夹拖入到你的工程目录中

### CocoaPods安装
* 推荐使用[CocoaPods](http://cocoapods.org/)进行安装。`pod install` or `pod update`。将会安装最新版本的CheckVersion。


# 用法

使用默认弹框进行版本的检测提示。

```swift
let checkMgr = CheckVersionMgr.shareInstance
checkMgr.checkVersionWithSystemAlert()
```

如果要使用自定义的提示框，可在以下方法的block中自定义。

```swift
let checkMgr = CheckVersionMgr.shareInstance
checkMgr.checkVersionWithCustomView { (model) in
    //code
}
```

不再提示APP版本的更新提示。

```swift

```

默认从APP跳转出去到AppStore进行更新，也支持在APP应用内打开更新页面，请设置`openTrackUrlInAppStore`，

```swift
let checkMgr = CheckVersionMgr.shareInstance
checkMgr.openTrackUrlInAppStore = false
```


# 许可证

使用 MIT 许可证，详情见 LICENSE 文件。	


