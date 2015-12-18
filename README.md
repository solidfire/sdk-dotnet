# SolidFire C# .Net SDK <img src="http://solidfire.github.io/sdk-dotnet/img/icon_128x128.png" height="50" width="50" >

C# SDK for interacting with SolidFire Element OS

##Current Release
Version 0.9

##Description
The SolidFire C# SDK is a collection of software modules and libraries that facilitate integration and orchestration between proprietary systems and third-party applications. The C# SDK allows developers to deeply integrate SolidFire system API with the Java programming language. The SolidFire C# SDK reduces the amount of additional coding time required for integration.

##Compatibility
| Component    | Version           |
| ------------ | ----------------- |
| .Net         | 4.5               |
| SolidFire OS | Element 7.x & 8.x |

##Getting Help
Contacting SolidFire SDK Support
If you have any questions or comments about this product, contact <sdk@solidfire.com> or reach out to the developer community at [developer.solidfire.com](http://developer.solidfire.com). Your feedback helps us focus our efforts on new features and capabilities.

##Install via Nuget

To install SolidFire.Element, run the following command in the Package Manager Console

```
Install-Package SolidFire.Element
```

___Dependencies___:

| Component       | Version 	 |
| --------------- | ---------- |
| SolidFire.Core  | 0.9.0.24   |
| Newtonsoft.Json | 7.0.1      |


##Documentation (v1.0)

[User Guide ** need link](http://solidfire.github.io/sdk-dotnet)

[MSDN Docs](http://solidfire.github.io/sdk-dotnet/help/v1.1/html/N_SolidFire_Element.htm) 

[Release Notes ** need link](http://solidfire.github.io/sdk-dotnet)

##Examples
###Examples of using the API (C#)
```c#
using SolidFire.Element;
using SolidFire.Element.Api;
using System.Collections.Generic;
using System.Linq;
using System.Net;

namespace DotNetSDKExamples
{
    public class CSharpDotNetExample
    {
        static void Main(string[] args)
        {
            // Create Connection to SF Cluster
            var sfe = ElementFactory.Create("mvip", new NetworkCredential("username", "password"), "8.0");

            // Create some accounts
            var addAccountRequest = new AddAccountRequest()
            {
                Username = "username"                       // required - username of Account
            };
            // Run the Async request and wait for the result then pull the AccountID
            var accountID = sfe.AddAccountAsync(addAccountRequest).Result.AccountID;

            // Add a volume with default QoS
            var createVolumeRequest = new CreateVolumeRequest()
            {
                Name = "volumename",                        // required - name to give the new Volume
                AccountID = accountID,                      // required - ID of Account that owns Volume
                TotalSize = 1000000000l,                    // required - size of Volume in bytes
                Enable512e = false                          // required - should Volume provide 512-byte sector emulation
            };
            // Run the Async request and wait for the result then pull the VolumeID
            var volumeID = sfe.CreateVolumeAsync(createVolumeRequest).Result.VolumeID;

            var listVolumesRequest = new ListVolumesRequest(){
                Accounts = new List<long>().Add(accountID), // optional - AccountID to filter volumes by account
                StartVolumeID = volumeID,                   // optional - ID to start list of returned Volumes
                Limit = 1                                   // optional - to limit the number of Volumes with IDs greater than StartVolumeID
            };
            // Run the Async request and wait for the result then pull Iqn of the first Volume returned
            var iqn = sfe.ListVolumesAsync(listVolumesRequest).Result.Volumes.First().Iqn;

            var modifyVolumeRequest = new ModifyVolumeRequest(){
                VolumeID = volumeID,                        // required - ID of Volume to modify
                TotalSize = 2000000000l                     // optional - new TotalSize of Volume
            }
            // Start the async request to modify the volume
            var task = sfe.ModifyVolumeAsync(modifyVolumeRequest);
            task.Wait(); // wait for the task to finish
        }
    }
}
```

###Examples of using the API (VB)
```Visual Basic.NET 
{
    coming soon
}
```

##Roadmap
| Version | Release Date      | Notes                                                            |
| ------- | ----------------- | ---------------------------------------------------------------- |
| 1.0     | January 20, 2016  | Accounts, Volumes, Access Groups, Snapshots, and Group Snapshots |
| 1.1     | ___TBD___         | Complete Nitorgen & Oxygen API Coverage                          |
| 1.2     | ___TBD___         | Fluorine API Coverage                                            |

##License
Copyright © 2016 SolidFire, Inc. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions andlimitations under the License.
