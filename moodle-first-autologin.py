#!/usr/bin/python
# -*- coding: utf-8 -*-

#################################################################################################

import os
import sys
import ldap
import ast
import subprocess
import csv

import requests
import re

# Python3 duen sistema baten exekutatu script hau

with open('erabiltzaile-zerrenda.csv') as csvarchivo:
    entrada = csv.DictReader(csvarchivo)
    for reg in entrada:
        login = reg['Erabiltzailea']
        passwd = reg['Pasahitza']

        r = requests.get("https://moodle.imh.eus/login/index.php")
        cookie = r.cookies.get_dict()
        pattern = '<input type="hidden" name="logintoken" value="\w{32}">'
        token = re.findall(pattern, r.text)
        token = re.findall("\w{32}", token[0])
        payload = {'username': login, 'password': passwd, 'anchor': '', 'logintoken': token[0]}
        r = requests.post("https://moodle.imh.eus/login/index.php", cookies=cookie, data=payload)
        print(r)
