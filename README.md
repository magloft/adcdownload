# XCode ADCDownload

Smart file downloader from Apple Developer downloads area

## Installation

This tool is packaged as a ruby gem. To install, run:

	$ gem install adcdownload

## Usage

All you need is a link to the download file (retrieve from https://developer.apple.com/download/more/)

	$ adcdownload get http://adcdownload.apple.com/Developer_Tools/Xcode_8/Xcode_8.xip

adcdownload will ask you for your Apple ID, which will be cached locally.
