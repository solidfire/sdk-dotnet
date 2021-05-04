# SolidFire .NET SDK

![Net Logo](img/net-50.png) 

## Description
The SolidFire .NET SDK is a collection of libraries that facilitate integration and orchestration between proprietary systems and third-party applications. The .NET SDK allows developers to deeply integrate SolidFire system API with the C# or Visual Basic programming language. The SolidFire .NET SDK reduces the amount of additional coding time required for integration.


## Installation

To install SolidFire.SDK, run the following command in the Package Manager Console

```
Install-Package SolidFire.SDK
```

**Dependencies** (automatically downloaded upon install):

| Component       | Version    |
|:---------------:|:-----------|
| Newtonsoft.Json | 11.0.2      |

## Compatibility

| Component                          | Version     |
|:-----------------------------------|:------------|
| .NET Core                          | 2.2         |
| SolidFire Element OS               | 11.8 - 12.3 |

## Documentation

[MSDN Docs](http://solidfire.github.io/sdk-dotnet/help/html/R_Project_NetApp_SolidFire__NET_SDK_Documentation.htm) 

[Release Notes](NetApp_Element_.NET_SDK_12.3_Release_Notes.pdf)

## Getting Help

If you have any questions or comments about this product, open an issue on our [GitHub repo](https://github.com/solidfire/sdk-dotnet) or reach out to the online developer community at [ThePub](http://netapp.io). Your feedback helps us focus our efforts on new features and capabilities.

## Instructions

### Step 1 - Build a [SolidFireElement](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_SolidFireElement.htm) object using the [ElementFactory](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_ElementFactory.htm)

This is the preferred way to construct the [SolidFireElement](help/html/T_SolidFire_Element_Api_SolidFireElement.htm) object. The [ElementFactory](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_ElementFactory.htm) will make a call to the SolidFire cluster using the credentials supplied to test the connection. It will also set the version to communicate with based on the highest number supported by the SDK and Element OS if not supplied. 

~~~ csharp
// Use ElementFactory to get a SolidFireElement object.
var sfe = ElementFactory.Create("ip-address-of-cluster", "username", "password");
~~~

### Step 2 - Create a request object if necessary

Methods in the [SolidFireElement](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_SolidFireElement.htm) class can have multiple parameters and will need values supplied before calling it. There are three scenarios in which parameter needs are satisfied. They are: 

1. If there are zero (0) parameters, there is no Request object associated with the call (eg: [`GetAPI()`](http://solidfire.github.io/sdk-dotnet/help/html/M_SolidFire_Element_Api_SolidFireElement_GetAPI.htm)).
1. If there is one (1) parameter, you can use a Request object or an overloaded version of the method which will take the single parameter (eg: [`GetAccountByID(int accountID)`](http://solidfire.github.io/sdk-dotnet/help/html/M_SolidFire_Element_Api_SolidFireElement_GetAccountByID_1.htm))
3. If there are two (2) or more parameters, you must use a Request object to the method. Here is an example:

~~~csharp
// Create a request object to add an account
var addAccountRequest = new AddAccountRequest()
{
    Username = "example-account"    // required - username of Account
};
~~~

### Step 3 - Call the API method and retrieve the result

All service methods in [SolidFireElement](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_SolidFireElement.htm) call API endpoints synchronously and asynchronously.

_Send request and handle result Asynchronously_

~~~ csharp
// Send the Async request and await the returned Task
var addAccountResult = await sfe.AddAccountAsync(addAccountRequest, CancellationToken.None);
// Now pull the account ID from the result object
var accountID = accountResult.AccountID;
~~~

_Send request and handle result Synchronously_

~~~ csharp
// Send the request and wait for the result then pull the AccountID
var newAccountID = sfe.AddAccount(addAccountRequest).AccountID;   
~~~


### Examples using the SDK (C#)

~~~ csharp
using SolidFire.Element;
using SolidFire.Element.Api;
using System.Linq;
using System.Threading;

namespace SolidFire.SDK.Examples
{
    class ExampleProgram
    {
        static void Main(string[] args)
        {
            // ------- FIRST STEP --------- //
            // Create Connection to SF Cluster
            var sfe = ElementFactory.Create("ip-address-of-cluster", "username", "password");

            // ------- EXAMPLE 1 - CREATE AN ACCOUNT --------- //
            // Create a request object to add an account
            var addAccountRequest = new AddAccountRequest()
            {
                Username = "example-account"    // required - username of Account
            };
            // Send the request and gather the result
            var addAccountResult = sfe.AddAccount(addAccountRequest);
            // Pull the account ID from the result object
            var newAccountID = addAccountResult.AccountID;

            // ------- EXAMPLE 2 - CREATE A VOLUME --------- //
            // Create a request object to add a volume
            var createVolumeRequest = new CreateVolumeRequest()
            {
                Name = "example-volume",       // required - name to give the new Volume
                AccountID = newAccountID,      // required - ID of Account that owns Volume
                TotalSize = 1000000000,        // required - size of Volume in bytes
                Enable512e = false             // required - should Volume provide 512-byte sector emulation
            };
            // Send the request and wait for the result object
            var createVolumeResult = sfe.CreateVolume(createVolumeRequest);
            // Pull the VolumeID off the result object
            var volumeID = createVolumeResult.VolumeID;

            // ------- EXAMPLE 3 - LIST ONE VOLUME FOR AN ACCOUNT --------- //
            // Create a request object to list volumes for a specific account
            var listVolumesRequest = new ListVolumesRequest()
            {
                Accounts = new long[] { newAccountID },   // optional - AccountID to filter volumes by account 
                Limit = 1                                 // optional - to limit the number of Volumes with IDs greater than StartVolumeID
            };
            // Send the request and wait for the result then pull Iqn of the first Volume returned
            var iqn = sfe.ListVolumes(listVolumesRequest).Volumes.First().Iqn;

            // ------- EXAMPLE 4 - MODIFY A VOLUME ASYNCHRONOUSLY --------- //
            // Create a request object to modify a volume
            var modifyVolumeRequest = new ModifyVolumeRequest()
            {
                VolumeID = volumeID,      // required - ID of Volume to modify
                TotalSize = 2000000000    // optional - new TotalSize of Volume
            };
            // Async Example - Send the request to modify the volume and hold onto the task
            var task = sfe.ModifyVolumeAsync(modifyVolumeRequest, CancellationToken.None);
            // wait for the task to finish
            task.Wait();
        }
    }
}
~~~

### [More Examples](examples)

For more examples check out the tutorials in the [examples folder](examples) of this repo.

## License
Copyright © 2021 NetApp, Inc. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
