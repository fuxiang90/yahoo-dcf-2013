#!/usr/bin/python
# -*- coding: utf-8 -*-


import urllib
import urllib2
import sys
import json
import re

import yql
api_key = "77f1cc3b101c84e5c2694ff1ab73172b"


def get_json_url(url):
#     url = "http://where.yahooapis.com/geocode?location=" + str(location) + "&flags=J&gflags=R&appid=" + str(yhack_yahoo_app_id)
#     json = urllib2.urlopen(woeid_api_url).read()
    pass

def get_json_flickr_yql():
    url = "http://query.yahooapis.com/v1/public/yql?q="
 
    query_str = 'select * from flickr.photos.sizes where photo_id in (select id from flickr.photos.search where text=@text  and api_key=@api_key limit 100) and api_key =@api_key' 
#     select * from flickr.photos.sizes where photo_id in (select id from flickr.photos.search where text="supermaket" and api_key="77f1cc3b101c84e5c2694ff1ab73172b" limit 100) and api_key ="77f1cc3b101c84e5c2694ff1ab73172b"
#     query_str.replace(' ', "%20")
    print url+query_str
#     print urllib2.urlopen(url+query_str).read()
    y = yql.Public() 
    query = 'select * from flickr.photos.search where text=@text and api_key="77f1cc3b101c84e5c2694ff1ab73172b" limit 3';
#     l =   y.execute(query ,{"text": "supermaket"})
    l = y.execute(query_str , {"text":"supermaket" ,"api_key":api_key})
    for row in  l.rows:
        print row
#     print json_str



if __name__  == '__main__':
    
#     result = urllib2.urlopen('http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%3D'FFIV'%0A%09%09&format=json&env=http%3A%2F%2Fdatatables.org%2Falltables.env&callback=').read()
#     print result.read()
#     y = yql.Public()
#     result = y.execute('use "http://www.datatables.org/yahoo/finance/yahoo.finance.quotes.xml" as yahoo.finance.quotes; select * from yahoo.finance.quotes where symbol in ("YHOO")')
#     
    get_json_flickr_yql()
    
    print "done it"
    

