#!/usr/bin/python
# -*- coding: utf-8 -*-


import urllib
import urllib2
import sys
import json
import re

import yql
api_key = "77f1cc3b101c84e5c2694ff1ab73172b"

def get_json_flickr_yql(subject ):
 
    query_str = 'select * from flickr.photos.sizes where photo_id in (select id from flickr.photos.search where text=@text  and api_key=@api_key limit 100) and api_key =@api_key' 

    y = yql.Public() 
#     query = 'select * from flickr.photos.search where text=@text and api_key="77f1cc3b101c84e5c2694ff1ab73172b" limit 3';
    l = y.execute(query_str , {"text":subject ,"api_key":api_key})
    
    
    return l.rows
#     print json_str

def get_url_photo_id(url_str):
    """
    "http://www.flickr.com/photos/63028919@N07/8731761170/sizes/t/"
    """
    print url_str
               
    pattern = re.compile(r'(^<=[/]).*?(?=[/sizes])')#.*\/(\d*)\/size') 
    
    pattern = re.compile(r'.*[/](\d*)[/].*')
    m = pattern.findall(url_str)
    
    if m :
        print m
    
def get_json_flickr_yal_all(photo_dict ):
    
    subjects = ['supermaket' ,'girls']
    
    for subject in subjects:
        d = get_json_flickr_yql(subject)
        
        get_url_photo_id(d[0]['url'])
        
if __name__  == '__main__':
    
    d = {}
    get_json_flickr_yal_all(d)
    
    print "done it"