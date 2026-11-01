// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Colors {
  public enum Android {
    public static let background = ColorAsset(name: "Android/background")
    public static let error = ColorAsset(name: "Android/error")
    public static let errorContainer = ColorAsset(name: "Android/errorContainer")
    public static let inverseOnSurface = ColorAsset(name: "Android/inverseOnSurface")
    public static let inversePrimary = ColorAsset(name: "Android/inversePrimary")
    public static let inverseSurface = ColorAsset(name: "Android/inverseSurface")
    public static let onBackground = ColorAsset(name: "Android/onBackground")
    public static let onError = ColorAsset(name: "Android/onError")
    public static let onErrorContainer = ColorAsset(name: "Android/onErrorContainer")
    public static let onPrimary = ColorAsset(name: "Android/onPrimary")
    public static let onPrimaryContainer = ColorAsset(name: "Android/onPrimaryContainer")
    public static let onSecondary = ColorAsset(name: "Android/onSecondary")
    public static let onSecondaryContainer = ColorAsset(name: "Android/onSecondaryContainer")
    public static let onSurface = ColorAsset(name: "Android/onSurface")
    public static let onSurfaceVariant = ColorAsset(name: "Android/onSurfaceVariant")
    public static let onTertiary = ColorAsset(name: "Android/onTertiary")
    public static let onTertiaryContainer = ColorAsset(name: "Android/onTertiaryContainer")
    public static let outline = ColorAsset(name: "Android/outline")
    public static let outlineVariant = ColorAsset(name: "Android/outlineVariant")
    public static let primary = ColorAsset(name: "Android/primary")
    public static let primaryContainer = ColorAsset(name: "Android/primaryContainer")
    public static let scrim = ColorAsset(name: "Android/scrim")
    public static let secondary = ColorAsset(name: "Android/secondary")
    public static let surface = ColorAsset(name: "Android/surface")
    public static let surfaceBright = ColorAsset(name: "Android/surfaceBright")
    public static let surfaceContainer = ColorAsset(name: "Android/surfaceContainer")
    public static let surfaceContainerHigh = ColorAsset(name: "Android/surfaceContainerHigh")
    public static let surfaceContainerHighest = ColorAsset(name: "Android/surfaceContainerHighest")
    public static let surfaceContainerLowest = ColorAsset(name: "Android/surfaceContainerLowest")
    public static let surfaceDim = ColorAsset(name: "Android/surfaceDim")
    public static let surfaceVariant = ColorAsset(name: "Android/surfaceVariant")
    public static let tertiary = ColorAsset(name: "Android/tertiary")
    public static let tertiaryContainer = ColorAsset(name: "Android/tertiaryContainer")
  }
  public enum Background {
    public static let app = ColorAsset(name: "Background/App")
    public static let `default` = ColorAsset(name: "Background/Default")
    public static let draftCard = ColorAsset(name: "Background/DraftCard")
    public static let eventOrganization = ColorAsset(name: "Background/EventOrganization")
    public static let filter = ColorAsset(name: "Background/Filter")
    public static let filterSelected = ColorAsset(name: "Background/FilterSelected")
    public static let input = ColorAsset(name: "Background/Input")
    public static let inputForm = ColorAsset(name: "Background/InputForm")
    public static let inputPosting = ColorAsset(name: "Background/InputPosting")
    public static let inputProfile = ColorAsset(name: "Background/InputProfile")
    public static let mapInputs = ColorAsset(name: "Background/MapInputs")
    public static let menuItem = ColorAsset(name: "Background/MenuItem")
    public static let newsCard = ColorAsset(name: "Background/NewsCard")
    public static let postingImage = ColorAsset(name: "Background/PostingImage")
    public static let primary = ColorAsset(name: "Background/Primary")
    public static let searchbar = ColorAsset(name: "Background/Searchbar")
    public static let sourcesCard = ColorAsset(name: "Background/SourcesCard")
    public static let tabbar = ColorAsset(name: "Background/Tabbar")
    public static let toast = ColorAsset(name: "Background/Toast")
    public static let toolbarItem = ColorAsset(name: "Background/ToolbarItem")
    public static let topNavigation = ColorAsset(name: "Background/TopNavigation")
    public static let topics = ColorAsset(name: "Background/Topics")
    public static let topicsSelected = ColorAsset(name: "Background/TopicsSelected")
  }
  public enum Border {
    public static let topics = ColorAsset(name: "Border/Topics")
    public static let topicsSelected = ColorAsset(name: "Border/TopicsSelected")
  }
  public enum Dimming {
    public static let newsCard = ColorAsset(name: "Dimming/NewsCard")
  }
  public enum Fab {
    public static let background = ColorAsset(name: "Fab/Background")
  }
  public enum Icons {
    public static let button = ColorAsset(name: "Icons/Button")
    public static let eventCard = ColorAsset(name: "Icons/EventCard")
    public static let filter = ColorAsset(name: "Icons/Filter")
    public static let filterSelected = ColorAsset(name: "Icons/FilterSelected")
    public static let navigation = ColorAsset(name: "Icons/Navigation")
    public static let passive = ColorAsset(name: "Icons/Passive")
    public static let postingNavigation = ColorAsset(name: "Icons/PostingNavigation")
    public static let profile = ColorAsset(name: "Icons/Profile")
    public static let segmentedControl = ColorAsset(name: "Icons/SegmentedControl")
    public static let topNavigation = ColorAsset(name: "Icons/TopNavigation")
    public static let ios18TopNavigation = ColorAsset(name: "Icons/iOS18TopNavigation")
  }
  public enum Map {
    public static let locationPin = ColorAsset(name: "Map/LocationPin")
    public static let locationPinBorder = ColorAsset(name: "Map/LocationPinBorder")
    public static let overlay = ColorAsset(name: "Map/Overlay")
  }
  public enum Separator {
    public static let posting = ColorAsset(name: "Separator/Posting")
  }
  public enum Shadow {
    public static let logo = ColorAsset(name: "Shadow/Logo")
    public static let newsCard = ColorAsset(name: "Shadow/NewsCard")
  }
  public enum Text {
    public static let button = ColorAsset(name: "Text/Button")
    public static let `default` = ColorAsset(name: "Text/Default")
    public static let default80 = ColorAsset(name: "Text/Default80")
    public static let error = ColorAsset(name: "Text/Error")
    public static let eventFilter = ColorAsset(name: "Text/EventFilter")
    public static let eventFilterSelected = ColorAsset(name: "Text/EventFilterSelected")
    public static let filter = ColorAsset(name: "Text/Filter")
    public static let filterSelected = ColorAsset(name: "Text/FilterSelected")
    public static let menuItem = ColorAsset(name: "Text/MenuItem")
    public static let onboarding = ColorAsset(name: "Text/Onboarding")
    public static let onboardingAccent = ColorAsset(name: "Text/OnboardingAccent")
    public static let organizationTitle = ColorAsset(name: "Text/OrganizationTitle")
    public static let postingTitle = ColorAsset(name: "Text/PostingTitle")
    public static let searchbar = ColorAsset(name: "Text/Searchbar")
    public static let tabbarSelected = ColorAsset(name: "Text/TabbarSelected")
    public static let toast = ColorAsset(name: "Text/Toast")
    public static let topNavigation = ColorAsset(name: "Text/TopNavigation")
    public static let topics = ColorAsset(name: "Text/Topics")
    public static let topicsSelected = ColorAsset(name: "Text/TopicsSelected")
    public static let ios18TabbarSelected = ColorAsset(name: "Text/iOS18TabbarSelected")
    public static let ios18TabbarUnselected = ColorAsset(name: "Text/iOS18TabbarUnselected")
  }
  public enum Toggle {
    public static let selected = ColorAsset(name: "Toggle/Selected")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  public func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

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
