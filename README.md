# Notes about this Orthanc Server Admin

## Quick Start

1. You must create a folder /var/log/orthanc/ for Orthanc logs. Without this folder the server close automatically at start.
2. The Orthanc folder must be installed in /Applications/Orthanc/  Side by side to this app compiled.
3. The name of configuration JSON file of Orthanc server must be "configOSX.json". Any other name doesn't work at this time. This file must be placed at the same folder of Orthanc app.

## Few notes...

This program is a first approach to Admin Console for Orthanc server made with Swift language and XCode.

At this moment only start and stop Orthanc Server without use of terminal, but the paths  must be totally respected to work.


## Future additions

- Start Orthanc at computer start up.
- Edit configuration JSON file through preferences.
- Open log from app button.
- Detect Orthanc server status without errors.
