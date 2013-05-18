#!/usr/bin/python
# -*- coding: utf-8 -*-


class photoData(object):
    
    def __init__(self ):
        
        self.id = 0
        self.subject = {}
        self.taginfo = {} # tag : user 
        self.width = 0
        self.height = 0
        self.source = ""
        self.title = ""
        
    def set_width_heigth(self,d):
        self.width = d['width']
        self.height = d['heigth']
        self.source = d['source']