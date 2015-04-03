#!/usr/bin/python
# -*- coding: utf-8 -*-

# This is part of the texworks-release scripts
# Copyright (C) 2013-2014  Stefan Löffler
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# For links to further information, or to contact the authors,
# see <https://github.com/stloeffler/texworks-release>.

import httplib2
import sys
import os.path
import magic

sys.path.append(sys.path[0] + "/..")
import build_config as config

import logging
from apiclient.discovery import build
from apiclient.http import MediaFileUpload
from oauth2client.client import OAuth2WebServerFlow
from oauth2client.file import Storage
from apiclient import errors

logging.basicConfig()

#httplib2.debuglevel = 4

CLIENT_ID = config.GOOGLE_CLIENT_ID
CLIENT_SECRET = config.GOOGLE_CLIENT_SECRET

# Check https://developers.google.com/drive/scopes for all available scopes
OAUTH_SCOPE = 'https://www.googleapis.com/auth/drive'

# Redirect URI for installed apps
REDIRECT_URI = 'urn:ietf:wg:oauth:2.0:oob'

# Base folder: 0B5iVT8Q7W44pMkNLblFjUzdQUVE
STABLE_FOLDERS = {'win': '0B5iVT8Q7W44pYzBwMjFBWGdVVHM', 'mac': '0B5iVT8Q7W44pMTY5YjNzZmdzS1U', 'src': '0B5iVT8Q7W44pNWNZd1VSaWNCUEU'}
LATEST_FOLDERS = {"win": "0B5iVT8Q7W44pNDlQVm9uRGpEWHc", 'mac': '0B5iVT8Q7W44pNUhPV2xhQUI5NVU', 'manual': '0B5iVT8Q7W44pQkRFVG5mQkt0S1U'}


def login():
	storage = Storage('googleCredentials.dat')
	credentials = storage.get()
	if not credentials:
		# Run through the OAuth flow and retrieve credentials
		flow = OAuth2WebServerFlow(CLIENT_ID, CLIENT_SECRET, OAUTH_SCOPE, redirect_uri = REDIRECT_URI)
		authorize_url = flow.step1_get_authorize_url()
		sys.stderr.write('\nGo to the following link in your browser: ' + authorize_url + '\n')
		sys.stderr.write('Enter verification code: ')
		code = raw_input().strip()
		credentials = flow.step2_exchange(code)
		storage.put(credentials)
	return credentials

def retrieve_all_files(service, query = None):
  """Retrieve a list of File resources.

  Args:
    service: Drive API service instance.
  Returns:
    List of File resources.
  """
  result = []
  page_token = None
  while True:
    try:
      param = {}
      if page_token:
        param['pageToken'] = page_token
      if query:
        param['q'] = query
      files = service.files().list(**param).execute()

      result.extend(files['items'])
      page_token = files.get('nextPageToken')
      if not page_token:
        break
    except errors.HttpError, error:
      print 'An error occurred: %s' % error
      break
  return result

#def getFolders(service):
#	return retrieve_all_files(service, "mimeType = 'application/vnd.google-apps.folder'")
#
#def getFolderId(folderData, path = [], rootId = None):
#	if len(path) == 0:
#		return rootId
#	for f in folderData:
##		print((f['parents'][0]['id'], rootId, f['title'], path[0]))
#		if f['title'] == path[0] and (f['parents'][0]['id'] == rootId or (f['parents'][0]['isRoot'] and rootId is None)):
#			return getFolderId(folderData, path[1:], f['id'])

def init():
	global drive_service, mime

	print("initializing...")

	mime = magic.open(magic.MAGIC_MIME_TYPE)
	mime.load()

	credentials = login()
	# Create an httplib2.Http object and authorize it with our credentials
	http = httplib2.Http()
	http = credentials.authorize(http)
	
	# Construct a Google Drive object
	drive_service = build('drive', 'v2', http=http)

def getMime(filename):
	global mime
	retVal = mime.file(filename)
	if retVal == 'application/x-dosexec':
		retVal = 'application/x-executable'
	return retVal

def archiveOldFiles(folderId):
	global drive_service
	
	archiveId = None
	files = retrieve_all_files(drive_service, "'%s' in parents" % folderId)
	# Find archive folder
	for f in files:
		if f['mimeType'] == 'application/vnd.google-apps.folder' and f['title'] == 'archive':
			archiveId = f['id']
			break
	if not archiveId is None and len(files) > 1:
		print("moving files...")
		for f in files:
			if f['mimeType'] == 'application/vnd.google-apps.folder': continue
			print("   moving '%s'" % f['title'])
			drive_service.parents().insert(fileId = f['id'], body = {'id': archiveId}).execute()
			drive_service.parents().delete(fileId = f['id'], parentId = folderId).execute()

def uploadFile(filename, folderId):
	global drive_service
	print("uploading '%s'" % filename)
	media_body = MediaFileUpload(filename, mimetype = getMime(filename))
	drive_service.files().insert(body = {'title': os.path.basename(filename), 'parents': [{'id': folderId}]}, media_body = media_body).execute()





if len(sys.argv) < 4:
	raise RuntimeError("Usage: googleDriveUpload <OS> <stable|latest> <filenames...>")

if sys.argv[2] == 'latest':
	folderId = LATEST_FOLDERS[sys.argv[1]]
elif sys.argv[2] == 'stable':
	folderId = STABLE_FOLDERS[sys.argv[1]]
else:
	raise RuntimeError("Type '%s' is not supported" % sys.argv[2])

init()
archiveOldFiles(folderId)
for f in sys.argv[3:]:
	uploadFile(f, folderId)

