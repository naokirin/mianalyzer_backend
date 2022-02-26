module Stats
using Statistics

export mean, max, min, sum, count

mean(values) = Statistics.mean(values)
max(values) = Base.maximum(values)
min(values) = Base.minimum(values)
sum(values) = Base.sum(values)
count(values) = Base.length(values)
end
