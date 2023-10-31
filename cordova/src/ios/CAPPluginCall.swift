import Foundation

public typealias PluginCallErrorData = [String:Any]
public typealias PluginResultData = [String:Any]
typealias CAPPluginCallSuccessHandler = (CAPPluginCallResult?, CAPPluginCall?) -> Void
typealias CAPPluginCallErrorHandler = (CAPPluginCallError?) -> Void

@objc class CAPPluginCallResult: NSObject {
    var data: [String : Any?]?

    init(_ data: [String : Any?]? = nil) {
        self.data = data
    }
}

@objc class CAPPluginCallError: NSObject {
    var message: String?
    var error: Error?
    var data: [String : Any?]?

    init(message: String?, error: Error?, data: [String : Any?]?) {
        self.message = message
        self.error = error
        self.data = data
    }
}

@objc class CAPPluginCall: NSObject {
    private static let UNIMPLEMENTED = "not implemented"
    
    var isSaved = false
    var callbackId: String?
    var options: [AnyHashable : Any]
    var successHandler: CAPPluginCallSuccessHandler
    var errorHandler: CAPPluginCallErrorHandler
    
    init(callbackId: String? = nil, options: [AnyHashable : Any] = [AnyHashable : Any](), success: @escaping CAPPluginCallSuccessHandler, error: @escaping CAPPluginCallErrorHandler) {
        self.callbackId = callbackId
        self.options = options
        self.successHandler = success
        self.errorHandler = error
    }

    func save() {
        isSaved = true
    }
    
    func get<T>(_ key: String, _ ofType: T.Type) -> T? {
      return self.options[key] as? T
    }

    func get<T>(_ key: String, _ ofType: T.Type, _ defaultValue: T) -> T {
      return self.get(key, ofType) ?? defaultValue
    }
    
    func getArray<T>(_ key: String, _ ofType: T.Type) -> [T]? {
      return self.options[key] as? [T]
    }
    
    func getArray<T>(_ key: String, _ ofType: T.Type, _ defaultValue: [T]) -> [T] {
      return self.getArray(key, ofType) ?? defaultValue
    }
    
    func getBool(_ key: String) -> Bool? {
      return self.options[key] as? Bool
    }
    
    func getBool(_ key: String, _ defaultValue: Bool) -> Bool {
      return self.getBool(key) ?? defaultValue
    }
    
    func getInt(_ key: String) -> Int? {
      return self.options[key] as? Int
    }
    
    func getInt(_ key: String, _ defaultValue: Int) -> Int {
      return self.getInt(key) ?? defaultValue
    }
    
    func getFloat(_ key: String) -> Float? {
      return self.options[key] as? Float
    }
    
    func getFloat(_ key: String, _ defaultValue: Float) -> Float {
        return self.getFloat(key) ?? defaultValue
    }
    
    func getDouble(_ key: String) -> Double? {
      return self.options[key] as? Double
    }
    
    func getDouble(_ key: String, _ defaultValue: Double) -> Double {
      return self.getDouble(key) ?? defaultValue
    }
    
    func getString(_ key: String) -> String? {
      return self.options[key] as? String
    }
    
    func getString(_ key: String, _ defaultValue: String) -> String {
      return self.getString(key) ?? defaultValue
    }
    
    func getDate(_ key: String, _ defaultValue: Date? = nil) -> Date? {
      guard let isoString = self.options[key] as? String else {
        return defaultValue
      }
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      dateFormatter.timeZone = TimeZone.autoupdatingCurrent
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      return dateFormatter.date(from: isoString)
    }
    
    func getObject(_ key: String) -> JSObject? {
      let obj = self.options[key] as? [String:Any]
      return obj != nil ? toJSObject(obj!) : nil
    }
    
    func getObject(_ key: String, defaultValue: JSObject) -> JSObject {
      return self.getObject(key) ?? defaultValue
    }
    
    func hasOption(_ key: String) -> Bool {
      return self.options.index(forKey: key) != nil
    }

    func success() {
      successHandler(CAPPluginCallResult(), self)
    }
    
    func success(_ data: PluginResultData = [:]) {
      successHandler(CAPPluginCallResult(data), self)
    }
    
    func resolve() {
      successHandler(CAPPluginCallResult(), self)
    }
    
    func resolve(_ data: PluginResultData = [:]) {
      successHandler(CAPPluginCallResult(data), self)
    }
    
    func error(_ message: String, _ error: Error? = nil, _ data: PluginCallErrorData = [:]) {
      errorHandler(CAPPluginCallError(message: message, error: error, data: data))
    }
    
    func reject(_ message: String, _ error: Error? = nil, _ data: PluginCallErrorData = [:]) {
      errorHandler(CAPPluginCallError(message: message, error: error, data: data))
    }

    func unimplemented() {
      errorHandler(CAPPluginCallError(message: CAPPluginCall.UNIMPLEMENTED, error: nil, data: [:]))
    }

    private func toJSObject(_ src: [String: Any]) -> JSObject {
      var obj = JSObject()
      src.keys.forEach { key in
        obj[key] = coerceToJSValue(src[key], formattingDates: false)
      }
      return obj
    }
}
