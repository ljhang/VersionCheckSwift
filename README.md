# CheckVersion

[![LICENSE](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/AYJk/AYPageControl/blob/master/License)&nbsp;
[![SUPPORT](https://img.shields.io/badge/support-iOS8-blue.svg)](https://en.wikipedia.org/wiki/IOS_8)&nbsp;
![CocoaPods Version](https://img.shields.io/badge/pod-v1.2.0-brightgreen.svg)

# 起始

首先，这个`版本更新检查库`借鉴了开源项目－[XHVersion](https://github.com/CoderZhuXH/XHVersion)以及[AYCheckVersion](https://github.com/AYJk/AYCheckVersion)，使用Objective-C的同学可以移步他们处看看。

后来发现，这种`版本更新检查功能`类型的开源库在Github已经早有了，请看国外大神[ArtSabintsev](https://github.com/ArtSabintsev)写的Swift版本[Siren](https://github.com/ArtSabintsev/Siren)和OC版本[Harpy](https://github.com/ArtSabintsev/Harpy)。

最后，是发布到CocoaPods上面。之前没试过，也没什么经验，按照网上一些人的经验一步步的来，也踩过一些坑，还好是走过去了。也是挺不错的一次增长能力的机会。


# 要求
Swift 3.0 , iOS 8.0+

# 介绍
1. 简单地调用一个方法，即可检测APP的新版本特性，当有App更新时的弹出提示框。开发者也可以根据获取的检测信息，自己提供自定义的提示框去通知用户。
2. 默认使用系统的弹框，也支持自定义的弹框。
3. 可设置选择进行更新时的界面。
4. 可设置检测的时间间隔，减少网络频繁请求弹框，带给用户不好的体验。

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


默认从APP跳转出去到AppStore进行更新，也支持在APP应用内打开更新页面，请设置`openTrackUrlInAppStore`，

```swift
let checkMgr = CheckVersionMgr.shareInstance
checkMgr.openTrackUrlInAppStore = false
```

设置更新检查的时间间隔

```swift
let checkMgr = CheckVersionMgr.shareInstance    
checkMgr.CheckAgainInterval = 60*24
```

# 附上源码地址
GitHub链接：[VersionCheckSwift](https://github.com/ljhang/VersionCheckSwift)
喜欢或者觉得有帮助的童鞋，可以给点个Star咯，谢谢

# 许可证

使用 MIT 许可证，详情见 LICENSE 文件。	


