## .NET Micro Framework Interpreter  

Welcome to a fork of the .NET Micro Framework interpreter GitHub repository. This repository includes a few code fixes and enhancements over the orginal .netMF. The most uptodate branch is VS2019. 

Sorry several changes all lumped into the last commit to this branch. 

## VS2019 VSIX
The project files are setup to create VS2019 VSIX installer and V4.4 of NetMF SDK

## SD Card and FAT above 2GB
The SD Card driver and FAT subsusytems have been updated with code kindly shared by the Mountaineer Group (Apache Licence 2.0). This is achived by changing the offset calcualtions from 32bit to 64bit values. The code has been running for some time in a netMF based device, however as a whole, SD Card support has limitations on netMF as it is slow (SPI) and limited error checking (i.e SD card FAT is easily corrupted). Large numbers of files in a folder can mek it painfully slow. 

## ARM9 support
Includes the satrtup code to support ARM9 (Device Solutions Meridian) with netMF 4.4

## Untested build / sdk
Currently this is the public branch of a private repo with a simple compare/merge of open source portions into the public branch. I have not tried this build on any other hardware and not attempted to build this code as found in the repo. You will need to merge the bits you want into your own repo. 

## Wiki Docs
Information on building the framework and internal development guides will appear on the [wiki](https://github.com/NETMF/netmf-interpreter/wiki). If you have content that is relevant to the NETMF development community that you would like to [contribute](https://github.com/NETMF/netmf-interpreter/wiki/Contributing) feel free to join in and participate in the future of the .NET Micro Framework. 
