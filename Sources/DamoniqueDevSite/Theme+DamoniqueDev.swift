//
//  File.swift
//  
//
//  Created by Damonique Blake on 7/31/20.
//

import Foundation
import Publish
import Plot

extension Theme {
    static var damoniqueDev: Theme {
        Theme(
            htmlFactory: DamoniqueDevHTMLFactory(),
            resourcePaths: ["Resources/DamoniqueDevTheme/styles.css"]
        )
    }
}

private struct DamoniqueDevHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body(
                .header(for: context, selectedTitle: nil),
                .wrapper(
                    .h1(
                        .text(index.title),
                        .img(
                            .attribute(named: "style", value: "float: right; height: 300px; margin-bottom: 10px"),
                            .src("images/memoji.png")
                        )
                    ),
                    .p(
                        .class("description"),
                        .contentBody(index.body)
                    ),
                    .br(),
                    .br(),
                    .br(),
                    .div(
                        .p("I'm going to be launching iOS courses soon, so if you would like to be notified of their progress and launch dates, enter your name and email below!"),
                        .class("email-capture"),
                        .script(
                            .async(),
                            .attribute(named: "data-uid", value: "31912c4f60"),
                            .src(iOSCourcesEmailForm)
                        )
                    )
                ),
                .footer(for: context.site)
            )
        )
    }
    
    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body(
                .header(for: context, selectedTitle: section.title),
                .wrapper(
                    .h1(.text(section.title)),
                    .p(
                        .class("description"),
                        .text(section.description)
                    ),
                    .itemList(for: section.items, for: context)
                ),
                .footer(for: context.site)
            )
        )
    }
    
    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(
                .class("item-page"),
                .header(for: context, selectedTitle: item.title),
                .wrapper(
                    .article(
                        .div(
                            .class("date"),
                            .attribute(named: "style", value: "display: inline-flex;"),
                            .p("Published: ",
                               .text(context.dateFormatter.string(from: item.date))
                            ),
                            .p( .attribute(named: "style", value: "margin: 0 7px;"),
                                " • \(item.readingTime.minutes.roundToInt()) minute Read")
                        ),
                        .h1(.text(item.title)),
                        .tagList(for: item, on: context.site),
                        .div(
                            .class("content"),
                            .contentBody(item.body)
                        )
                    ),
                    .emailListFooter()
                ),
                .footer(for: context.site)
            )
        )
    }
    
    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedTitle: page.title),
                .wrapper(.contentBody(page.body)),
                .footer(for: context.site)
            )
        )
    }
    
    private func getSectionID(for page: Page) -> DamoniqueDevSite.SectionID? {
        return DamoniqueDevSite.SectionID(rawValue: page.title)
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedTitle: nil),
                .wrapper(
                    .h1("Browse all tags"),
                    .ul(
                        .class("all-tags"),
                        .forEach(page.tags.sorted()) { tag in
                            .li(
                                .class("tag"),
                                .a(
                                    .href(context.site.path(for: tag)),
                                    .text(tag.string)
                                )
                            )
                        }
                    )
                ),
                .footer(for: context.site)
            )
        )
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedTitle: nil),
                .wrapper(
                    .h1(
                        "Tagged with ",
                        .span(.class("tag"), .text(page.tag.string))
                    ),
                    .a(
                        .class("browse-all"),
                        .text("Browse all tags"),
                        .href(context.site.tagListPath)
                    ),
                    .itemList(
                        for: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        for: context
                    )
                ),
                .footer(for: context.site)
            )
        )
    }
}

private extension Node where Context == HTML.BodyContext {
    static func header<T: Website>(for context: PublishingContext<T>, selectedTitle: String?) -> Node {
        let sectionIDs = T.SectionID.allCases

        return .header(
            .wrapper(
                .a(.class("site-name"), .href("/"), .text(context.site.name)),
                .br(),
                .if(sectionIDs.count > 1,
                    .nav(
                        .ul(
                            .forEach(sectionIDs) { section in
                            .li(
                                .class(isSectionSelected(section: section, selectedTitle: selectedTitle, in: context) ? "selected" : ""),
                                .a(
                                    .href(sectionHref(for: section, in: context)),
                                    .text(context.sections[section].title)
                                )
                            )
                        })
                    )
                )
            )
        )
    }
    
    private static func isSectionSelected<T: Website>(section: T.SectionID, selectedTitle: String?, in context: PublishingContext<T>) -> Bool {
        guard let selectedTitle = selectedTitle else {
            return false
        }

        return context.sections[section].title.lowercased() == selectedTitle.lowercased()
    }
    
    private static func sectionHref<T: Website>(for section: T.SectionID, in context: PublishingContext<T>) -> Path {
        if section == DamoniqueDevSite.SectionID.about as! T.SectionID {
            return Path("/")
        }
        return context.sections[section].path
    }
    
    static func emailListFooter() -> Node {
        .div(
            .br(),
            .br(),
            .h3(
                .attribute(named: "style", value: "text-align: left;"),
                "If you liked this blog post, subcribe to my email list for exclusive content and offers."),
            .class("email-capture"),
            .script(
                .async(),
                .attribute(named: "data-uid", value: "0f7c690b53"),
                .src(generalEmailForm)
            )
        )
    }
    
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }
    
    static func itemList<T: Website>(for items: [Item<T>], for context: PublishingContext<T>) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items) { item in
                .li(
                    .article(
                        .h1(
                            .a(
                                .href(item.path),
                                .text(item.title)
                            )
                        ),
                        .p(.text(item.description)),
                        .br(),
                        .span(
                            .tagList(for: item, on: context.site),
                            .div(
                                .class("date"),
                                .attribute(named: "style", value: "display: inline-flex;"),
                                .p("Published: ",
                                   .text(context.dateFormatter.string(from: item.date))
                                ),
                                .p( .attribute(named: "style", value: "margin: 0 7px;"),
                                    " • \(item.readingTime.minutes.roundToInt()) minute Read")
                            )
                        )
                    )
                )
            }
        )
    }
    
    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        return .ul(.class("tag-list"), .forEach(item.tags) { tag in
            .li(.a(
                .href(site.path(for: tag)),
                .text(tag.string)
                ))
            })
    }
    
    static func footer<T: Website>(for site: T) -> Node {
        return .footer(
            .p(
                .class("socials"),
                .text("Find Me: "),
                .a(.text("Twitter"), .href(twitterLink)),
                .text(" | "),
                .a(.text("Instagram"), .href(instagramLink)),
                .text(" | "),
                .a(.text("LinkedIn"), .href(linkedInLink)),
                .text(" | "),
                .a(.text("Youtube"), .href(youtubeLink))
            ),
            .p("©2020 Damonique Blake"),
            .p(
                .text("Generated using "),
                .a(.text("Publish"), .href("https://github.com/johnsundell/publish"))
            )
        )
    }
}
