// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Localized {
  /// Plural format key: "%#@fooMultipleStringValue@"
  public static func fooMultipleStringValue(_ p1: Int) -> String {
    return Localized.tr("Localizable", "FooMultipleStringValue", p1, fallback: "Plural format key: \"%#@fooMultipleStringValue@\"")
  }
  public enum Common {
    /// Localizable.strings
    ///   PomodoroApp
    /// 
    ///   Created by Петр Тартынских  on 30.01.2024.
    public static let foo = Localized.tr("Localizable", "common.foo", fallback: "Фуу")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Localized {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
