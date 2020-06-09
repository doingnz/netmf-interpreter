////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
//  Copyright (c) Nicolas Gallerand
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
using System;
using Microsoft.SPOT;

namespace Microsoft.SPOT
{
    /// <summary>
    /// User persistent data.
    /// <para>This class is a container for persistent data stored in flash memory (NETMF config block).</para>
    /// </summary>
    /// <example>
    /// </example>
    public class UserSettings
        {
        static private UserSettings _default;
        /// <summary>
        /// Get the default <see cref="UserSettings"/>
        /// </summary>
        static public UserSettings Default {
            get {
                if (_default == null)
                    _default = new UserSettings("USER_DEFAULT", 256);
                return _default;
                }
            }
        private String _name;
        /// <summary>
        /// Gets the configuration unique identifier
        /// </summary>
        public String Name {
            get { return _name; }
            }

        private byte[] _data;
        /// <summary>
        /// Gets the configuration data
        /// </summary>
        public byte[] Data {
            get { return _data; }
            }
        /// <summary>
        /// Initialize a new instance of <see cref="UserSettings"/>
        /// <para>Note to implementers: do not change Size when a config block is already existing in flash. Erase the flash and restore the firmware to delete existing config blocks.</para>
        /// </summary>
        /// <param name="name">Unique name for config block (63 characters max)</param>
        /// <param name="size">Config block size (bytes)</param>
        public UserSettings(String name, int size) {
            _name = name;
            _data = new byte[size];
            MFConfigHelper.ReadConfigBlock(_name, _data);
            }
        /// <summary>
        /// Gets the config Name
        /// </summary>
        /// <returns></returns>
        public override string ToString() {
            return "UserSettings[" + _name + "]";
            }
        /// <summary>
        /// Save the configuration data to flash memory
        /// </summary>
        /// <returns></returns>
        public bool Save() {
            return MFConfigHelper.WriteConfigBlock(_name, _data);
            }
        /// <summary>
        /// Load the configuration data from flash memory
        /// </summary>
        /// <returns></returns>
        public bool Load() {
            return MFConfigHelper.ReadConfigBlock(_name, _data);
            }

        }
    }
