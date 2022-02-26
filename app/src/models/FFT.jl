module FFT
using FFTW
using ..Stats

export fft

function fft_frequency_label(index, min_index_2, min_index_4, min_index_6, min_index_8, min_index_10, min_index_12, length)
  if index == min_index_2
    "1/2"
  elseif index == min_index_4
    "1/4"
  elseif index == min_index_6
    "1/6"
  elseif index == min_index_8
    "1/8"
  elseif index == min_index_10
    "1/10"
  elseif index == min_index_12
    "1/12"
  elseif index == 1
    "1/$length"
  else
    ""
  end
end

function fft_frequency_labels(array)
  min_2, index_2 = findmin((x -> abs(x - 1/2)).(array))
  min_4, index_4 = findmin((x -> abs(x - 1/4)).(array))
  min_6, index_6 = findmin((x -> abs(x - 1/6)).(array))
  min_8, index_8 = findmin((x -> abs(x - 1/8)).(array))
  min_10, index_10 = findmin((x -> abs(x - 1/10)).(array))
  min_12, index_12 = findmin((x -> abs(x - 1/12)).(array))
  min, index = findmin((x -> abs(x - 1/size(array, 1))).(array))

  fft_frequency_label.(1:size(array, 1), index_2, index_4, index_6, index_8, index_10, index_12, size(array, 1))
end

function fft(values)
  fft_arr = (FFTW.fft(values, 1))
  length = convert(Int64, ceil(size(fft_arr, 1) / 2))
  fft_results = abs.(fft_arr[1:length])
  frequencies = fft_frequency_labels(FFTW.fftfreq(size(values, 1), 1))[1:length]
  vcat(hcat(frequencies...), hcat((fft_results ./ Stats.max(fft_results))...))
end
end
