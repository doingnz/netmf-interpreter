using System;
using System.Runtime.CompilerServices;

namespace Microsoft.SPOT
{
  //[StructLayout(LayoutKind.Sequential)]
  //public unsafe struct HAL_CONFIG_BLOCK
  //{
  //  public UInt32 Signature;
  //  public UInt32 HeaderCRC;
  //  public UInt32 DataCRC;
  //  public UInt32 Size;
  //  public fixed byte DriverName[64];

  //  public string DriverNameString
  //  {
  //    get
  //    {
  //      StringBuilder sb = new StringBuilder(66);

  //      fixed (byte* data = DriverName)
  //      {
  //        for (int i = 0; i < 64; i++)
  //        {
  //          if ((char)data[i] == '\0') break;
  //          sb.Append((char)data[i]);
  //        }
  //      }

  //      return sb.ToString();
  //    }

  //    set
  //    {
  //      fixed (byte* data = DriverName)
  //      {
  //        int len = value.Length;

  //        if (len > 64) len = 64;

  //        for (int i = 0; i < len; i++)
  //        {
  //          data[i] = (byte)value[i];
  //        }
  //      }
  //    }
  //  }


  //  //[MethodImplAttribute(MethodImplOptions.InternalCall)]
  //  //public static bool InvalidateBlockWithName(string name, bool isChipRO);

  //  //[MethodImplAttribute(MethodImplOptions.InternalCall)]
  //  //public static bool UpdateBlockWithName(string name, byte[] data, int length, bool isChipRO);

  //  //[MethodImplAttribute(MethodImplOptions.InternalCall)]
  //  //public static bool ApplyConfig(string name, object Address, int Length);

  //  //[MethodImplAttribute(MethodImplOptions.InternalCall)]
  //  //public static bool ApplyConfig(string name, object Address, int Length, void** newAlloc);
  //}



  public class MFConfigHelper : IDisposable
  {

    /// <summary>
    /// Create or update a user configuration block in flash memory 
    /// <para>The data buffer size must be constant for the specified name</para>
    /// </summary>
    /// <param name="name">Unique config ID (63 characters max)</param>
    /// <param name="data">Data buffer</param>
    /// <returns></returns>
    [MethodImplAttribute(MethodImplOptions.InternalCall)]
    internal static extern bool WriteConfigBlock(String name, byte[] data);
    /// <summary>
    /// Read a user configuration block in flash memory
    /// <para>The data buffer size must be constant for the specified name</para>
    /// </summary>
    /// <param name="name">Unique config ID (63 characters max)</param>
    /// <param name="data">Data buffer to update</param>
    /// <returns></returns>
    [MethodImplAttribute(MethodImplOptions.InternalCall)]
    internal static extern bool ReadConfigBlock(String name, byte[] data);

    #region IDisposable

    bool m_isDisposed = false;
    
    // Implement IDisposable.
    // Do not make this method virtual.
    // A derived class should not be able to override this method.
    public void Dispose()
    {
      Dispose(true);
      // This object will be cleaned up by the Dispose method.
      // Therefore, you should call GC.SupressFinalize to
      // take this object off the finalization queue
      // and prevent finalization code for this object
      // from executing a second time.
      GC.SuppressFinalize(this);
    }

    // Dispose(bool disposing) executes in two distinct scenarios.
    // If disposing equals true, the method has been called directly
    // or indirectly by a user's code. Managed and unmanaged resources
    // can be disposed.
    // If disposing equals false, the method has been called by the
    // runtime from inside the finalizer and you should not reference
    // other objects. Only unmanaged resources can be disposed.
    private void Dispose(bool disposing)
    {
      // Check to see if Dispose has already been called.
      if (!this.m_isDisposed)
      {
        // If disposing equals true, dispose all managed
        // and unmanaged resources.
        if (disposing)
        {
          try
          {
            // restart the clr if we weren't starting from tinybooter
            //if (m_fRestartClr && m_device.DbgEngine != null &&
            //    m_device.DbgEngine.ConnectionSource == Microsoft.SPOT.Debugger.ConnectionSource.TinyBooter
            //    )
            //{
            //    m_device.Execute(0);
            //}
          }
          catch
          {
          }
        }

        // Call the appropriate methods to clean up
        // unmanaged resources here.
        // If disposing is false,
        // only the following code is executed.
        try
        {
          //MaintainConnection = false;
        }
        catch
        {
        }

        // Note disposing has been done.
        m_isDisposed = true;

      }
    }

    ~MFConfigHelper()
    {
      Dispose(false);
    }

    #endregion

  }
}
