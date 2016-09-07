# SolidFire .NET SDK <img src="img/net.png" height="50" width="50" >

.NET SDK for interacting with SolidFire Element OS

## Current Release
Version 1.1.0.46

## Description
The SolidFire .NET SDK is a collection of libraries that facilitate integration and orchestration between proprietary systems and third-party applications. The .NET SDK allows developers to deeply integrate SolidFire system API with the C# or Visual Basic programming language. The SolidFire .NET SDK reduces the amount of additional coding time required for integration.

## Compatibility

| Component            | Version     |
|:--------------------:|:-----------:|
| .Net                 | 4.5         |
| SolidFire Element OS | 7.x and 8.x |

## Getting Help

If you have any questions or comments about this product, contact <ng-sf-host-integrations-sdk@netapp.com> or reach out to the online developer community at [ThePub](http://netapp.io). Your feedback helps us focus our efforts on new features and capabilities.

## Install via Nuget

To install SolidFire.SDK, run the following command in the Package Manager Console

```
Install-Package SolidFire.SDK
```

___Dependencies___:

| Component       | Version    |
|:---------------:|:----------:|
| Newtonsoft.Json | 8.0.0      |


## Documentation (v1.1)

[MSDN Docs](http://solidfire.github.io/sdk-dotnet/help/v1.1/html/R_Project_SolidFire__NET_SDK_Documentation.htm) 

[Release Notes](https://github.com/solidfire/sdk-dotnet/raw/gh-pages/Dot%20NET%20SDK%20Release%20Notes_v1.0.pdf)

## Examples

### Step 1 - Build a [SolidFireElement](help/v1.1/html/T_SolidFire_Element_Api_SolidFireElement.htm) object using the factory

This is the preferred way to construct the [SolidFireElement](help/v1.1/html/T_SolidFire_Element_Api_SolidFireElement.htm) object. The factory will make a call to the SolidFire cluster using the credentials supplied to test the connection. It will also set the version to communicate with based on the highest number supported by the SDK and Element OS. 

~~~ csharp
// Use ElementFactory to get a SolidFireElement object.
var sfe = ElementFactory.Create("ip-address-of-cluster", "username", "password");
~~~

### Step 2 - Create a request object if necessary

Methods in the SolidFireElement class can have multiple parameters and will need values supplied before calling it. There are three scenarios in which parameter needs are satisfied. They are: 

1. If there are zero (0) parameters, there is no Request object associated with the call (ie: `GetAPI()`).
1. If there is one (1) parameter, you can use a Request object or an overloaded version of the method which will take the single parameter (ie: `GetAccountByID(int accountID)`)
3. If there are two (2) or more parameters, you must use pass a Request object to the method.

~~~csharp
// Create a request object to add an account
var addAccountRequest = new AddAccountRequest()
{
    Username = "example-account"    // required - username of Account
};
~~~

### Step 3 - Call the API method and retrieve the result

All service methods in SolidFireElement call API endpoints syncronously and asyncronously.

_Send request and handle result Asyncronously_

~~~ csharp
// Send the Async request and await the returned Task
var addAccountResult = await sfe.AddAccountAsync(addAccountRequest, CancellationToken.None);
// Now pull the account ID from the result object
var accountID = accountResult.AccountID;
~~~

_Send request and handle result Syncronously_

~~~ csharp
// Send the request and wait for the result then pull the AccountID
var newAccountID = sfe.AddAccount(addAccountRequest).AccountID;   
~~~


### More examples using the SDK (C#)

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

            // ------- EXAMPLE 4 - MODIFY A VOLUME ASYNCRONOUSLY --------- //
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

## Roadmap

| Version | Release Date       | Notes                                                            |
|:------- |:------------------:|:----------------------------------------------------------------:|
| 1.0     | February 2, 2016   | Accounts, Volumes, Access Groups, Snapshots, and Group Snapshots |
| 1.1     | September 13, 2016 | Complete Nitrogen & Majority of Oxygen API Coverage              |
| 1.2     | ___TBD___          | Fluorine API Coverage                                            |

## License
Copyright © 2016 SolidFire, Inc. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions andlimitations under the License.
