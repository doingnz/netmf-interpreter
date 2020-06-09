#ifndef _INTERLOCKED_H_
#define _INTERLOCKED_H_ 1

#if defined(PLATFORM_ARM)

__inline INT32 InterlockedIncrement( volatile LONG* lpAddend )
{
    SmartPtr_IRQ irq;

    return ++(*lpAddend);
}


__inline INT32 InterlockedDecrement( volatile LONG* lpAddend )
{
    SmartPtr_IRQ irq;

    return --(*lpAddend);
}


__inline INT32 InterlockedExchange( volatile LONG* Target, INT32 Value )
{
    SmartPtr_IRQ irq;

    INT32 Result;

    Result  = *Target;
    *Target = Value;

    return Result;
}


__inline void* InterlockedCompareExchange( LONG** Destination, LONG* Exchange, LONG* Comperand )
{
    SmartPtr_IRQ irq;

    void* Result = *Destination;

    if(Result == Comperand)
    {
        *Destination = Exchange;
    }

    return Result;
}


__inline INT32 InterlockedExchangeAdd( volatile LONG* Addend, LONG Value )
{
    SmartPtr_IRQ irq;

    INT32 Result;

    Result    = (*Addend);
    (*Addend) = Result + Value;

    return Result;
}


__inline UINT32 InterlockedOr( volatile UINT32* Destination, UINT32 Flag )
{
    SmartPtr_IRQ irq;

    UINT32 Result = *Destination;

    if((Result & Flag) == 0)
    {
        *Destination = Result | Flag;
    }

    return Result;
}


__inline UINT32 InterlockedAnd( volatile LONG* Destination, LONG Flag )
{
    SmartPtr_IRQ irq;

    UINT32 Result = *Destination;

    if(Result & Flag)
    {
        *Destination = Result & Flag;
    }

    return Result;
}



//#else
//
//__inline UINT32 InterlockedSet( volatile UINT32* Destination, UINT32 Flag )
//{
//    return 0;
//}
//
//
//__inline UINT32 InterlockedUnset( volatile UINT32* Destination, UINT32 Flag )
//{
//    return 0;
//}


#endif // PLATFORM_ARM
#endif // _INTERLOCKED_H_
