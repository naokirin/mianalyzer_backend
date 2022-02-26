module TimeSeriesController
using DataFrames, Query, Dates
using ..Stats, ..Histogram, ..FFT, ..Correlogram
using JSON

export call
min_time(times, time_category) = findmin(times)
max_time(times, time_category) = findmax(times)

function group_dataframe(df, grouping_type)
  if grouping_type == "min"
    return df |>
    @map({time=_.time, value=Stats.min(convert(Array{Float64,1}, _.value)) }) |>
    DataFrame
  elseif grouping_type == "max"
    return df |>
    @map({time=_.time, value=Stats.max(convert(Array{Float64,1}, _.value)) }) |>
    DataFrame
  elseif grouping_type == "average"
    return df |>
    @map({time=_.time, value=Stats.mean(convert(Array{Float64,1}, _.value)) }) |>
    @mutate(value=Float64(_.value)) |>
    DataFrame
  elseif grouping_type == "sum"
    return df |>
    @map({time=_.time, value=Stats.sum(convert(Array{Float64,1}, _.value)) }) |>
    DataFrame
  else
    return df |>
    @map({time=_.time, value=Stats.count(convert(Array{Float64,1}, _.value)) }) |>
    DataFrame
  end
end

function format_date_time(time, time_category)
  if time_category == "date"
    return Dates.format(time, dateformat"yyyy-mm-dd")
  elseif time_category == "year"
    return Dates.format(time, dateformat"yyyy")
  elseif time_category == "year_month"
    return Dates.format(time, dateformat"yyyy-mm")
  elseif time_category == "date_hour"
    return Dates.format(time, dateformat"yyyy-mm-dd HH")
  elseif time_category == "date_hour_minute"
    return Dates.format(time, dateformat"yyyy-mm-dd HH:MM")
  else
    return Dates.format(time, dateformat"yyyy-mm-dd HH:MM:SS")
  end
end

function create_records_with_time(records, time_category, grouping_type, missing_complement)
  new_records = hcat(records...)
  ts = DateTime.(new_records[1, :], dateformat"y-m-d H:M:S")
  times = format_date_time.(ts, time_category)
  min, min_index = min_time(ts, time_category)
  max, max_index = max_time(ts, time_category)

  # grouping
  df = DataFrame(time=times, value=convert(Array{Float64,1}, new_records[2, :]))
  grouping_df = df |>
  @groupby(_.time) |>
  @map({time=getindex(_, [1, 1])[1].time, value=convert(Array{Float64,1}, get.(_, :value, [0]))})

  new_records = Matrix{Union{Float64, String}}(group_dataframe(grouping_df, grouping_type))

  # missing value complement
  existed_times = new_records[:, 1]
  if time_category == "date"
    interval = Day(1)
  elseif time_category == "year"
    interval = Year(1)
  elseif time_category == "year_month"
    interval = Month(1)
  elseif time_category == "date_hour"
    interval = Hour(1)
  elseif time_category == "date_hour_minute"
    interval = Minute(1)
  else
    interval = Second(1)
  end
  for time = format_date_time.(min:interval:max, time_category)
    if !(time in existed_times)
      new_records = vcat(new_records, [time 0])
    end
  end

  return sortslices(rotr90(new_records), dims=2)
end

function create_records_without_time(records)
  new_records = hcat(records...)
  permutedims(hcat(new_records[1, :], convert(Array{Float64,1}, new_records[2, :])))
end

function create_records(records, time_category, grouping_type, missing_complement)
  if time_category != "number"
    create_records_with_time(records, time_category, grouping_type, missing_complement)
  else
    create_records_without_time(records)
  end
end

function hist(values, time_category, grouping_type)
  values = convert(Array{Float64, 1}, values)
  Histogram.fit(values, 8)
end

function correlogram(values)
  values = convert(Array{Float64,1}, values)
  Correlogram.call(values)
end

function fft(values, time_category)
  arr = convert(Array{Float64, 1}, values)
  FFT.fft(arr)
end

"""
call(message)

Computes histgram, correlogram, fft for time series.

# Arguments
- `message::Dict`: the arguments dict
  - `"records"`: the array of array of rows
  - `"time_category"`: time category (date, year, year_month, date_hour, date_hour_minute, secound, number)
  - `"grouping_type"`: grouping policy for duplicated time (min, max, average, sum, count)

# Return
the json string of result object

# Examples
```jldoctest
julia> TimeSeriesController.call(Dict("records" => [["2021-04-01", 2.0], ["2021-04-02", 1.0], ["2021-04-03", 0.0]], "time_category" => "date", "grouping_type" => "average"))
"{\"correlogram\":[[0.0,1.0],[1.0,0.0],[2.0,-0.5]],\"fft\":[[\"1/6\",1.0],[\"1/2\",0.5773502691896257]],\"hist\":[[0.0,1.0],[0.5,0.0],[1.0,1.0],[1.5,0.0],[2.0,1.0]]}"

```
"""
function call(message)
  _records = message["records"]
  time_category = message["time_category"]
  grouping_type = message["grouping_type"]
  missing_complement = "zero"

  records = create_records(_records, time_category, grouping_type, missing_complement)
  values = records[2, :]

  dict = Dict(:hist => hist(values, time_category, grouping_type),
              :correlogram => correlogram(values),
              :fft => fft(values, time_category)) |> JSON.json
end
end

