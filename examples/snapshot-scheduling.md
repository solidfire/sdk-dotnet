#<img src="https://raw.githubusercontent.com/solidfire/sdk-dotnet/release1.1/img/net.png" height="50" width="50" > SolidFire .NET SDK Examples

## Snapshot Scheduling

These examples walk through all interactions with a Schedule. Schedules control when automatic Snapshots will be taken of volumes on the SolidFire cluster.

Examples for:

- [List all Schedules](#list-all-schedules)
- [Get one Schedule](#get-one-schedule)
- [Create a Schedule](#create-a-schedule)
- [Modify a Schedule](#modify-a-schedule)

### Documentation

Further documentation for each method and type can be found at our [.NET documentation site](http://solidfire.github.io/sdk-dotnet/help/v1.1/html). 

### List all Schedules

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

To get a single schedule:

~~~ csharp
// Create connection to SF Cluster
var sfe = ElementFactory.Create("ip-address-of-cluster", "username", "password");

// send the request and gather the result
var getSchedulesResult = sfe.GetSchedule(56);

// display the schedule from the result object
Console.WriteLine(getSchedulesResult.Schedule.ToString());
~~~

### Create a Schedule

In order for automatic snapshots to be taken, you need to create a schedule. There are three types of schedules that can be created:

- [Time Interval](#time-interval-schedule) 
- [Days Of Week](#days-of-week-schedule)
- [Days Of Month](#days-of-month-schedule)

All three types of schedules are demonstrated here:

##### Time Interval Schedule

This type of schedule will base snapshots on a time interval frequency. Each snapshot will be taken after the specified amount of time has passed. Control the duration by setting days, hours, and minutes on the TimeIntervalFrequency object.

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

This type of schedule will base snapshots on a weekly frequency. Each snapshot will be taken on the specified weekdays at the time specified in the hours and minutes properties. Control the schedule by setting weekdays, hours, and minutes on the DaysOfWeekFrequency object.

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

This type of schedule will base snapshots on a monthly frequency. Each snapshot will be taken on the specified month days at the time specified in the hours and minutes properties. Control the schedule by setting monthdays, hours, and minutes on the DaysOfMonthFrequency object.

~~~ csharp
fvar schedule = new Schedule();
schedule.Name = "SnapshotOn7th14thAnd21stAt0130Hours";
schedule.Frequency = new DaysOfMonthFrequency()
{
    Monthdays = new long[] {7, 14, 21},
    Hours = 3,
    Minutes = 30
};
~~~

#### Create a Schedule (cont.)

After creating the schedule and setting the frequency to Time Interval, Days Of Week, or Days Of Month, complete the object by setting the `ScheduleInfo` property. This controls information about the resulting snapshot such as which volumes are in it, its name, and how long it should be retained.

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

At this point we have created a new schedule called SnapshotEvery12Hours that creates a snapshot whose name is prepended with "12th hour snapshot" every 12 hours for volumes 1, 3, and 5 that is retained for 72 hours.

### Modify a Schedule

To modify a schedule, first you must have a valid schedule object with its `ScheduleID` set. You can create one manually but it is preferred to retrieve it from the cluster, modify the properties needed and then send it back. Here is an example:

~~~ python
// Create connection to SF Cluster
var sfe = ElementFactory.Create("172.26.64.72", "admin", "admin");

// send the requst with the scheduleID and gather the result
var getScheduleResult = sfe.GetSchedule(9);

// set a schedule variable from the Schedule in the result for ease of use
var schedule = getScheduleResult.Schedule;

// display the retrieved schedule
Console.WriteLine(schedule.ToString());

// set paused to true in order to pause the schedule
schedule.Paused = true;

// send the request to modify this schedule
sfe.ModifySchedule(schedule);

// send another GetSchedule request and gather the result
var getModifiedScheduleResult = sfe.GetSchedule(9);

// display the newly modified schedule
Console.WriteLine(getModifiedScheduleResult.Schedule.ToString());   
~~~
