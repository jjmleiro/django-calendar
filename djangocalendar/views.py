#!/usr/bin/env python
# Licensed to Cloudera, Inc. under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  Cloudera, Inc. licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from djangomako.shortcuts import render_to_response, render_to_string
from django.db import connection

import pymssql
import pyodbc
import sqlserver_ado.dbapi as mssql

import os
import settings

# index *******************************************************************************************************************
# Rev Date       Author
# --- ---------- ----------------------------------------------------------------------------------------------------------
# 001 2015-12-02 Jose Juan
#
# Index View.
#
# @author Jose Juan
# @date 2015-12-02
# @param request, HTTPRequest.
# @return -
# @remarks -
#
def index(request):
	sPath = settings.STATIC_URL + 'bd/test.mdf'
	row = ''

	if not os.path.isfile(sPath):
		#mssql
		#conn = mssql.connect("PROVIDER=SQLOLEDB;DATA SOURCE=livedemo.mylittleadmin.com/livedemo\\ss2005;Initial Catalog=SQL2005_254523_mla;Integrated Security=SSPI")
		conn = pymssql.connect(server='keediosqlserver.database.windows.net:1433', user='kadmin@keediosqlserver', password='Keedio2015', database='KEEDIOTEST')
		#pyodbc. settings.py database
		#cursor = connection.cursor()		

		#pyodbc
		sServer = 'localhost'
		sUID = ''
		sPwd = ''
		#conn = pyodbc.connect("DRIVER=FreeTDS;SERVER='%s';DATABASE='%s';UID='%s';PWD='%s'" % (sServer, sPath, sUID, sPwd))
		#conn = pyodbc.connect(driver='{SQL Server}', server=sServer, database=sPath, uid=sUID, pwd=sPwd)
		#conn = pyodbc.connect('Driver=FreeTDS;CHARSET=UTF8;TDS_Version=8.0;Server=livedemo.mylittleadmin.com/livedemo;port=1433;uid=mlademo;pwd=mlademo;database=SQL2005_254523_mla')

		#pymssql
		#conn = pymssql.connect('livedemo.mylittleadmin.com/livedemo', 'mlademo', 'mlademo', 'SQL2005_254523_mla')
		#conn = pymssql.connect('localhost', '', '', sPath)
		
		cursor = conn.cursor()
		#cursor.execute('SELECT c.CustomerID, c.CompanyName,COUNT(soh.SalesOrderID) AS OrderCount FROM SalesLT.Customer AS c LEFT OUTER JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID GROUP BY c.CustomerID, c.CompanyName ORDER BY OrderCount DESC;')		
		cursor.execute('SELECT * FROM Product;')
		row = cursor.fetchall()
		conn.close()

	return render_to_response('index.mako', {'Data': row })
#
# index *******************************************************************************************************************