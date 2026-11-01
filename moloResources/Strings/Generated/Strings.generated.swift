// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum News {
    public enum Molo {
      public enum Account {
        public enum Delete {
          public enum Alert {
            /// Abbrechen
            public static let cancel = L10n.tr("Localizable", "news.molo.account.delete.alert.cancel", fallback: "Abbrechen")
            /// Wenn du deinen Account löschst, werden alle von dir erstellten Inhalte gelöscht.
            public static let message = L10n.tr("Localizable", "news.molo.account.delete.alert.message", fallback: "Wenn du deinen Account löschst, werden alle von dir erstellten Inhalte gelöscht.")
            /// Löschen
            public static let ok = L10n.tr("Localizable", "news.molo.account.delete.alert.ok", fallback: "Löschen")
            /// Account löschen?
            public static let title = L10n.tr("Localizable", "news.molo.account.delete.alert.title", fallback: "Account löschen?")
          }
        }
      }
      public enum Button {
        /// Account löschen
        public static let deleteAccount = L10n.tr("Localizable", "news.molo.button.deleteAccount", fallback: "Account löschen")
        /// Anmelden / Registieren
        public static let login = L10n.tr("Localizable", "news.molo.button.login", fallback: "Anmelden / Registieren")
        /// Abmelden
        public static let logout = L10n.tr("Localizable", "news.molo.button.logout", fallback: "Abmelden")
      }
      public enum Email {
        /// Welches Feedback zur App oder Infos und Neuigkeiten möchtest du molo melden?
        /// 
        /// Deine Nachricht:
        public static let content = L10n.tr("Localizable", "news.molo.email.content", fallback: "Welches Feedback zur App oder Infos und Neuigkeiten möchtest du molo melden?\n\nDeine Nachricht:")
        /// Feedback
        public static let subject = L10n.tr("Localizable", "news.molo.email.subject", fallback: "Feedback")
        /// molonews@uni-bremen.de
        public static let to = L10n.tr("Localizable", "news.molo.email.to", fallback: "molonews@uni-bremen.de")
      }
      public enum Event {
        /// In Kalender importieren
        public static let save = L10n.tr("Localizable", "news.molo.event.save", fallback: "In Kalender importieren")
        public enum Calendar {
          /// Abbrechen
          public static let cancel = L10n.tr("Localizable", "news.molo.event.calendar.cancel", fallback: "Abbrechen")
          /// Ende
          public static let end = L10n.tr("Localizable", "news.molo.event.calendar.end", fallback: "Ende")
          /// Enddatum
          public static let endDate = L10n.tr("Localizable", "news.molo.event.calendar.endDate", fallback: "Enddatum")
          /// Ok
          public static let ok = L10n.tr("Localizable", "news.molo.event.calendar.ok", fallback: "Ok")
          /// Wähle einen Zeitraum
          public static let select = L10n.tr("Localizable", "news.molo.event.calendar.select", fallback: "Wähle einen Zeitraum")
          /// Gewählter Zeitraum:
          public static let selectedSpan = L10n.tr("Localizable", "news.molo.event.calendar.selectedSpan", fallback: "Gewählter Zeitraum:")
          /// Start
          public static let start = L10n.tr("Localizable", "news.molo.event.calendar.start", fallback: "Start")
          /// Startdatum
          public static let startDate = L10n.tr("Localizable", "news.molo.event.calendar.startDate", fallback: "Startdatum")
        }
        public enum Category {
          /// Keine Events für deine Auswahl
          public static let empty = L10n.tr("Localizable", "news.molo.event.category.empty", fallback: "Keine Events für deine Auswahl")
        }
        public enum Detail {
          /// Location & Themen
          public static let subheader = L10n.tr("Localizable", "news.molo.event.detail.subheader", fallback: "Location & Themen")
          /// Tickets kaufen
          public static let tickets = L10n.tr("Localizable", "news.molo.event.detail.tickets", fallback: "Tickets kaufen")
          /// Zur Event-Website
          public static let website = L10n.tr("Localizable", "news.molo.event.detail.website", fallback: "Zur Event-Website")
        }
        public enum Filter {
          /// Kalender
          public static let calendar = L10n.tr("Localizable", "news.molo.event.filter.calendar", fallback: "Kalender")
          /// Heute
          public static let today = L10n.tr("Localizable", "news.molo.event.filter.today", fallback: "Heute")
          /// Morgen
          public static let tomorrow = L10n.tr("Localizable", "news.molo.event.filter.tomorrow", fallback: "Morgen")
          /// Wochenende
          public static let weekend = L10n.tr("Localizable", "news.molo.event.filter.weekend", fallback: "Wochenende")
        }
      }
      public enum Events {
        public enum Time {
          ///  Uhr
          public static let appendix = L10n.tr("Localizable", "news.molo.events.time.appendix", fallback: " Uhr")
        }
      }
      public enum Loading {
        /// Lade...
        public static let progress = L10n.tr("Localizable", "news.molo.loading.progress", fallback: "Lade...")
      }
      public enum Location {
        /// km
        public static let km = L10n.tr("Localizable", "news.molo.location.km", fallback: "km")
        /// Umkreis
        public static let radius = L10n.tr("Localizable", "news.molo.location.radius", fallback: "Umkreis")
        /// Auswählen
        public static let submit = L10n.tr("Localizable", "news.molo.location.submit", fallback: "Auswählen")
      }
      public enum Login {
        public enum Button {
          /// Passwort vergessen?
          public static let passwordLost = L10n.tr("Localizable", "news.molo.login.button.passwordLost", fallback: "Passwort vergessen?")
          /// Konto erstellen
          public static let register = L10n.tr("Localizable", "news.molo.login.button.register", fallback: "Konto erstellen")
          /// Anmelden
          public static let submit = L10n.tr("Localizable", "news.molo.login.button.submit", fallback: "Anmelden")
        }
        public enum Input {
          /// E-Mail
          public static let email = L10n.tr("Localizable", "news.molo.login.input.email", fallback: "E-Mail")
          /// Passwort
          public static let password = L10n.tr("Localizable", "news.molo.login.input.password", fallback: "Passwort")
        }
        public enum Text {
          /// Du möchtest selbst lokale Infos und Events bei molo veröffentlichen? Dann melde dich an und poste direkt über die App.
          public static let description = L10n.tr("Localizable", "news.molo.login.text.description", fallback: "Du möchtest selbst lokale Infos und Events bei molo veröffentlichen? Dann melde dich an und poste direkt über die App.")
          /// Anmelden
          public static let title = L10n.tr("Localizable", "news.molo.login.text.title", fallback: "Anmelden")
        }
      }
      public enum Menu {
        /// Dunkles Design
        public static let darkMode = L10n.tr("Localizable", "news.molo.menu.darkMode", fallback: "Dunkles Design")
        /// Feedback und Kontakt
        public static let feedback = L10n.tr("Localizable", "news.molo.menu.feedback", fallback: "Feedback und Kontakt")
        /// Impressum
        public static let imprint = L10n.tr("Localizable", "news.molo.menu.imprint", fallback: "Impressum")
        /// Über molo.news
        public static let info = L10n.tr("Localizable", "news.molo.menu.info", fallback: "Über molo.news")
        /// Datenschutzerklärung
        public static let privacy = L10n.tr("Localizable", "news.molo.menu.privacy", fallback: "Datenschutzerklärung")
        /// Meine Quellen
        public static let sources = L10n.tr("Localizable", "news.molo.menu.sources", fallback: "Meine Quellen")
        /// Nutzungsbedingungen
        public static let terms = L10n.tr("Localizable", "news.molo.menu.terms", fallback: "Nutzungsbedingungen")
      }
      public enum Notification {
        public enum Article {
          /// Artikel wurde gemeldet
          public static let reported = L10n.tr("Localizable", "news.molo.notification.article.reported", fallback: "Artikel wurde gemeldet")
        }
        public enum Event {
          /// Der Zugriff auf den Kalendar muss erlaubt werden.
          public static let noAccess = L10n.tr("Localizable", "news.molo.notification.event.noAccess", fallback: "Der Zugriff auf den Kalendar muss erlaubt werden.")
          /// Event wurde gemeldet
          public static let reported = L10n.tr("Localizable", "news.molo.notification.event.reported", fallback: "Event wurde gemeldet")
        }
        public enum General {
          /// Fehler bei der Datenübermittlung
          public static let error = L10n.tr("Localizable", "news.molo.notification.general.error", fallback: "Fehler bei der Datenübermittlung")
        }
        public enum Location {
          /// Ort konnte nicht abgerufen werden
          public static let notFound = L10n.tr("Localizable", "news.molo.notification.location.notFound", fallback: "Ort konnte nicht abgerufen werden")
        }
        public enum Login {
          /// Du bist jetzt eingeloggt.
          public static let success = L10n.tr("Localizable", "news.molo.notification.login.success", fallback: "Du bist jetzt eingeloggt.")
        }
        public enum Profile {
          /// Profil konnte nicht geladen werden.
          public static let error = L10n.tr("Localizable", "news.molo.notification.profile.error", fallback: "Profil konnte nicht geladen werden.")
        }
        public enum Push {
          /// Push konnte nicht aktiviert werden.
          public static let error = L10n.tr("Localizable", "news.molo.notification.push.error", fallback: "Push konnte nicht aktiviert werden.")
        }
      }
      public enum Onboarding {
        public enum Step1 {
          /// Infos zum Leben vor deiner Haustür gehen zwischen den Posts aus aller Welt oft unter.
          /// Schade eigentlich. molo rückt die Themen deines Ortes wieder in den Mittelpunkt.
          public static let description = L10n.tr("Localizable", "news.molo.onboarding.step1.description", fallback: "Infos zum Leben vor deiner Haustür gehen zwischen den Posts aus aller Welt oft unter.\nSchade eigentlich. molo rückt die Themen deines Ortes wieder in den Mittelpunkt.")
          /// Weiter
          public static let next = L10n.tr("Localizable", "news.molo.onboarding.step1.next", fallback: "Weiter")
          /// Dein Ort,
          /// 
          public static let title1 = L10n.tr("Localizable", "news.molo.onboarding.step1.title1", fallback: "Dein Ort,\n")
          /// deine Themen.
          public static let title2 = L10n.tr("Localizable", "news.molo.onboarding.step1.title2", fallback: "deine Themen.")
        }
        public enum Step2 {
          /// Bestimme einen Ort oder teile deinen Standort, um lokale Meldungen zu erhalten und Veranstaltungen zu finden. Unabhängig, werbefrei und aktuell.
          public static let description = L10n.tr("Localizable", "news.molo.onboarding.step2.description", fallback: "Bestimme einen Ort oder teile deinen Standort, um lokale Meldungen zu erhalten und Veranstaltungen zu finden. Unabhängig, werbefrei und aktuell.")
          /// Ort wählen
          public static let next = L10n.tr("Localizable", "news.molo.onboarding.step2.next", fallback: "Ort wählen")
          /// Du setzt
          /// 
          public static let title1 = L10n.tr("Localizable", "news.molo.onboarding.step2.title1", fallback: "Du setzt\n")
          /// den Fokus.
          public static let title2 = L10n.tr("Localizable", "news.molo.onboarding.step2.title2", fallback: "den Fokus.")
        }
        public enum Step3 {
          /// Von Sport über Konzerte bis zum politischen Geschehen: Welche Themen sollen in deinem Feed erscheinen – welche nicht? Du bestimmst.
          public static let description = L10n.tr("Localizable", "news.molo.onboarding.step3.description", fallback: "Von Sport über Konzerte bis zum politischen Geschehen: Welche Themen sollen in deinem Feed erscheinen – welche nicht? Du bestimmst.")
          /// Interessen wählen
          public static let next = L10n.tr("Localizable", "news.molo.onboarding.step3.next", fallback: "Interessen wählen")
          /// Dein Feed,
          /// 
          public static let title1 = L10n.tr("Localizable", "news.molo.onboarding.step3.title1", fallback: "Dein Feed,\n")
          /// deine Inhalte.
          public static let title2 = L10n.tr("Localizable", "news.molo.onboarding.step3.title2", fallback: "deine Inhalte.")
        }
        public enum Step4 {
          /// molo bündelt Informationen und Events aus deinem Ort und macht lokale Stimmen sichtbar. Aktiviere Benachrichtigungen und bleibe mit molo auf dem Laufenden.
          public static let description = L10n.tr("Localizable", "news.molo.onboarding.step4.description", fallback: "molo bündelt Informationen und Events aus deinem Ort und macht lokale Stimmen sichtbar. Aktiviere Benachrichtigungen und bleibe mit molo auf dem Laufenden.")
          /// Los geht's
          public static let next = L10n.tr("Localizable", "news.molo.onboarding.step4.next", fallback: "Los geht's")
          /// Willkommen
          /// 
          public static let title1 = L10n.tr("Localizable", "news.molo.onboarding.step4.title1", fallback: "Willkommen\n")
          /// bei molo!
          public static let title2 = L10n.tr("Localizable", "news.molo.onboarding.step4.title2", fallback: "bei molo!")
        }
      }
      public enum OrganizationDetail {
        public enum Articles {
          /// Beiträge der letzten Tage
          public static let tab = L10n.tr("Localizable", "news.molo.organizationDetail.articles.tab", fallback: "Beiträge der letzten Tage")
        }
        public enum Events {
          /// Kommende Events
          public static let tab = L10n.tr("Localizable", "news.molo.organizationDetail.events.tab", fallback: "Kommende Events")
        }
        public enum User {
          public enum Articles {
            /// Meine Artikel-Posts
            public static let tab = L10n.tr("Localizable", "news.molo.organizationDetail.user.articles.tab", fallback: "Meine Artikel-Posts")
          }
          public enum Events {
            /// Meine Event-Posts
            public static let tab = L10n.tr("Localizable", "news.molo.organizationDetail.user.events.tab", fallback: "Meine Event-Posts")
          }
        }
      }
      public enum PasswordLost {
        public enum Button {
          /// Passwort Link anfordern
          public static let submit = L10n.tr("Localizable", "news.molo.passwordLost.button.submit", fallback: "Passwort Link anfordern")
        }
        public enum Input {
          /// E-Mail
          public static let email = L10n.tr("Localizable", "news.molo.passwordLost.input.email", fallback: "E-Mail")
        }
        public enum Text {
          /// Lass dir einen Link an deine E-Mail-Adresse senden, um das Passwort zurückzusetzen.
          public static let description = L10n.tr("Localizable", "news.molo.passwordLost.text.description", fallback: "Lass dir einen Link an deine E-Mail-Adresse senden, um das Passwort zurückzusetzen.")
          /// Passwort vergessen?
          public static let title = L10n.tr("Localizable", "news.molo.passwordLost.text.title", fallback: "Passwort vergessen?")
        }
      }
      public enum PasswordRenewal {
        public enum Button {
          /// Passwort speichern
          public static let submit = L10n.tr("Localizable", "news.molo.passwordRenewal.button.submit", fallback: "Passwort speichern")
        }
        public enum Input {
          /// Neues Passwort
          public static let password = L10n.tr("Localizable", "news.molo.passwordRenewal.input.password", fallback: "Neues Passwort")
          /// Neues Passwort bestätigen
          public static let passwordConfirmation = L10n.tr("Localizable", "news.molo.passwordRenewal.input.passwordConfirmation", fallback: "Neues Passwort bestätigen")
        }
        public enum Text {
          /// Gib dein neues Passwort ein, mit dem du dich zukünftig anmelden willst.
          public static let description = L10n.tr("Localizable", "news.molo.passwordRenewal.text.description", fallback: "Gib dein neues Passwort ein, mit dem du dich zukünftig anmelden willst.")
          /// Neues Passwort vergeben
          public static let title = L10n.tr("Localizable", "news.molo.passwordRenewal.text.title", fallback: "Neues Passwort vergeben")
        }
      }
      public enum Posting {
        /// Artikel posten
        public static let article = L10n.tr("Localizable", "news.molo.posting.article", fallback: "Artikel posten")
        /// Event posten
        public static let event = L10n.tr("Localizable", "news.molo.posting.event", fallback: "Event posten")
        /// Posting
        public static let title = L10n.tr("Localizable", "news.molo.posting.title", fallback: "Posting")
        /// Themen
        public static let topics = L10n.tr("Localizable", "news.molo.posting.topics", fallback: "Themen")
        public enum Article {
          public enum Description {
            /// Was gibt es Neues in deinem Ort?
            public static let placeholder = L10n.tr("Localizable", "news.molo.posting.article.description.placeholder", fallback: "Was gibt es Neues in deinem Ort?")
          }
          public enum Link {
            /// Artikel-Link (optional)
            public static let placeholder = L10n.tr("Localizable", "news.molo.posting.article.link.placeholder", fallback: "Artikel-Link (optional)")
          }
          public enum Title {
            /// Überschrift / Titel
            public static let placeholder = L10n.tr("Localizable", "news.molo.posting.article.title.placeholder", fallback: "Überschrift / Titel")
          }
        }
        public enum Cancel {
          public enum Alert {
            /// Änderungen verwerfen
            public static let delete = L10n.tr("Localizable", "news.molo.posting.cancel.alert.delete", fallback: "Änderungen verwerfen")
            /// Du hast ungespeicherte Änderungen. Wenn du jetzt zurückgehst, geht dein Fortschritt verloren.
            public static let message = L10n.tr("Localizable", "news.molo.posting.cancel.alert.message", fallback: "Du hast ungespeicherte Änderungen. Wenn du jetzt zurückgehst, geht dein Fortschritt verloren.")
            /// Entwurf speichern
            public static let save = L10n.tr("Localizable", "news.molo.posting.cancel.alert.save", fallback: "Entwurf speichern")
            /// Ungespeicherte Änderungen
            public static let title = L10n.tr("Localizable", "news.molo.posting.cancel.alert.title", fallback: "Ungespeicherte Änderungen")
          }
        }
        public enum Delete {
          public enum Alert {
            /// Abbrechen
            public static let cancel = L10n.tr("Localizable", "news.molo.posting.delete.alert.cancel", fallback: "Abbrechen")
            /// Möchtest du diesen Beitrag unwiderruflich löschen?
            public static let message = L10n.tr("Localizable", "news.molo.posting.delete.alert.message", fallback: "Möchtest du diesen Beitrag unwiderruflich löschen?")
            /// Löschen
            public static let ok = L10n.tr("Localizable", "news.molo.posting.delete.alert.ok", fallback: "Löschen")
            /// Beitrag löschen?
            public static let title = L10n.tr("Localizable", "news.molo.posting.delete.alert.title", fallback: "Beitrag löschen?")
          }
        }
        public enum Done {
          /// Fertig
          public static let action = L10n.tr("Localizable", "news.molo.posting.done.action", fallback: "Fertig")
        }
        public enum Draft {
          /// Entwurf speichern
          public static let action = L10n.tr("Localizable", "news.molo.posting.draft.action", fallback: "Entwurf speichern")
        }
        public enum Event {
          public enum Address {
            /// Adresse
            public static let placeholder = L10n.tr("Localizable", "news.molo.posting.event.address.placeholder", fallback: "Adresse")
          }
          public enum Date {
            /// Datum und Uhrzeit
            public static let placeholder = L10n.tr("Localizable", "news.molo.posting.event.date.placeholder", fallback: "Datum und Uhrzeit")
          }
          public enum Description {
            /// Infos zur Veranstaltung: Wer, Was, Wann, Wo und warum?
            public static let placeholder = L10n.tr("Localizable", "news.molo.posting.event.description.placeholder", fallback: "Infos zur Veranstaltung: Wer, Was, Wann, Wo und warum?")
          }
          public enum Link {
            /// Event-Link (optional)
            public static let placeholder = L10n.tr("Localizable", "news.molo.posting.event.link.placeholder", fallback: "Event-Link (optional)")
          }
          public enum TicketLink {
            /// Ticket-Link (optional)
            public static let placeholder = L10n.tr("Localizable", "news.molo.posting.event.ticketLink.placeholder", fallback: "Ticket-Link (optional)")
          }
          public enum Title {
            /// Event-Titel
            public static let placeholder = L10n.tr("Localizable", "news.molo.posting.event.title.placeholder", fallback: "Event-Titel")
          }
          public enum Venue {
            /// Spielstätte / Veranstaltungsort
            public static let placeholder = L10n.tr("Localizable", "news.molo.posting.event.venue.placeholder", fallback: "Spielstätte / Veranstaltungsort")
          }
        }
        public enum Image {
          public enum Alert {
            /// Übernehmen
            public static let ok = L10n.tr("Localizable", "news.molo.posting.image.alert.ok", fallback: "Übernehmen")
            /// Bildquelle
            public static let placeholder = L10n.tr("Localizable", "news.molo.posting.image.alert.placeholder", fallback: "Bildquelle")
            /// Bildquelle angeben
            public static let title = L10n.tr("Localizable", "news.molo.posting.image.alert.title", fallback: "Bildquelle angeben")
          }
        }
        public enum Incomplete {
          public enum Alert {
            /// Bitte mache folgende Angaben:
            /// %@
            public static func message(_ p1: Any) -> String {
              return L10n.tr("Localizable", "news.molo.posting.incomplete.alert.message", String(describing: p1), fallback: "Bitte mache folgende Angaben:\n%@")
            }
            /// OK
            public static let ok = L10n.tr("Localizable", "news.molo.posting.incomplete.alert.ok", fallback: "OK")
            /// Unvollständige Angaben
            public static let title = L10n.tr("Localizable", "news.molo.posting.incomplete.alert.title", fallback: "Unvollständige Angaben")
          }
        }
        public enum PickImage {
          /// Foto hochladen
          public static let action = L10n.tr("Localizable", "news.molo.posting.pickImage.action", fallback: "Foto hochladen")
        }
        public enum Post {
          /// Beitrag veröffentlichen
          public static let action = L10n.tr("Localizable", "news.molo.posting.post.action", fallback: "Beitrag veröffentlichen")
        }
        public enum TakePhoto {
          /// Fotografieren
          public static let action = L10n.tr("Localizable", "news.molo.posting.takePhoto.action", fallback: "Fotografieren")
        }
        public enum Topics {
          /// Wähle die Themen, die zu deinem Post passen. Unsere molo-KI hat schon mal ein paar Vorschläge gemacht.
          public static let description = L10n.tr("Localizable", "news.molo.posting.topics.description", fallback: "Wähle die Themen, die zu deinem Post passen. Unsere molo-KI hat schon mal ein paar Vorschläge gemacht.")
        }
      }
      public enum Postings {
        public enum Articles {
          /// Meine Posts
          public static let tab = L10n.tr("Localizable", "news.molo.postings.articles.tab", fallback: "Meine Posts")
        }
        public enum Events {
          /// Meine Events
          public static let tab = L10n.tr("Localizable", "news.molo.postings.events.tab", fallback: "Meine Events")
        }
      }
      public enum Profile {
        public enum Action {
          /// Änderungen speichern
          public static let save = L10n.tr("Localizable", "news.molo.profile.action.save", fallback: "Änderungen speichern")
        }
        public enum Cancel {
          public enum Alert {
            /// Änderungen verwerfen
            public static let delete = L10n.tr("Localizable", "news.molo.profile.cancel.alert.delete", fallback: "Änderungen verwerfen")
            /// Du hast ungespeicherte Änderungen. Wenn du jetzt zurückgehst, gehen deine Änderungen verloren.
            public static let message = L10n.tr("Localizable", "news.molo.profile.cancel.alert.message", fallback: "Du hast ungespeicherte Änderungen. Wenn du jetzt zurückgehst, gehen deine Änderungen verloren.")
            /// Profil speichern
            public static let save = L10n.tr("Localizable", "news.molo.profile.cancel.alert.save", fallback: "Profil speichern")
            /// Ungespeicherte Änderungen
            public static let title = L10n.tr("Localizable", "news.molo.profile.cancel.alert.title", fallback: "Ungespeicherte Änderungen")
          }
        }
        public enum Input {
          /// Selbstbeschreibung
          public static let description = L10n.tr("Localizable", "news.molo.profile.input.description", fallback: "Selbstbeschreibung")
          /// Anzeigename
          public static let displayName = L10n.tr("Localizable", "news.molo.profile.input.displayName", fallback: "Anzeigename")
          /// Email
          public static let email = L10n.tr("Localizable", "news.molo.profile.input.email", fallback: "Email")
          /// Homepage
          public static let homepage = L10n.tr("Localizable", "news.molo.profile.input.homepage", fallback: "Homepage")
          /// Nachname
          public static let lastname = L10n.tr("Localizable", "news.molo.profile.input.lastname", fallback: "Nachname")
          /// Ort
          public static let location = L10n.tr("Localizable", "news.molo.profile.input.location", fallback: "Ort")
          /// Vorname
          public static let prename = L10n.tr("Localizable", "news.molo.profile.input.prename", fallback: "Vorname")
        }
        public enum Photo {
          public enum Dialog {
            /// Was möchtest du tun?
            public static let message = L10n.tr("Localizable", "news.molo.profile.photo.dialog.message", fallback: "Was möchtest du tun?")
            /// Profilbild
            public static let title = L10n.tr("Localizable", "news.molo.profile.photo.dialog.title", fallback: "Profilbild")
            public enum Action {
              /// Foto löschen
              public static let delete = L10n.tr("Localizable", "news.molo.profile.photo.dialog.action.delete", fallback: "Foto löschen")
              /// Neues Foto hochladen
              public static let new = L10n.tr("Localizable", "news.molo.profile.photo.dialog.action.new", fallback: "Neues Foto hochladen")
            }
          }
        }
        public enum Title {
          /// Private Informationen
          public static let `private` = L10n.tr("Localizable", "news.molo.profile.title.private", fallback: "Private Informationen")
          /// Öffentliche Informationen
          public static let `public` = L10n.tr("Localizable", "news.molo.profile.title.public", fallback: "Öffentliche Informationen")
        }
      }
      public enum Registration {
        public enum Button {
          /// Konto erstellen
          public static let submit = L10n.tr("Localizable", "news.molo.registration.button.submit", fallback: "Konto erstellen")
        }
        public enum Confirmation {
          public enum Text {
            /// Wir haben dir eine E-Mail mit einem Bestätigungslink gesendet. Bitte gehe zu deinem E-Mail-Postfach, um deinen Account freizuschalten.
            public static let description = L10n.tr("Localizable", "news.molo.registration.confirmation.text.description", fallback: "Wir haben dir eine E-Mail mit einem Bestätigungslink gesendet. Bitte gehe zu deinem E-Mail-Postfach, um deinen Account freizuschalten.")
            /// Willkommen bei Molo!
            public static let title = L10n.tr("Localizable", "news.molo.registration.confirmation.text.title", fallback: "Willkommen bei Molo!")
          }
        }
        public enum Input {
          /// Anzeigename
          public static let displayName = L10n.tr("Localizable", "news.molo.registration.input.displayName", fallback: "Anzeigename")
          /// E-Mail
          public static let email = L10n.tr("Localizable", "news.molo.registration.input.email", fallback: "E-Mail")
          /// Nachname
          public static let lastname = L10n.tr("Localizable", "news.molo.registration.input.lastname", fallback: "Nachname")
          /// Passwort
          public static let password = L10n.tr("Localizable", "news.molo.registration.input.password", fallback: "Passwort")
          /// Vorname
          public static let prename = L10n.tr("Localizable", "news.molo.registration.input.prename", fallback: "Vorname")
        }
        public enum Text {
          /// Du möchtest selbst lokale Infos und Events bei molo veröffentlichen? Dann melde dich an und poste direkt über die App.
          public static let description = L10n.tr("Localizable", "news.molo.registration.text.description", fallback: "Du möchtest selbst lokale Infos und Events bei molo veröffentlichen? Dann melde dich an und poste direkt über die App.")
          /// Anmelden
          public static let title = L10n.tr("Localizable", "news.molo.registration.text.title", fallback: "Anmelden")
          public enum Terms {
            /// [Nutzungsbedingungen](https://www.molo.news/nutzungsbedingungen.html)
            public static let link = L10n.tr("Localizable", "news.molo.registration.text.terms.link", fallback: "[Nutzungsbedingungen](https://www.molo.news/nutzungsbedingungen.html)")
            ///  gelesen und verstanden habe.
            public static let `postfix` = L10n.tr("Localizable", "news.molo.registration.text.terms.postfix", fallback: " gelesen und verstanden habe.")
            /// Ich bestätige hiermit, dass ich die 
            public static let `prefix` = L10n.tr("Localizable", "news.molo.registration.text.terms.prefix", fallback: "Ich bestätige hiermit, dass ich die ")
          }
        }
      }
      public enum Report {
        /// Artikel melden
        public static let article = L10n.tr("Localizable", "news.molo.report.article", fallback: "Artikel melden")
        /// Event melden
        public static let event = L10n.tr("Localizable", "news.molo.report.event", fallback: "Event melden")
      }
      public enum Search {
        /// Suche
        public static let hint = L10n.tr("Localizable", "news.molo.search.hint", fallback: "Suche")
        public enum Ai {
          /// KI-Suche (z. B. Was, Wann, Wo)
          public static let hint = L10n.tr("Localizable", "news.molo.search.ai.hint", fallback: "KI-Suche (z. B. Was, Wann, Wo)")
        }
        public enum Articles {
          /// Artikel
          public static let tab = L10n.tr("Localizable", "news.molo.search.articles.tab", fallback: "Artikel")
        }
        public enum Events {
          /// Events
          public static let tab = L10n.tr("Localizable", "news.molo.search.events.tab", fallback: "Events")
        }
        public enum History {
          /// Suchverlauf löschen
          public static let clear = L10n.tr("Localizable", "news.molo.search.history.clear", fallback: "Suchverlauf löschen")
          /// Zuletzt gesucht
          public static let title = L10n.tr("Localizable", "news.molo.search.history.title", fallback: "Zuletzt gesucht")
        }
      }
      public enum Share {
        /// Diese News habe ich in der molo App gefunden:
        /// %@
        /// %@
        public static func article(_ p1: Any, _ p2: Any) -> String {
          return L10n.tr("Localizable", "news.molo.share.article", String(describing: p1), String(describing: p2), fallback: "Diese News habe ich in der molo App gefunden:\n%@\n%@")
        }
        /// Dieses Event habe ich in der molo App gefunden:
        /// %@
        /// %@
        public static func event(_ p1: Any, _ p2: Any) -> String {
          return L10n.tr("Localizable", "news.molo.share.event", String(describing: p1), String(describing: p2), fallback: "Dieses Event habe ich in der molo App gefunden:\n%@\n%@")
        }
        /// 
        /// 
        /// Du kannst die App im App-Store (https://apps.apple.com/us/app/molo.news/id1486601544?l=de&ls=1) und bei Google Play (https://play.google.com/store/apps/details?id=news.molo.android) laden.
        public static let links = L10n.tr("Localizable", "news.molo.share.links", fallback: "\n\nDu kannst die App im App-Store (https://apps.apple.com/us/app/molo.news/id1486601544?l=de&ls=1) und bei Google Play (https://play.google.com/store/apps/details?id=news.molo.android) laden.")
      }
      public enum Sources {
        /// Meine Quellen
        public static let title = L10n.tr("Localizable", "news.molo.sources.title", fallback: "Meine Quellen")
        public enum Action {
          /// Folgen
          public static let follow = L10n.tr("Localizable", "news.molo.sources.action.follow", fallback: "Folgen")
          /// Entfolgen
          public static let unfollow = L10n.tr("Localizable", "news.molo.sources.action.unfollow", fallback: "Entfolgen")
        }
        public enum Collectives {
          /// Community
          public static let title = L10n.tr("Localizable", "news.molo.sources.collectives.title", fallback: "Community")
        }
        public enum News {
          /// Medien
          public static let title = L10n.tr("Localizable", "news.molo.sources.news.title", fallback: "Medien")
        }
        public enum Officials {
          /// Offizielle
          public static let title = L10n.tr("Localizable", "news.molo.sources.officials.title", fallback: "Offizielle")
        }
      }
      public enum Tabbar {
        /// Events
        public static let events = L10n.tr("Localizable", "news.molo.tabbar.events", fallback: "Events")
        /// Localizable.strings
        ///   moloUI
        public static let explore = L10n.tr("Localizable", "news.molo.tabbar.explore", fallback: "Explore")
        /// Feed
        public static let feed = L10n.tr("Localizable", "news.molo.tabbar.feed", fallback: "Feed")
        /// Mehr
        public static let participate = L10n.tr("Localizable", "news.molo.tabbar.participate", fallback: "Mehr")
        /// Suche
        public static let search = L10n.tr("Localizable", "news.molo.tabbar.search", fallback: "Suche")
        /// Gemerkt
        public static let watchlist = L10n.tr("Localizable", "news.molo.tabbar.watchlist", fallback: "Gemerkt")
      }
      public enum Tags {
        public enum Articles {
          /// Artikel Themen
          public static let tab = L10n.tr("Localizable", "news.molo.tags.articles.tab", fallback: "Artikel Themen")
        }
        public enum Events {
          /// Event Themen
          public static let tab = L10n.tr("Localizable", "news.molo.tags.events.tab", fallback: "Event Themen")
        }
      }
      public enum Time {
        /// Uhr
        public static let appendix = L10n.tr("Localizable", "news.molo.time.appendix", fallback: "Uhr")
      }
      public enum Topics {
        /// Alle
        public static let selectAll = L10n.tr("Localizable", "news.molo.topics.selectAll", fallback: "Alle")
        /// Meine Themen
        public static let title = L10n.tr("Localizable", "news.molo.topics.title", fallback: "Meine Themen")
      }
      public enum Url {
        /// https://molo.news/impressum.html
        public static let imprint = L10n.tr("Localizable", "news.molo.url.imprint", fallback: "https://molo.news/impressum.html")
        /// https://www.molo.news/
        public static let info = L10n.tr("Localizable", "news.molo.url.info", fallback: "https://www.molo.news/")
        /// https://molo.news/datenschutz.html
        public static let privacy = L10n.tr("Localizable", "news.molo.url.privacy", fallback: "https://molo.news/datenschutz.html")
        /// https://molo.news/nutzungsbedingungen.html
        public static let terms = L10n.tr("Localizable", "news.molo.url.terms", fallback: "https://molo.news/nutzungsbedingungen.html")
      }
      public enum Watchlist {
        public enum Articles {
          /// Gemerkte Posts
          public static let tab = L10n.tr("Localizable", "news.molo.watchlist.articles.tab", fallback: "Gemerkte Posts")
        }
        public enum Events {
          /// Gemerkte Events
          public static let tab = L10n.tr("Localizable", "news.molo.watchlist.events.tab", fallback: "Gemerkte Events")
        }
      }
    }
  }
  public enum Storage {
    public enum App {
      /// isDarkMode
      public static let darkMode = L10n.tr("Localizable", "storage.app.darkMode", fallback: "isDarkMode")
    }
  }
  public enum Url {
    public enum App {
      public enum Delegate {
        /// activate
        public static let activate = L10n.tr("Localizable", "url.app.delegate.activate", fallback: "activate")
        /// already-activated
        public static let activated = L10n.tr("Localizable", "url.app.delegate.activated", fallback: "already-activated")
        public enum Bearer {
          /// bearer
          public static let token = L10n.tr("Localizable", "url.app.delegate.bearer.token", fallback: "bearer")
        }
        public enum Password {
          /// password-reset
          public static let reset = L10n.tr("Localizable", "url.app.delegate.password.reset", fallback: "password-reset")
        }
        public enum Reset {
          /// token
          public static let token = L10n.tr("Localizable", "url.app.delegate.reset.token", fallback: "token")
        }
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
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
