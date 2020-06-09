////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) Microsoft Corporation.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef _CPU_H_
#define _CPU_H_ 1

//--//
#if   defined ( __CC_ARM )
  #define __ASM            __asm                                      /*!< asm keyword for ARM Compiler          */
  #define __INLINE         __inline                                   /*!< inline keyword for ARM Compiler       */
  #define __STATIC_INLINE  static __inline

#elif defined ( __GNUC__ )
  #define __ASM            __asm                                      /*!< asm keyword for GNU Compiler          */
  #define __INLINE         inline                                     /*!< inline keyword for GNU Compiler       */
  #define __STATIC_INLINE  static inline

#elif defined ( __ICCARM__ )
  #define __ASM            __asm                                      /*!< asm keyword for IAR Compiler          */
  #define __INLINE         inline                                     /*!< inline keyword for IAR Compiler. Only available in High optimization mode! */
  #define __STATIC_INLINE  static inline

#elif defined ( __TMS470__ )
  #define __ASM            __asm                                      /*!< asm keyword for TI CCS Compiler       */
  #define __STATIC_INLINE  static inline

#elif defined ( __TASKING__ )
  #define __ASM            __asm                                      /*!< asm keyword for TASKING Compiler      */
  #define __INLINE         inline                                     /*!< inline keyword for TASKING Compiler   */
  #define __STATIC_INLINE  static inline

#elif defined ( __CSMC__ )
  #define __packed
  #define __ASM            _asm                                      /*!< asm keyword for COSMIC Compiler      */
  #define __INLINE         inline                                    /*use -pc99 on compile line !< inline keyword for COSMIC Compiler   */
  #define __STATIC_INLINE  static inline

#endif
#include <tinyhal.h>
#include <stdint.h> 
//--//

#include "ARM_util.h"

#include "CPU_definitions.h"
/*****************************
#if defined(JTAG_DEBUGGING)
#include "DCC_decl.h"
#endif

__STATIC_INLINE uint32_t ITM_SendChar(uint32_t ch)
{
#if TOTAL_DCC_PORT > 0

	const char Data = (char)ch;
	int ComPortNum = 0;
	ItmPort_Write(0, &Data, sizeof(Data));

#else //TOTAL_DCC_PORT >=0
	// discard for now!
#endif
	return ch;
}
***************/
//--//

#endif  // _CPU_H_
