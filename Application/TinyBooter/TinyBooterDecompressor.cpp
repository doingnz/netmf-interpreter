////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) Microsoft Corporation.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include <tinyhal.h>

//--//

extern struct CompressedImage_Header TinyBooterCompressed_Dat;

typedef unsigned char UINT8;

int LZ77_Decompress( UINT8* inBuf, int inSize, UINT8* outBuf, int outSize );

HAL_DECLARE_NULL_HEAP();

typedef void (*APP_ENTRY_POINT)();

extern "C"
{
void BootEntryLoader()
{
    struct CompressedImage_Header* hdr  = &TinyBooterCompressed_Dat;
    void*                          data = &hdr[ 1 ];
    APP_ENTRY_POINT            AppEntry = (APP_ENTRY_POINT)hdr->Destination;

    LZ77_Decompress( (UINT8*)data, hdr->Compressed, (UINT8*)hdr->Destination, hdr->Uncompressed );

    CPU_FlushCaches();

    AppEntry();
}
}

void ApplicationEntryPoint()
{
}


// boot loader doesn't use the CMSIS-RTOS kernel, so sleep goes direct
// to the low level support
extern void HAL_CPU_Sleep( SLEEP_LEVEL level, UINT64 wakeEvents );

void CPU_Sleep( SLEEP_LEVEL level, UINT64 wakeEvents )
{
    HAL_CPU_Sleep( level, wakeEvents );
}
