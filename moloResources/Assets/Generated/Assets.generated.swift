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
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Assets {
  public enum Icons {
    public enum Account {
      public static let box = ImageAsset(name: "Account/Box")
      public static let checkmark = ImageAsset(name: "Account/Checkmark")
      public static let confirmation = ImageAsset(name: "Account/Confirmation")
    }
    public enum Button {
      public static let arrow = ImageAsset(name: "Button/Arrow")
      public static let arrowBack = ImageAsset(name: "Button/ArrowBack")
      public static let close = ImageAsset(name: "Button/Close")
      public static let search = ImageAsset(name: "Button/Search")
      public static let locate = ImageAsset(name: "Button/locate")
    }
    public enum Event {
      public static let calendar = ImageAsset(name: "Event/Calendar")
      public static let pin = ImageAsset(name: "Event/Pin")
      public static let ticket = ImageAsset(name: "Event/Ticket")
      public static let segmentedCalendar = ImageAsset(name: "Event/segmented_calendar")
      public static let segmentedToday = ImageAsset(name: "Event/segmented_today")
      public static let segmentedTomorrow = ImageAsset(name: "Event/segmented_tomorrow")
      public static let segmentedWeekend = ImageAsset(name: "Event/segmented_weekend")
    }
    public enum Fab {
      public static let vector = ImageAsset(name: "FAB/Vector")
    }
    public enum Feed {
      public static let ellipsis = ImageAsset(name: "Feed/Ellipsis")
      public static let watch = ImageAsset(name: "Feed/Watch")
    }
    public enum Filter {
      public static let community = ImageAsset(name: "Filter/Community")
      public static let news = ImageAsset(name: "Filter/News")
      public static let official = ImageAsset(name: "Filter/Official")
    }
    public enum Navigation {
      public static let back = ImageAsset(name: "Navigation/Back")
      public static let bookmark = ImageAsset(name: "Navigation/Bookmark")
      public static let bookmarked = ImageAsset(name: "Navigation/Bookmarked")
      public static let edit = ImageAsset(name: "Navigation/Edit")
      public static let location = ImageAsset(name: "Navigation/Location")
      public static let logo = ImageAsset(name: "Navigation/Logo")
      public static let more = ImageAsset(name: "Navigation/More")
      public static let profile = ImageAsset(name: "Navigation/Profile")
      public static let search = ImageAsset(name: "Navigation/Search")
      public static let share = ImageAsset(name: "Navigation/Share")
      public static let topics = ImageAsset(name: "Navigation/Topics")
    }
    public enum Organization {
      public static let community = ImageAsset(name: "Organization/Community")
      public static let news = ImageAsset(name: "Organization/News")
      public static let official = ImageAsset(name: "Organization/Official")
    }
    public enum Participate {
      public static let imprint = ImageAsset(name: "Participate/Imprint")
      public static let posts = ImageAsset(name: "Participate/Posts")
      public static let preferences = ImageAsset(name: "Participate/Preferences")
      public static let feedback = ImageAsset(name: "Participate/feedback")
      public static let info = ImageAsset(name: "Participate/info")
      public static let privacy = ImageAsset(name: "Participate/privacy")
      public static let profile = ImageAsset(name: "Participate/profile")
      public static let sources = ImageAsset(name: "Participate/sources")
    }
    public enum Posting {
      public static let address = ImageAsset(name: "Posting/Address")
      public static let arrow = ImageAsset(name: "Posting/Arrow")
      public static let arrowBack = ImageAsset(name: "Posting/ArrowBack")
      public static let close = ImageAsset(name: "Posting/Close")
      public static let date = ImageAsset(name: "Posting/Date")
      public static let draft = ImageAsset(name: "Posting/Draft")
      public static let imageEdit = ImageAsset(name: "Posting/ImageEdit")
      public static let imagePlaceholder = ImageAsset(name: "Posting/ImagePlaceholder")
      public static let link = ImageAsset(name: "Posting/Link")
      public static let ticketLink = ImageAsset(name: "Posting/TicketLink")
      public static let venue = ImageAsset(name: "Posting/Venue")
    }
    public enum SegmentedControl {
      public static let bookmarkedArticles = ImageAsset(name: "SegmentedControl/BookmarkedArticles")
      public static let bookmarkedEvents = ImageAsset(name: "SegmentedControl/BookmarkedEvents")
    }
    public enum Sources {
      public static let arrowClosed = ImageAsset(name: "Sources/ArrowClosed")
      public static let arrowOpened = ImageAsset(name: "Sources/ArrowOpened")
    }
    public enum Tabbar {
      public static let events = ImageAsset(name: "Tabbar/Events")
      public static let explore = ImageAsset(name: "Tabbar/Explore")
      public static let feed = ImageAsset(name: "Tabbar/Feed")
      public static let participate = ImageAsset(name: "Tabbar/Participate")
      public static let watchlist = ImageAsset(name: "Tabbar/Watchlist")
    }
  }
  public enum Images {
    public enum Onboarding {
      public static let headshot1 = ImageAsset(name: "Onboarding/headshot1")
      public static let headshot2 = ImageAsset(name: "Onboarding/headshot2")
      public static let headshot3 = ImageAsset(name: "Onboarding/headshot3")
      public static let headshot4 = ImageAsset(name: "Onboarding/headshot4")
      public static let page1 = ImageAsset(name: "Onboarding/page1")
      public static let page2 = ImageAsset(name: "Onboarding/page2")
      public static let page3 = ImageAsset(name: "Onboarding/page3")
      public static let page4 = ImageAsset(name: "Onboarding/page4")
    }
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  public var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  public func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

public extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
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
