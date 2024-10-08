using System;
using System.IO;
using Microsoft.Win32;

#nullable enable

namespace HardenWindowsSecurity
{
    public class WindowsUpdateConfigurations
    {
        public static void Invoke()
        {
            if (HardenWindowsSecurity.GlobalVars.path == null)
            {
                throw new System.ArgumentNullException("GlobalVars.path cannot be null.");
            }

            HardenWindowsSecurity.Logger.LogMessage("Running the Windows Update category");

            HardenWindowsSecurity.Logger.LogMessage("Enabling restart notification for Windows update");
            HardenWindowsSecurity.RegistryEditor.EditRegistry(@"Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings", "RestartNotificationsAllowed2", "1", "DWORD", "AddOrModify");

            HardenWindowsSecurity.Logger.LogMessage("Applying the Windows Update Group Policies");
            HardenWindowsSecurity.LGPORunner.RunLGPOCommand(System.IO.Path.Combine(HardenWindowsSecurity.GlobalVars.path, "Resources", "Security-Baselines-X", "Windows Update Policies", "registry.pol"), LGPORunner.FileType.POL);

        }
    }
}
