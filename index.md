---
title: Solidfire C# .Net SDK
layout: index
---

# SolidFire C# .Net SDK <img src="http://solidfire.github.io/sdk-dotnet/img/icon_128x128.png" height="50" width="50" >

C# SDK for interacting with SolidFire Element OS

##Current Release
Version 1.0

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
| SolidFire.Core  | 1.0.0.x    |
| Newtonsoft.Json | 7.0.1      |


##Documentation (v1.0)

[User Guide ** need link](http://solidfire.github.io/sdk-dotnet)

[MSDN Docs](http://solidfire.github.io/sdk-dotnet/help/v1.1/html/N_SolidFire_Element.htm) 

[Release Notes ** need link](http://solidfire.github.io/sdk-dotnet)

##Examples
###Examples of using the API (C#)
```java
import com.solidfire.javautil.Optional;

// Import Optional common empty types (String, Long, & Map)
import static com.solidfire.javautil.Optional.*;

public class ReadmeJavaExample {
  public static void main(String[] args ) {
    // Create Connection to SF Cluster
    SolidFireElementIF sf = SolidFireElement.create("mvip", "8.0", "username", "password");

    // Create some accounts
    AddAccountRequest addAccountRequest = new AddAccountRequest("username", EMPTY_STRING, 
                                                                EMPTY_STRING, EMPTY_MAP);
    Long accountId = sf.addAccount(addAccountRequest).getAccountID();

    // And a volume with default QoS
    CreateVolumeRequest createVolumeRequest = new CreateVolumeRequest("volumeName", accountId, 
                                                                      1000000000l, false, 
                                                                      Optional.<QoS>empty(), 
                                                                      EMPTY_MAP);
    Long volumeId = sf.createVolume(createVolumeRequest).getVolumeID();

    // Lookup iqn for new volume
    String iqn = sf.listVolumesForAccount(accountId, of(volumeId), of(1l)).getVolumes()[0].getIqn();

    // Change Min and Burst QoS while keeping Max and Burst Time the same
    QoS qos = new QoS(of(5000l), EMPTY_LONG, of(30000l), EMPTY_LONG);

    // Modify the volume size and QoS
    ModifyVolumeRequest modifyVolumeRequest = new ModifyVolumeRequest(volumeId, EMPTY_LONG, 
                                                                      EMPTY_STRING, EMPTY_STRING, 
                                                                      of(qos), of(2000000000l),
                                                                      EMPTY_MAP);
    sf.modifyVolume(modifyVolumeRequest);
  }
}
```

###Examples of using the API (VB)
```scala    
// Import your Java Primitive Types
import java.lang.Long

import com.solidfire.javautil.Optional.{empty, of}

class ReadmeExample {

  // Create Connection to SF Cluster
  val sf = SolidFireElement.create("mvip", "8.0", "username", "password")

  // Create some accounts
  val addAccount = new AddAccountRequest("username", empty[String], empty[String], empty())
  val accountId = sf.addAccount(addAccount).getAccountID

  // And a volume
  val createVolume = new CreateVolumeRequest("volumeName", accountId, 1000000000l, false, empty[QoS], empty())
  val volumeId = sf.createVolume(createVolume).getVolumeID

  // Lookup iqn for new volume
  val iqn: String = sf.listVolumesForAccount(accountId, of(volumeId), of(1l)).getVolumes()(0).getIqn

  // Change Min and Burst QoS while keeping Max and Burst Time the same
  val qos: QoS = new QoS(of(5000l), empty[Long], of(30000l), empty[Long])

  // Modify the volume
  val modifyVolume = new ModifyVolumeRequest(volumeId, empty[Long], empty[String], empty[String], 
                                             of(qos), of( 2000000000l ), empty())
  sf.modifyVolume(modifyVolume)
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
