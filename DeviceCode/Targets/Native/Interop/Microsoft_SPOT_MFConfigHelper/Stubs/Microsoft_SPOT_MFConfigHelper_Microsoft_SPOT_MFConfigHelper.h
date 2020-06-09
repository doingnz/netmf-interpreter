//-----------------------------------------------------------------------------
//
//                   ** WARNING! ** 
//    This file was generated automatically by a tool.
//    Re-running the tool will overwrite this file.
//    You should copy this file to a custom location
//    before adding any customization in the copy to
//    prevent loss of your changes when the tool is
//    re-run.
//
//-----------------------------------------------------------------------------


#ifndef _MICROSOFT_SPOT_MFCONFIGHELPER_MICROSOFT_SPOT_MFCONFIGHELPER_H_
#define _MICROSOFT_SPOT_MFCONFIGHELPER_MICROSOFT_SPOT_MFCONFIGHELPER_H_

namespace Microsoft
{
    namespace SPOT
    {
        struct MFConfigHelper
        {
            // Helper Functions to access fields of managed object
            static INT8& Get_m_isDisposed( CLR_RT_HeapBlock* pMngObj )    { return Interop_Marshal_GetField_INT8( pMngObj, Library_Microsoft_SPOT_MFConfigHelper_Microsoft_SPOT_MFConfigHelper::FIELD__m_isDisposed ); }

            // Declaration of stubs. These functions are implemented by Interop code developers
            static INT8 WriteConfigBlock( LPCSTR param0, CLR_RT_TypedArray_UINT8 param1, HRESULT &hr );
            static INT8 ReadConfigBlock( LPCSTR param0, CLR_RT_TypedArray_UINT8 param1, HRESULT &hr );
            static INT8 InvalidateBlockWithName( LPCSTR param0, HRESULT &hr );
        };
    }
}
#endif  //_MICROSOFT_SPOT_MFCONFIGHELPER_MICROSOFT_SPOT_MFCONFIGHELPER_H_
