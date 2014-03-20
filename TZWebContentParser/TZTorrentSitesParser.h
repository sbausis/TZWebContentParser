//
//  TZTorrentSitesParser.h
//  TZWebContentParser
//
//  Created by Simon Baur on 12/8/13.
//  Copyright (c) 2013 Simon Baur. All rights reserved.
//

#import "TZHtmlRawParser.h"

#ifndef TZWebContentParser_TZTorrentSitesParser_h
#define TZWebContentParser_TZTorrentSitesParser_h

@interface TZ_bitsnoop_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_torrentdownloads_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_monova_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_torrentcrazy_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_torrentreactor_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_torrenthound_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_houndmirror_PageParser : TZ_torrenthound_PageParser
@end

@interface TZ_kickass_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_kickmirror_PageParser : TZ_kickass_PageParser
@end

@interface TZ_torrentfunk_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_seedpeer_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_yourbittorrent_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_torrents_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_fulldls_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_limetorrents_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_archive_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_thepiratebay_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_baymirror_PageParser : TZ_thepiratebay_PageParser
@end

@interface TZ_torrentzap_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_extratorrent_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_torlock_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_vertor_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_1337x_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_torrentbit_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_rarbg_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_newtorrents_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_bt_chat_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_publichd_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_eztv_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_linuxtracker_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

@interface TZ_h33t_PageParser : TZHtmlRawParser <NSHTMLParserDelegate>
@end

#endif
