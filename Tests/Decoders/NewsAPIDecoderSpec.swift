//
//  NewsSourceDecoder.swift
//  Tests
//
//  Created by Lucas Lima on 22/06/18.
//  Copyright © 2018 Lucas Lima. All rights reserved.
//

import Nimble
import Quick

@testable import NewsAPISwift

class NewsAPIDecoderSpec: QuickSpec {
    override func spec() {
        var decoder: NewsAPIDecoder!
        
        beforeEach {
            decoder = NewsAPIDecoder()
        }
        
        describe("Source JSON Decoding") {
            context("When Server Error Response") {
                it("Throws Service Error") {
                    expect { try decoder.decode(data: Fakes.NewsAPI.noApiKeyErrorJsonData) as [NewsSource] }
                    .to(throwError(NewsAPIError.serviceError(code: "apiKeyMissing",
                                                                 message: "Your API key is missing. Append this to the URL with the apiKey param, or use the x-api-key HTTP header.")))
                }
            }
            
            context("When Valid Data") {
                it("Returns Sources") {
                    expect { try decoder.decode(data: Fakes.Sources.successJsonData) as [NewsSource] }
                        == [Fakes.Sources.source]
                }
            }
            
            context("When Invalid Data") {
                it("Throws Unable To Parse Error") {
                    expect { try decoder.decode(data: Fakes.Sources.invalidJsonData) as [NewsSource] }
                        .to(throwError(NewsAPIError.unableToParse))
                }
            }
            
            context("When Empty Data") {
                it("Throws Unable To Parse Error") {
                    expect { try decoder.decode(data: Fakes.Sources.emptyJsonData) as [NewsSource] }
                        == []
                }
            }
        }
        
        describe("Article JSON Decoding") {
            context("When Valid Data") {
                it("Returns Articles") {
                    expect { try decoder.decode(data: Fakes.TopHeadlines.successTopHeadlinesJsonData) as [NewsArticle] }
                        == [Fakes.TopHeadlines.topHeadline1]
                }
            }
            
            context("When Fractional Published Date") {                
                it("Returns Articles") {
                    expect { try decoder.decode(data: Fakes.TopHeadlines.fractionalSuccessTopHeadlinesJsonData) as [NewsArticle] }
                        == [Fakes.TopHeadlines.topHeadlineFractionalDate]
                }
            }
        }
    }
}
