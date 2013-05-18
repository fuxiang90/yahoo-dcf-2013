#!/usr/bin/python
# coding: utf-8 -*-





import sys
import json
import re

import yql
import photo
import user_info
import yql_function


def check_json_dict():
    d = {'kjkjj':1 ,'jjj':2}
    encodedjson = json.dumps(d)
    
    print encodedjson


if __name__ == '__main__':
    check_json_dict()
    
    print "done it"