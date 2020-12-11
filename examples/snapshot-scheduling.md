#<img src="https://raw.githubusercontent.com/solidfire/sdk-dotnet/release1.1/img/net.png" height="50" width="50" > SolidFire .NET SDK Examples

## Snapshot Scheduling

These examples walk through all interactions with a [Schedule](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Schedule.htm). Schedules control when automatic [Snapshots](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Snapshot.htm) will be taken of [Volumes](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Volume.htm) on the SolidFire cluster.

Examples for:

- [List all Schedules](#list-all-schedules)
- [Get one Schedule](#get-one-schedule)
- [Create a Schedule](#create-a-schedule)
- [Modify a Schedule](#modify-a-schedule)

### Documentation

Further documentation for each method and type can be found at our [.NET documentation site](http://solidfire.github.io/sdk-dotnet/help/html/R_Project_SolidFire__NET_SDK_Documentation.htm).

### List all Schedules

[ListSchedules method documentation](http://solidfire.github.io/sdk-dotnet/help/html/M_SolidFire_Element_Api_SolidFireElement_ListSchedules.htm)

To list all the schedules on a cluster:

~~~ csharp
/ Create connection to SF Cluster
var sfe = ElementFactory.Create("ip-address-of-cluster", "username", "password");

// send the request and gather the result
var listSchedulesResult = sfe.ListSchedules();

// iterate the schedules array on the result object and display each Schedule
foreach(Schedule schedule in listSchedulesResult.Schedules)
{
    Console.WriteLine(schedule.ToString());
}
~~~

### Get one Schedule

[GetSchedule method documentation](http://solidfire.github.io/sdk-dotnet/help/html/M_SolidFire_Element_Api_SolidFireElement_GetSchedule.htm)

To get a single schedule you must have the `ScheduleID`:

~~~ csharp
// Create connection to SF Cluster
var sfe = ElementFactory.Create("ip-address-of-cluster", "username", "password");

// send the request and gather the result
var getSchedulesResult = sfe.GetSchedule(56);

// display the schedule from the result object
Console.WriteLine(getSchedulesResult.Schedule.ToString());
~~~

### Create a Schedule

[CreateSchedule method documentation](http://solidfire.github.io/sdk-dotnet/help/html/M_SolidFire_Element_Api_SolidFireElement_CreateSchedule.htm)

In order for automatic snapshots to be taken, you need to create a [Schedule](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Schedule.htm). There are three types of schedules that can be created:

- [Time Interval](#time-interval-schedule) 
- [Days Of Week](#days-of-week-schedule)
- [Days Of Month](#days-of-month-schedule)

All three types of schedules are demonstrated here:

##### Time Interval Schedule

This type of [Schedule](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Schedule.htm) will base snapshots on a time interval frequency. Each [Snapshot](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Snapshot.htm) will be taken after the specified amount of time has passed. Control the duration by setting any mix of `days`, `hours`, and `minutes` on the [TimeIntervalFrequency](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_TimeIntervalFrequency.htm) object.

~~~ csharp
var schedule = new Schedule();
schedule.Name = "SnapshotEvery3AndAHalfDays";
schedule.Frequency = new TimeIntervalFrequency()
{
    Days = 3,
    Hours = 12
};
~~~

##### Days Of Week Schedule

This type of [Schedule](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Schedule.htm) will base snapshots on a weekly frequency. Each [Snapshot](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Snapshot.htm) will be taken on the specified days of the week at the time specified. Control the schedule by setting `weekdays`, `hours`, and `minutes` on the [DaysOfWeekFrequency](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_DaysOfWeekFrequency.htm) object. Use the [Weekday](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Weekday.htm) enum for each day of the week desired.

~~~ csharp
var schedule = new Schedule();
schedule.Name = "SnapshotOnMonWedFriAt3am";
schedule.Frequency = new DaysOfWeekFrequency()
{
    Weekdays = new Weekday[] {Weekday.Monday, Weekday.Wednesday, Weekday.Friday},
    Hours = 3
};
~~~

##### Days Of Month Schedule

This type of [Schedule](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Schedule.htm) will base snapshots on a monthly frequency. Each [Snapshot](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Snapshot.htm) will be taken on the specified month days at the time specified in the hours and minutes properties. Control the schedule by setting `monthdays`, `hours`, and `minutes` on the [DaysOfMonthFrequency](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_DaysOfMonthFrequency.htm) object.

~~~ csharp
var schedule = new Schedule();
schedule.Name = "SnapshotOn7th14thAnd21stAt0130Hours";
schedule.Frequency = new DaysOfMonthFrequency()
{
    Monthdays = new long[] {7, 14, 21},
    Hours = 3,
    Minutes = 30
};
~~~

#### Create a Schedule (cont.)

After creating the [Schedule](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Schedule.htm) and setting the frequency to Time Interval, Days Of Week, or Days Of Month, complete the object by setting the [`ScheduleInfo`](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_ScheduleInfo.htm) property. This controls information about the resulting [Snapshot](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Snapshot.htm) such as which volumes are in it, its name, and how long it should be retained.

Continuing on with the [Time Interval](#time-interval-schedule) example from above:

~~~csharp
var schedule = new Schedule();
schedule.Name = "SnapshotEvery12Hours";
schedule.Frequency = new TimeIntervalFrequency()
{
    Hours = 12
};
schedule.ScheduleInfo = new ScheduleInfo()
{
    VolumeIDs = new long[] {1, 3, 5},
    SnapshotName = "12th hour snapshot",
    Retention = "72:00:00" // in HH:mm:ss format
};
// When should the schedule start?
schedule.StartingDate = "2016-12-01T00:00:00Z"; // in UTC format

// Create connection to SF Cluster
var sfe = ElementFactory.Create("ip-address-of-cluster", "username", "password");

// call the CreateSchedule method with the newly created schedule object
var createScheduleResult = sfe.CreateSchedule(schedule);

// Grab the schedule ID from the result object
var newScheduleId = createScheduleResult.ScheduleID;
~~~

At this point we have created a new [Schedule](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Schedule.htm) called "SnapshotEvery12Hours" that creates a [Snapshot](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Snapshot.htm) whose name is prepended with "12th hour snapshot" every 12 hours for volumes 1, 3, and 5 being retained for 72 hours.

### Modify a Schedule

[ModifySchedule method documentation](http://solidfire.github.io/sdk-dotnet/help/html/M_SolidFire_Element_Api_SolidFireElement_ModifySchedule.htm)

To modify a [Schedule](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Schedule.htm), first you must have a valid [Schedule](http://solidfire.github.io/sdk-dotnet/help/html/T_SolidFire_Element_Api_Schedule.htm) object with its `ScheduleID` set. You can create one manually but it is preferred to retrieve it from the cluster, modify the properties needed and then send it back. Here is an example:

~~~ csharp
// Create connection to SF Cluster
var sfe = ElementFactory.Create("ip-address-of-cluster", "username", "password";

// send the requst with the scheduleID and gather the result
var getScheduleResult = sfe.GetSchedule(newScheduleId);

// set a schedule variable from the Schedule in the result for ease of use
var schedule = getScheduleResult.Schedule;

// set paused to true in order to pause the schedule
schedule.Paused = true;

// send the request to modify this schedule
sfe.ModifySchedule(schedule);   
~~~
