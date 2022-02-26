module MianalyzerBackend

function allJuliaFiles(dir)
  contents = String[]
  for (root, dirs, files) in walkdir(dir)
    push!.(Ref(contents), joinpath.(root, filter(x -> splitext(x)[2] == ".jl", files)))
  end
  return contents
end

srcdir = @__DIR__
model_dependency_orders = map(["Imports.jl", "Stats.jl"]) do f
  srcdir * "/models/" * f
end
for file in model_dependency_orders
  println(file)
  include(file)
end

for file in allJuliaFiles(srcdir * "/models")
  if !(file in model_dependency_orders)
    println(file)
    include(file)
  end
end

for file in allJuliaFiles(srcdir * "/controllers")
  println(file)
  include(file)
end
end
