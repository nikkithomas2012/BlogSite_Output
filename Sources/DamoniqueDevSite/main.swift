import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct DamoniqueDevSite: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case about
        case blog
        case services
        case contact
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://damonique.dev")!
    var name = "Damonique.dev"
    var description = "The blog and portfolio website for Damonique.dev"
    var language: Language { .english }
    var imagePath: Path? { "images/memoji.png" }
    var favicon = Favicon()
}

// This will generate your website using the built-in Foundation theme:
try DamoniqueDevSite().publish(
    withTheme: .damoniqueDev,
    additionalSteps: [
        .step(named: "Use custom DateFormatter") { context in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, YYYY"
            context.dateFormatter = formatter
        }
    ])
