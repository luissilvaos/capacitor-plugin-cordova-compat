import Foundation

@objc public class CapacitorBridge: NSObject {
    
    weak var cdvPlugin: CDVPlugin?

    internal static var isDevEnvironment: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    public var webView: WKWebView? {
        return cdvPlugin?.webView as? WKWebView;
    }

    public var isSimEnvironment: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    public var isDevEnvironment: Bool {
        return CapacitorBridge.isDevEnvironment
    }

    public var userInterfaceStyle: UIUserInterfaceStyle {
        return viewController?.traitCollection.userInterfaceStyle ?? .unspecified
    }

    public var statusBarVisible: Bool {
        get {
            return !(viewController?.prefersStatusBarHidden ?? true)
        }
    }

    public var statusBarStyle: UIStatusBarStyle {
        get {
            return viewController?.preferredStatusBarStyle ?? .default
        }
    }

    @objc public var viewController: UIViewController? {
        return cdvPlugin?.viewController
    }

    public func getWebView() -> WKWebView? {
        return webView
    }

    public func isSimulator() -> Bool {
        return isSimEnvironment
    }

    public func isDevMode() -> Bool {
        return isDevEnvironment
    }

    public func getStatusBarVisible() -> Bool {
        return statusBarVisible
    }

    public func getStatusBarStyle() -> UIStatusBarStyle {
        return statusBarStyle
    }

    public func getUserInterfaceStyle() -> UIUserInterfaceStyle {
        return userInterfaceStyle
    }

    init(cdvPlugin: CDVPlugin) {
        self.cdvPlugin = cdvPlugin;
    }

}
