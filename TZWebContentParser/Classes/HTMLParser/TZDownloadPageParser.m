//
//  TZDownloadPageParser.m
//  TZWebContentParser
//
//  Created by Simon Baur on 11/11/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZDownloadPageParser.h"

// Downloads Elements
#define DOWNLOADS_DOWNLOADS_ELEMENT_NAME @"Downloads"
#define DATE_DOWNLOADS_ELEMENT_NAME @"Date"
#define FILE_DOWNLOADS_ELEMENT_NAME @"File"
#define WARNING_DOWNLOADS_ELEMENT_NAME @"Warning"

// Page Elements
#define LINK_PAGE_ELEMENT_NAME @"Link"
#define SERVER_PAGE_ELEMENT_NAME @"Server"
#define TITLE_PAGE_ELEMENT_NAME @"Title"
#define AGE_PAGE_ELEMENT_NAME @"Age"

// HTML Elements
#define A_HTML_ELEMENT @"a"
#define DIV_HTML_ELEMENT @"div"
#define DL_HTML_ELEMENT @"dl"
#define DT_HTML_ELEMENT @"dt"
#define DD_HTML_ELEMENT @"dd"
#define H2_HTML_ELEMENT @"h2"
#define SPAN_HTML_ELEMENT @"span"
#define P_HTML_ELEMENT @"p"

@implementation TZDownloadPageParser {
    
    NSMutableArray *downloads;
    
    BOOL startedDocument;
    BOOL hasDownloads;
    BOOL hasDate;
    BOOL isDate;
    BOOL hasFile;
    BOOL isFile;
    BOOL hasPage;
    BOOL hasLink;
    BOOL isLink;
    BOOL hasServer;
    BOOL hasTitle;
    BOOL hasAge;
    BOOL isAge;
    BOOL hasWarning;
    
}

#pragma mark -
#pragma mark NSHTMLParserDelegate

-(void)parserDidStartDocument:(DTHTMLParser *)parser {
    
    TZLog(@"%s", __FUNCTION__);
    downloads = [[NSMutableArray alloc] init];
    self.dataDict = [[NSMutableDictionary alloc] init];
    
    startedDocument = YES;
    hasDownloads = NO;
    hasDate = NO;
    isDate = NO;
    hasFile = NO;
    isFile = NO;
    hasPage = NO;
    hasLink = NO;
    isLink = NO;
    hasServer = NO;
    hasTitle = NO;
    hasAge = NO;
    isAge = NO;
    hasWarning = NO;
    
}
-(void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict {
    if (hasDownloads) {
        if (hasDate) {
            if (isDate) {
                
            }
            else if ([elementName isEqualToString:@"span"]) {
                isDate = YES;
                TZLog(@"%s: span : Date2", __FUNCTION__);
                TZLog(@"attributes: %@", attributeDict);
                [self.dataDict setObject:[attributeDict objectForKey:@"title"] forKey:@"Date"];
            }
        }
        else if ([elementName isEqualToString:@"div"]) {
            hasDate = YES;
            TZLog(@"%s: div : Date", __FUNCTION__);
        }
        else if (hasFile) {
            if ([elementName isEqualToString:@"span"]) {
                isFile = YES;
                TZLog(@"%s: span : File2", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"h2"]) {
            hasFile = YES;
            TZLog(@"%s: h2 : File", __FUNCTION__);
        }
        else if (hasPage) {
            if (hasLink) {
                if (isLink) {
                    if (hasServer) {
                        
                    }
                    else if ([elementName isEqualToString:@"span"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"u"]) {
                        hasServer = YES;
                        TZLog(@"%s: span : Server", __FUNCTION__);
                        TZLog(@"attributes: %@", attributeDict);
                        
                        NSString* style = [attributeDict objectForKey:@"style"];
                        NSRange start = [style rangeOfString:@"('"];
                        NSRange stop = [style rangeOfString:@"')"];
                        start.location = start.location+start.length;
                        start.length = stop.location-start.location;
                        style = [style substringWithRange:start];
                        style = [NSString stringWithFormat:@"http://torrentz.eu%@", style];
                        
                        [(NSMutableDictionary*)[downloads objectAtIndex:[downloads count]-1] setObject:[style copy] forKey:@"Style"];
                        //[(NSMutableDictionary*)[downloads objectAtIndex:[downloads count]-1] setObject:[attributeDict objectForKey:@"style"] forKey:@"Style"];
                    }
                    else if (hasTitle) {
                        
                    }
                    else if ([elementName isEqualToString:@"span"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"n"]) {
                        hasTitle = YES;
                        TZLog(@"%s: span : Title", __FUNCTION__);
                    }
                }
                else if ([elementName isEqualToString:@"a"] && [[attributeDict objectForKey:@"rel"] isEqualToString:@"e"]) {
                    isLink = YES;
                    TZLog(@"%s: a : Link2", __FUNCTION__);
                    TZLog(@"attributes: %@", attributeDict);
                    [(NSMutableDictionary*)[downloads objectAtIndex:[downloads count]-1] setObject:[attributeDict objectForKey:@"href"] forKey:@"Link"];
                }
            }
            else if ([elementName isEqualToString:@"dt"]) {
                hasLink = YES;
                TZLog(@"%s: dt : Link", __FUNCTION__);
            }
            else if (hasAge) {
                if (isAge) {
                    
                }
                else if ([elementName isEqualToString:@"span"]) {
                    isAge = YES;
                    TZLog(@"%s: span : Age2", __FUNCTION__);
                    TZLog(@"attributes: %@", attributeDict);
                    [(NSMutableDictionary*)[downloads objectAtIndex:[downloads count]-1] setObject:[attributeDict objectForKey:@"title"] forKey:@"Age"];
                }
            }
            else if ([elementName isEqualToString:@"dd"]) {
                hasAge = YES;
                TZLog(@"%s: dd : Age", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"dl"]) {
            hasPage = YES;
            TZLog(@"%s: dl : Page", __FUNCTION__);
            [downloads addObject:[[NSMutableDictionary alloc] init]];
        }
        else if (hasWarning) {
            
        }
        else if ([elementName isEqualToString:@"p"]) {
            hasWarning = YES;
            TZLog(@"%s: p : Warning", __FUNCTION__);
        }
    }
    else if ([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"download"]) {
        hasDownloads = YES;
        TZLog(@"%s: div : Downloads", __FUNCTION__);
    }
}
-(void)parser:(DTHTMLParser *)parser foundCharacters:(NSString *)string {
    NSString *newString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([newString length] > 0) {
        if (hasDownloads) {
            if (hasDate) {
                if (isDate) {
                    TZLog(@"%s: Date2 %@", __FUNCTION__, string);
                    [self.dataDict setObject:[newString copy] forKey:@"Date2"];
                }
                else {
                    TZLog(@"%s: Date %@", __FUNCTION__, string);
                }
            }
            else if (hasFile) {
                if (isFile) {
                    TZLog(@"%s: File2 %@", __FUNCTION__, string);
                    [self.dataDict setObject:[newString copy] forKey:@"File"];
                }
                else {
                    TZLog(@"%s: File %@", __FUNCTION__, string);
                    [self.dataDict setObject:[newString copy] forKey:@"Count"];
                }
            }
            else if (hasPage) {
                if (hasLink) {
                    if (isLink) {
                        if (hasServer) {
                            TZLog(@"%s: Server %@", __FUNCTION__, string);
                            [(NSMutableDictionary*)[downloads objectAtIndex:[downloads count]-1] setObject:[newString copy] forKey:@"Server"];
                        }
                        else if (hasTitle) {
                            TZLog(@"%s: Title %@", __FUNCTION__, string);
                            [(NSMutableDictionary*)[downloads objectAtIndex:[downloads count]-1] setObject:[newString copy] forKey:@"Title"];
                        }
                        else {
                            TZLog(@"%s: Link2 %@", __FUNCTION__, string);
                            [(NSMutableDictionary*)[downloads objectAtIndex:[downloads count]-1] setObject:[newString copy] forKey:@"Categories"];
                        }
                    }
                    else {
                        TZLog(@"%s: Link %@", __FUNCTION__, string);
                    }
                }
                else if (hasAge) {
                    if (isAge) {
                        TZLog(@"%s: Age2 %@", __FUNCTION__, string);
                        [(NSMutableDictionary*)[downloads objectAtIndex:[downloads count]-1] setObject:[newString copy] forKey:@"Age2"];
                    }
                    else {
                        TZLog(@"%s: Age %@", __FUNCTION__, string);
                    }
                }
                else {
                    TZLog(@"%s: Page %@", __FUNCTION__, string);
                }
            }
            else if (hasWarning) {
                TZLog(@"%s: Warning %@", __FUNCTION__, string);
                NSString *warning = [self.dataDict objectForKey:@"Warning"];
                if (warning != Nil) {
                    [self.dataDict setObject:[warning stringByAppendingString:newString] forKey:@"Warning"];
                }
                else [self.dataDict setObject:[newString copy] forKey:@"Warning"];
            }
        }
    }
}
-(void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName {
    if (hasDownloads) {
        if (hasDate) {
            if (isDate) {
                if ([elementName isEqualToString:@"span"]) {
                    isDate = NO;
                    TZLog(@"%s: span : Date2", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"div"]) {
                hasDate = NO;
                TZLog(@"%s: div : Date", __FUNCTION__);
            }
        }
        else if (hasFile) {
            if (isFile) {
                if ([elementName isEqualToString:@"span"]) {
                    isFile = NO;
                    TZLog(@"%s: span : File2", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"h2"]) {
                hasFile = NO;
                TZLog(@"%s: h2 : File", __FUNCTION__);
            }
        }
        else if (hasPage) {
            if (hasLink) {
                if (isLink) {
                    if (hasServer) {
                        if ([elementName isEqualToString:@"span"]) {
                            hasServer = NO;
                            TZLog(@"%s: span : Server", __FUNCTION__);
                        }
                    }
                    else if (hasTitle) {
                        if ([elementName isEqualToString:@"span"]) {
                            hasTitle = NO;
                            TZLog(@"%s: span : Title", __FUNCTION__);
                        }
                    }
                    else if ([elementName isEqualToString:@"a"]) {
                        isLink = NO;
                        TZLog(@"%s: a : Link2", __FUNCTION__);
                    }
                }
                else if ([elementName isEqualToString:@"dt"]) {
                    hasLink = NO;
                    TZLog(@"%s: dt : Link", __FUNCTION__);
                }
            }
            else if (hasAge) {
                if (isAge) {
                    if ([elementName isEqualToString:@"span"]) {
                        isAge = NO;
                        TZLog(@"%s: span : Age2", __FUNCTION__);
                    }
                }
                else if ([elementName isEqualToString:@"dd"]) {
                    hasAge = NO;
                    TZLog(@"%s: dd : Age", __FUNCTION__);
                }
            }
            else if ([elementName isEqualToString:@"dl"]) {
                hasPage = NO;
                TZLog(@"%s: dl : Page", __FUNCTION__);
                if ([(NSMutableDictionary*)[downloads objectAtIndex:[downloads count]-1] count] <= 0) {
                    [downloads removeObjectAtIndex:[downloads count]-1];
                }
            }
        }
        else if (hasWarning) {
            if ([elementName isEqualToString:@"p"]) {
                hasWarning = NO;
                TZLog(@"%s: p : Warning", __FUNCTION__);
            }
        }
        else if ([elementName isEqualToString:@"div"]) {
            hasDownloads = NO;
            TZLog(@"%s: div : Downloads", __FUNCTION__);
        }
    }
}
-(void)parser:(DTHTMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    TZLog(@"%s: [%@] %@, %ld, %ld", __FUNCTION__, parser, parseError, (long)[parser lineNumber], (long)[parser columnNumber]);
    startedDocument = NO;
}
-(void)parserDidEndDocument:(DTHTMLParser *)parser {
    TZLog(@"%s:", __FUNCTION__);
    startedDocument = NO;
    [self.dataDict setObject:downloads forKey:@"Downloads"];
    TZLog(@"array: %@ %lu", downloads, (unsigned long)[downloads count]);
    TZLog(@"dict: %@ %lu %lu", self.dataDict, (unsigned long)[self.dataDict count], (unsigned long)[(NSMutableArray*)[self.dataDict objectForKey:@"Downloads"] count]);
    if ([self.dataDict count] > 0) {
        [self.htmlParserDelegate htmlParserDidEnd:self];
    }
    else {
        [self.htmlParserDelegate htmlParserDidFail:self];
    }
}

@end
