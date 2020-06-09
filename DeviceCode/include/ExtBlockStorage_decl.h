////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Portions Copyright (c) Microsoft Corporation.  All rights reserved.
// Portions Copyright [2015] [Mountaineer]
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#include <BlockStorage_decl.h>

#ifndef _DRIVERS_PAL_EXTBLOCKSTORAGE_H_
#define _DRIVERS_PAL_EXTBLOCKSTORAGE_H_ 1


/////////////////////////////////////////////////////////
// Description:
//    This structure defines an interface for block devices with secotr addresses
// 
// Remarks:
//    It is possible a given system might have more than one
//    storage device type. This interface abstracts the
//    hardware sepcifics from the rest of the system.
//
//    All of the functions take at least one void* parameter
//    that normally points to a driver specific data structure
//    containing hardware specific settings to use. This
//    allows a single driver to support multiple instances of
//    the same type of storage device in the system.
//
//    The sector read and write functions provide a parameter
//    for Sector Metadata. The metadata is used for flash arrays
//    without special controllers to manage wear leveling etc...
//    (mostly for directly attached NOR and NAND). The metadata
//    is used by upper layers for wear leveling to ensure that
//    data is moved around on the flash when writing to prevent
//    failure of the device from too many erase cycles on a sector. 
// 
// TODO:
//    Define standard method of notification that media is
//    removed for all removeable media. This will likely
//    be a continuation so that the FS Manager can mount 
//    an FS and then notify the managed app of the new FS.
//
struct IExtBlockStorageDevice
{
    // same as IBlockStorageDevice
    BOOL (*InitializeDevice)(void*);
    BOOL (*UninitializeDevice)(void*);
    const BlockDeviceInfo*  (*GetDeviceInfo)(void*);
    BOOL (*Read)(void*, ByteAddress StartSector, UINT32 NumBytes, BYTE* pSectorBuff);
    BOOL (*Write)(void*, ByteAddress Address, UINT32 NumBytes, BYTE* pSectorBuf, BOOL ReadModifyWrite);
    BOOL (*Memset)(void*, ByteAddress Address, UINT8 Data, UINT32 NumBytes);
    BOOL (*GetSectorMetadata)(void*, ByteAddress SectorStart, SectorMetadata* pSectorMetadata);
    BOOL (*SetSectorMetadata)(void*, ByteAddress SectorStart, SectorMetadata* pSectorMetadata);
    BOOL (*IsBlockErased)(void*, ByteAddress BlockStartAddress, UINT32 BlockLength);
    BOOL (*EraseBlock)(void*, ByteAddress Address);
    void (*SetPowerState)(void*, UINT32 State);
    UINT32 (*MaxSectorWrite_uSec)(void*);
    UINT32 (*MaxBlockErase_uSec)(void*);
    
    BOOL (*ExtRead)(void*, UINT64 Address, UINT32 NumBytes, BYTE* pSectorBuff);
    BOOL (*ExtWrite)(void*, UINT64 Address, UINT32 NumBytes, BYTE* pSectorBuf, BOOL ReadModifyWrite);
};


struct ExtBlockStorageDevice : BlockStorageDevice
{
    // m_BSD points to IExtBlockStorageDevice

public:

    BOOL ExtRead(UINT64 Address, UINT32 NumBytes, BYTE* pSectorBuf) 
    {
		if (Address < 0x100000000ul) {
			return this->m_BSD->Read(this->m_context, (ByteAddress)Address, NumBytes, pSectorBuf);
		} else {
			return ((IExtBlockStorageDevice*)this->m_BSD)
						->ExtRead(this->m_context, Address, NumBytes, pSectorBuf);
		}
	}
    
    BOOL ExtWrite(UINT64 Address, UINT32 NumBytes, BYTE* pSectorBuf, BOOL ReadModifyWrite) 
    {
		if (Address < 0x100000000ul) {
			return this->m_BSD->Write(this->m_context, (ByteAddress)Address, NumBytes, pSectorBuf, ReadModifyWrite);
		} else {
		    return ((IExtBlockStorageDevice*)this->m_BSD)
						 ->ExtWrite(this->m_context, Address, NumBytes, pSectorBuf, ReadModifyWrite);
		}
    }
    
};


//--//

#endif // #if define _DRIVERS_PAL_EXTBLOCKSTORAGE_H_

