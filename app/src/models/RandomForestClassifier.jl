module RandomForestClassifier

using ..Imports
using DataFrames

export feature_importances

function feature_importances(values, targets, columns)
  model = ensemble.RandomForestClassifier()
  fitted = model.fit(values, targets)
  DataFrame(columns=columns, feature_importances=fitted.feature_importances_)
end

end
