//
//  VersionKit.swift
//  Version
//
//  Created by 李建航 on 2018/7/6.
//  Copyright © 2018 lee. All rights reserved.
//

import Foundation
import RxSwift
import Reachability
import AlamofireObjectMapper
import Alamofire

public class VersionKit {
    
    // MARK: - public
    
    public static let shareInstance = VersionKit()
    
    public static let bundle = Bundle(for: VersionKit.self)
    
    public weak var delegate: VersionKitDelegate?
    
    /// 查看APP介绍页的方式
    public let viewType: Variable<ViewAppType> = Variable(.inApp)
    
    /// APP版本检测间隔
    public let detectType: Variable<DetectType> = Variable(.immediate)
    
    // MARK: - private
    
    /// 上次检查时间
    private let lastDetectTime: Variable<String?> = Variable(UserDefaults.standard.string(forKey: Constant.lastDetectTimeKey))
    
    /// 跳过检测的版本
    private let skipDetectVersion: Variable<String?> = Variable(UserDefaults.standard.string(forKey: Constant.skipDetectVersionKey))
    
    private let reachability = Reachability()
    
    private let info: Variable<AppInfoResults?> = Variable(nil)
    
    private let disposeBag = DisposeBag()
    
    private init() {
        
        Observable.just(())
            .delay(5.0, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                self.startReachability()
            })
            .disposed(by: self.disposeBag)
        
        self.info.asObservable()
            .subscribe(onNext: { [unowned self] info in
                if let localVersion = Tools.getLocalVersion(),
                    let itunesVersion = info?.version,
                    Tools.compareVersion(localVersion, itunesVersion) {
                    print("itunesVersion >> localVersion")
                }
            })
            .disposed(by: self.disposeBag)
        
    }
    
    deinit {
        self.reachability?.stopNotifier()
    }
    
    // MARK: - network
    
    private func startReachability() {
        self.reachability?.whenReachable = { [weak self] _ in
            self?.requestIfNeeded()
        }
        try? self.reachability?.startNotifier()
    }
    
    private func requestIfNeeded() {
        self.appInfoService()
    }
    
    private func appInfoService() {
        if let URL = self.urlForBundleID() {
            Alamofire.request(URL).responseObject { [unowned self] (response: DataResponse<AppInfoResponse>) in
                let infoResponse = response.result.value
                if infoResponse?.resultCount == 1, let resluts = infoResponse?.results {
                    self.info.value = resluts.first
                }
            }
        }
    }
    
    /// 是否弹出更新提示
    func isShowUpdatePrompt() {
        
    }
    
    
}

// MARK: - actions

extension VersionKit {
    func urlForBundleID() -> URL? {
        if let bundleID = self.delegate?.versionKitWithBundleID() {
            return URL(string: Constant.itunesURL + bundleID)
        }
        return nil
    }
}

// MARK: - VersionKitDelegate

public protocol VersionKitDelegate: class {
    /// 需要查询更新的bundleID
    ///
    /// - Returns: String
    func versionKitWithBundleID() -> String?
    
}



// MARK: - Constant

private struct Constant {
    /// itunes地址
    static let itunesURL = "http://itunes.apple.com/lookup?bundleId="
    /// 上一次检查的时间
    static let lastDetectTimeKey = "Version.LastDetectTime"
    /// 跳过检测的版本
    static let skipDetectVersionKey = "Version.SkipDetectVersion"
}
