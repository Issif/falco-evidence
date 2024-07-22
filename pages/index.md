---
title: Falco download stats
---

# From <Value data={time_window_min} /> to <Value data={time_window_max} />

## Downloads by package

```sql time_window_min
  select 
    MIN(time) as min
  from scarf.downloads
  group by time
```
```sql time_window_max
  select 
    MAX(time)
  from scarf.downloads
  group by time
```


```sql count_by_package
  select 
    package as name,
    COUNT(package) as value
  from scarf.downloads
  group by package
```

<ECharts config={
    {
        tooltip: {
            formatter: '{b}: {c} ({d}%)'
        },
        series: [
        {
          type: 'pie',
          data: [...count_by_package],
        }
      ]
      }
    }
/>

## Downloads by hour

```sql count_by_package_by_hour
  select 
    date_trunc('hour', time) as hour,
    package as package,
    COUNT(package) as count
  from scarf.downloads
  group by hour, package
```

<LineChart 
    data={count_by_package_by_hour}
    x=hour
    y=count 
    yAxisTitle="Dowload by hour"
    series=package
    step=true
/>

## Downloads by origin

```sql origins
  select
    COUNT(id) as count,
    package as package,
    origin_latitude as lat,
    origin_longitude as long
  from scarf.downloads
  group by package, lat, long
```

<PointMap 
    data={origins} 
    lat=lat 
    long=long 
    value=count 
    pointName=package
    height=600
/>