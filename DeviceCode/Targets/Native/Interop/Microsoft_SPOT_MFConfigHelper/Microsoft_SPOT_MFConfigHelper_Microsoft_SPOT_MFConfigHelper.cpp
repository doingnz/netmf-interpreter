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


#include "Microsoft_SPOT_MFConfigHelper.h"
#include "Microsoft_SPOT_MFConfigHelper_Microsoft_SPOT_MFConfigHelper.h"

using namespace Microsoft::SPOT;

INT8 MFConfigHelper::WriteConfigBlock( LPCSTR name, CLR_RT_TypedArray_UINT8 data, HRESULT &hr )
{
	return HAL_CONFIG_BLOCK::UpdateBlockWithName(name, data.GetBuffer(), data.GetSize(), TRUE);
}

INT8 MFConfigHelper::ReadConfigBlock( LPCSTR name, CLR_RT_TypedArray_UINT8 data, HRESULT &hr )
{
	return HAL_CONFIG_BLOCK::ApplyConfig(name, data.GetBuffer(), data.GetSize());
}

INT8 MFConfigHelper::InvalidateBlockWithName( LPCSTR name, HRESULT &hr )
{
    return HAL_CONFIG_BLOCK::UpdateBlockWithName(name, NULL, 0, TRUE);
}

