#!/usr/bin/python
# -*- coding: utf-8 -*-


class photoData(object):
    
    def __init__(self ,d ):
        
        self.id = 0
        self.subject = {}
        self.width = d['width']
        self.height = d['heigth']
        self.source = d['source']
        self.title = ""
        
    