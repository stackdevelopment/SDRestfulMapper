iOSRestfulMapper
================

This library was intended to be an open source project but another library filled that space pretty well.

The goal was to make it particularly easy for an iOS front-end to work with a Rails backend and an iOS front-end, since Rails is so strongly convention over configuration.

A developer would simply create a sub-class of ABModelMap with whatever properties they chose. Then mapping would be setup in the `setupMapping` function. If the name matched the name from the API you could specify them in bulk:

```
[self mapArrayOfRawKeysToPropertyWithSameName:@[@"name",
                                                    @"address",
                                                    @"latitude",
                                                    @"longitude"]];
```

However you can also specify a mapping between to differently named items:

```
[self mapRawKey:@"description" toPropertyName:@"desc"];
```

I included a handful of useful presets to translate common types, such as Rails formatted dates:

```
[self mapRawKey:@"start" toPropertyName:@"startDate" mapKey:ABMapRailsDateTimeToDate];
```

These default transformations include
```
ABMapToFloatNumber,
	ABMapToBool,
	ABMapRailsDateToDate,
	ABMapRailsDateTimeToDate,
	ABMapRailsDateTimeZoneToDate
  ```

  However you can also process a value with an arbitrary block of code.

  Another handy piece is that you can also use other `ABModelMap` models as property types, and it will parse those properties into that class, which can be done recursively.
