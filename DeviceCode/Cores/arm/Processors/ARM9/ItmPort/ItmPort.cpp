#include <tinyhal.h>


#if 0//!defined(JTAG_DEBUGGING) // DS5 as tool
// only one "generic" port supported for DCC tracing messages to hardware debugger
// so pInstance is ignored
static int ItmPort_Write( void* pInstance, const char* Data, size_t size )
{
    for( int i = 0; i< size; ++i )
        ITM_SendChar( Data[i] );
    
    return size;


}
#else
static int IsDebuggerAttached = 1;

int ItmPort_Write(void* pInstance, const char* Data, size_t size)
{

	NATIVE_PROFILE_PAL_COM();
	int         totWrite = 0;

	if (IsDebuggerAttached == 0) return -1; // no debugger

	//if ((ComPortNum < 0) || (ComPortNum >= TOTAL_DCC_PORT)) { ASSERT(FALSE); return -1; }
	if (0 == size)                 return 0;
	if (NULL == Data) { ASSERT(FALSE); return -1; }

	// Keep interrupts off to keep queue access atomic
	GLOBAL_LOCK(irq);
	int uSec = 10;
	// iterations must be signed so that negative iterations will result in the minimum delay

	uSec *= (SYSTEM_CYCLE_CLOCK_HZ / CLOCK_COMMON_FACTOR);
	uSec /= (ONE_MHZ / CLOCK_COMMON_FACTOR);

	// iterations is equal to the number of CPU instruction cycles in the required time minus
	// overhead cycles required to call this subroutine.
	int iterations = (int)uSec - 12;      // Subtract off call & calculation overhead

	volatile UINT32 reg0, reg1, reg2, reg3;

	reg1 = uSec;


	while (totWrite < size)
	{
		reg2 = 5; // retries

		do
		{
			__asm
			{
				MRC   p14, 0, reg3, c0, c0, 0     //; Read Debug Status and Control Register
			}

			// if W SET, register still full, CLEAR then empty.
			if ((reg3 & 0x2) == 0)
			{
				// register empty, can write next data item. 
				reg0 = Data[totWrite];

				__asm
				{
					//dcc_write:
					MCR   p14, 0, reg0, c1, c0, 0     //; Write word from r0
				}

				break; // no need to retry
			}
			else
			{
				// have we waited long enough?
				if (--reg2 > 0)
				{
					// wait again, then try again. 
					CYCLE_DELAY_LOOP(iterations);
					continue;
				}
				else
				{
					// Give up and flag no debugger attached. 
					IsDebuggerAttached = 0;

					return -1;
				}
			}

		} while (reg2 >0);


		totWrite++;
	}

	return totWrite;
}
#endif


static IGenericPort const ItmPortItf =
{
    // default returns TRUE
    NULL, //BOOL (*Initialize)( void* pInstance );
    
    // default returns TRUE
    NULL, //BOOL (*Uninitialize)( void* pInstance );
    
    // default return 0
    ItmPort_Write, //int (*Write)( void* pInstance, const char* Data, size_t size );
    
    // defualt return 0
    NULL, //int (*Read)( void* pInstance, char* Data, size_t size );
    
    // default return TRUE
    NULL, //BOOL (*Flush)( void* pInstance );
    
    // default do nothing
    NULL, //void (*ProtectPins)( void* pInstance, BOOL On ); 
    
    // default return FALSE
    NULL, //BOOL (*IsSslSupported)( void* pInstance );
    
    // default return FALSE
    NULL, //BOOL (*UpgradeToSsl)( void* pInstance, const UINT8* pCACert, UINT32 caCertLen, const UINT8* pDeviceCert, UINT32 deviceCertLen, LPCSTR szTargetHost );
    
    // default return FALSE
    NULL, //BOOL (*IsUsingSsl)( void* pInstance );
};

extern const GenericPortTableEntry Itm0GenericPort =
{
    ItmPortItf,
    NULL
};
