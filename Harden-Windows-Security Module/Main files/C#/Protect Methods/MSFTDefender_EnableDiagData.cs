using System;
using System.IO;
using System.Diagnostics;
using System.Collections.Generic;
using System.Linq;

#nullable enable

namespace HardenWindowsSecurity
{
    public partial class MicrosoftDefender
    {
        public static void MSFTDefender_EnableDiagData()
        {

            if (HardenWindowsSecurity.GlobalVars.path == null)
            {
                throw new System.ArgumentNullException("GlobalVars.path cannot be null.");
            }

            HardenWindowsSecurity.Logger.LogMessage("Enabling Optional Diagnostic Data");

            HardenWindowsSecurity.LGPORunner.RunLGPOCommand(System.IO.Path.Combine(HardenWindowsSecurity.GlobalVars.path, "Resources", "Security-Baselines-X", "Microsoft Defender Policies", "Optional Diagnostic Data", "registry.pol"), LGPORunner.FileType.POL);

        }
    }
}
