---
title: Falco Blog stats
---

<DateRange
    name=date_range
    defaultValue={'Last 30 Days'}
/>

# From {inputs.date_range.start} to {inputs.date_range.end}

## Top {inputs.top_count.value} pages

<Dropdown name=top_count
    defaultValue={(["20"])} 
    title="top"
>
    <DropdownOption valueLabel=10 value=10/>
    <DropdownOption valueLabel=20 value=20/>
    <DropdownOption valueLabel=50 value=50/>
    <DropdownOption valueLabel=100 value=100/>
</Dropdown>

```sql top_pages
  select 
    referer as page,
    count(referer) as visits
  from falco_website.falco_blog
  where time BETWEEN '${inputs.date_range.start}' AND '${inputs.date_range.end}'
  group by page
  order by visits desc
  limit ${inputs.top_count.value}
```

<BarChart 
    data={top_pages}
    x=page
    y=visits 
    swapXY=true
/>

## Visits by page

```sql visits
  select
    count(*) as visits
  from falco_website.falco_blog
  where time BETWEEN '${inputs.date_range.start}' AND '${inputs.date_range.end}'
```

<BigValue 
  data={visits} 
  value=visits
  fmt="%d.0"
/>

```sql visits_by_page
  select 
    referer as page,
    count(referer) as visits
  from falco_website.falco_blog
  where time BETWEEN '${inputs.date_range.start}' AND '${inputs.date_range.end}'
  group by page
  order by visits desc
```

<DataTable data={visits_by_page} totalRow=true rows=20/>
 
## Visits by day

```sql visits_by_day
  select 
    date_trunc('day', time) as day,
    COUNT(id) as visits
  from falco_website.falco_blog
  where time BETWEEN '${inputs.date_range.start}' AND '${inputs.date_range.end}'
  group by day
  order by visits desc
```

<LineChart 
    data={visits_by_day}
    x=day
    y=visits 
    yAxisTitle="Visits by day"
    step=true
/>

<CalendarHeatmap 
    data={visits_by_day}
    date=day
    value=visits
    title="Calendar Heatmap"
    subtitle="Daily visits"
/>

## Visits by origin

```sql counts_by_origin
  select
    origin_country as country,
    COUNT(referer) as visits,
    'https://flaglog.com/codes/standardized-rectangle-120px/' || iso || '.png' as flag
  from falco_website.falco_blog
  inner join falco_website.countries on falco_website.countries.name=falco_website.falco_blog.origin_country;
  where (origin_country is not null and origin_city is not null) and (time BETWEEN '${inputs.date_range.start}' AND '${inputs.date_range.end}')
  group by country, iso
  order by visits desc
```

<DataTable data={counts_by_origin} rows=10>
  <Column id=flag contentType=image height=30px align=center />
	<Column id=country />
	<Column id=visits />
</DataTable>

```sql lat_long_origins
  select
    COUNT(origin_city) as count,
    origin_country as country,
    origin_city as city,
    origin_latitude as lat,
    origin_longitude as long
  from falco_website.falco_blog
  where (origin_country is not null and origin_city is not null) and (time BETWEEN '${inputs.date_range.start}' AND '${inputs.date_range.end}')
  group by lat, long, country, city
```

<BubbleMap 
    data={lat_long_origins} 
    lat=lat 
    long=long 
    size=count
    value=count
    height=500
    pointName=city
/>

## Visits by company

```sql count_by_company
  select
    origin_company as company,
    origin_country as country,
    COUNT(referer) as visits,
    'https://flaglog.com/codes/standardized-rectangle-120px/' || iso || '.png' as flag
  from falco_website.falco_blog
  inner join falco_website.countries on falco_website.countries.name=falco_website.falco_blog.origin_country;
  where (origin_company is not null) and (time BETWEEN '${inputs.date_range.start}' AND '${inputs.date_range.end}')
  group by company, country, iso
  order by visits desc
```

<DataTable data={count_by_company}>
  <Column id=flag contentType=image height=30px align=center />
	<Column id=country />
	<Column id=company />
	<Column id=visits />
</DataTable>