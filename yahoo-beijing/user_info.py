#!/usr/bin/python
# -*- coding: utf-8 -*-


class userData(object):
    
    def __init__(self):
        
        self.id = ""
        self.selfimg = set()
        self.favimg = set()
        self.taginfo = {}  #记录用户打的标签 和 数目\
        self.name = ""
        self.source = ""
        
#         self.l = []


"""

user_dict { user_id : userData}

user_dict[user_id].selfimg 


user_dict[user_id].taginfo[dsad] 
""" 