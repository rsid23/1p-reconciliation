# -*- coding: utf-8 -*-
"""
Created on Fri Aug 11 13:32:07 2023

@author: catalin
"""
import pyotp

USER='reporting@iderive.com'
PASS='Romeo!xx'
MFA = pyotp.TOTP('TZ3COKIVQWHTEPDLQRQ6KX45RUGKB3V3GEVO2ATP77I7XXSRBPXA')
