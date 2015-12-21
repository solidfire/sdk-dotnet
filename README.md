# SolidFire .NET SDK <img src="http://solidfire.github.io/sdk-dotnet/img/icon_128x128.png" height="50" width="50" >

.NET SDK for interacting with SolidFire Element OS

##Current Release
Version 0.9

##Description
The SolidFire .NET SDK is a collection of libraries that facilitate integration and orchestration between proprietary systems and third-party applications. The .NET SDK allows developers to deeply integrate SolidFire system API with the C# or Visual Basic programming language. The SolidFire .NET SDK reduces the amount of additional coding time required for integration.

##Compatibility
| Component    | Version           |
| ------------ | ----------------- |
| .Net         | 4.5               |
| SolidFire OS | Element 7.x & 8.x |

##Getting Help

If you have any questions or comments about this product, contact <sdk@solidfire.com> or reach out to the developer community at [developer.solidfire.com](http://developer.solidfire.com). Your feedback helps us focus our efforts on new features and capabilities.

##Install via Nuget

To install SolidFire.Element, run the following command in the Package Manager Console

```
Install-Package SolidFire.Element
```

___Dependencies___:

| Component       | Version    |
| --------------- | ---------- |
| SolidFire.Core  | 0.9.0.24   |
| Newtonsoft.Json | 7.0.1      |


##Documentation (v1.0)

[User Guide ** need link](http://solidfire.github.io/sdk-dotnet)

[MSDN Docs](http://solidfire.github.io/sdk-dotnet/help/v1.1/html/N_SolidFire_Element.htm) 

[Release Notes ** need link](http://solidfire.github.io/sdk-dotnet)

##Examples

###Step 1 - Get a SolidFireElement object

_Build a SolidFireElement using the factory (C#)_

```c#
    // *** This is the PREFERRED way to construct the object. ***
    // Use ElementFactory to get a SolidFireElement object.
    // When you do this, the factory will make a call to the SolidFire cluster
    // using the credentials supplied to test the connection.
    var solidfireElement = ElementFactory.Create("mvip", new NetworkCredential("username", "password"), "8.0");
```

_Construct a SolidFireElement (C#)_

```c#
    // Use JsonRpcDispatcher object to construct a SolidFireElement object.
    // This will construct the SolidFireElement object without any additional checking 
    // of the credentials and endpoint.
    var dispatcher = new JsonRpcRequestDispatcher(new Uri("mvip"), new NetworkCredential("userName", "password"));
    var solidfireElement = new SolidFireElement(dispatcher);
```

###Step 2 - Create a request object if necessary (C#)
```c#
    // Create a request object to be sent in to the AddAccount method
    var addAccountRequest = new AddAccountRequest()
    {
        Username = "username"    // required - username of Account
    };
```

###Step 3 - Call the API method and retrieve the result (C#)

All service methods in SolidFireElement call API endpoints asyncronously. You can handle the returned task in a multi-threaded manner or call *.Result* on it to block and wait.

_Call Asyncronously_

```c#
    // Run the Async request and and assign the returned Task to a variable
    var addAccountTask = solidfireElement.AddAccountAsync(addAccountRequest);
    // Perform any manner of task handling here.
    var accountID = addAccountTask.GetAwaiter().GetResult().AccountID   
```

_Call Syncronously_

```c#
    // Run the Async request and wait for the result then pull the AccountID
    var accountID = solidfireElement.AddAccountAsync(addAccountRequest).Result.AccountID;    
```


###Full Example of using the API (C#)
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

###Full Examples of using the API (VB)

```vb 
Imports SolidFire.Element
Imports SolidFire.Element.Api
Imports System.Collections.Generic
Imports System.Linq
Imports System.Net

Public Class VBDotNetSDKExample
    Shared Sub Main()

        ' Create NetworkCredential
        Dim cred = New NetworkCredential("username", "password")

        ' Create Connection to SF Cluster
        Dim sfe = ElementFactory.Create("mvip", cred, "8.0")

        ' Create some accounts
        Dim addAccountRequest = New AddAccountRequest()
        addAccountRequest.Username = "username"             'required - username of Account


        ' Run the Async request and wait for the result then pull the AccountID
        Dim accountID = sfe.AddAccountAsync(addAccountRequest).Result.AccountID

        ' Add a volume with default QoS
        Dim createVolumeRequest = New CreateVolumeRequest()
        createVolumeRequest.Name = "volumename"             ' required - name to give the new Volume
        createVolumeRequest.AccountID = accountID           ' required - ID of Account that owns Volume
        createVolumeRequest.TotalSize = 1000000000L         ' required - size of Volume in bytes
        createVolumeRequest.Enable512e = False              ' required - should Volume provide 512-byte sector emulation


        ' Run the Async request and wait for the result then pull the VolumeID
        Dim volumeID = sfe.CreateVolumeAsync(createVolumeRequest).Result.VolumeID

        Dim listVolumesRequest = New ListVolumesRequest()
        Dim accounts = New List(Of Long)
        accounts.Add(accountID)
        listVolumesRequest.Accounts = accounts.ToArray()   ' optional - AccountID to filter volumes by account
        listVolumesRequest.StartVolumeID = volumeID        ' optional - ID to start list of returned Volumes
        listVolumesRequest.Limit = 1                       ' optional - to limit the number of Volumes with IDs greater than StartVolumeID

        ' Run the Async request and wait for the result then pull Iqn of the first Volume returned
        Dim iqn = sfe.ListVolumesAsync(listVolumesRequest).Result.Volumes.First().Iqn

        Dim modifyVolumeRequest = New ModifyVolumeRequest()
        modifyVolumeRequest.VolumeID = volumeID            ' required - ID of Volume to modify
        modifyVolumeRequest.TotalSize = 2000000000L        ' optional - new TotalSize of Volume

        ' Start the async request to modify the volume
        Dim task = sfe.ModifyVolumeAsync(modifyVolumeRequest)
        task.Wait() ' wait for the task to finish

    End Sub
End <CENTER></CENTER>lass
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
