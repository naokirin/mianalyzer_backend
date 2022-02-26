# Mi-Analyzer Backend

[![BackendTest](https://github.com/naokirin/mianalyzer_backend/actions/workflows/backend_test.yml/badge.svg)](https://github.com/naokirin/mianalyzer_backend/actions/workflows/backend_test.yml)

Simple data analyzed Web API server by julia.

## Get Started

```sh
# build and run docker container (port 28000)
docker-compose build
docker-compose up -d

# request /basic_statistics
curl -X POST http://localhost:28000/basic_statistics \
  -H "Content-Type: application/json"
  -d '{"records":[[1.0, 2.0, 0.0], [2.0, 1.0, 2.0], [3.0, 0.0, 9.0]]}'

# response json body
{"means":[2.0,1.0,3.6666666666666665],"row_count":3,"maxs":[3.0,2.0,9.0],"stds":[1.0,1.0,4.725815626252609],"mins":[1.0,0.0,0.0]}
```

## Usage

First read "[Get Started](https://github.com/naokirin/mianalyzer_backend#get-started)".

## APIs

### Basic Statistics

Calculate maxs, mins, means, stds and row count.

```sh
curl -X POST http://localhost:28000/basic_statistics \
  -H "Content-Type: application/json"
  -d '{"records":[[1.0, 2.0, 0.0], [2.0, 1.0, 2.0], [3.0, 0.0, 9.0]]}'
```

| Content | <span style="width: 300px; display: inline-block;">Values</span> | Example |
| - | - | - |
| Path | /basic_statistics |  |
| Request json body | ・records: Array in array of real number | { "records": [[1.0, 2.0, 3.0], [-1.0, -2.0, -3.0]] } |
| Response json body | ・means: each column means<br>・row_count: row count<br>・maxs: each column max numbers<br>・mins: each column min numbers<br>・stds: each column standard deviation | {"means":[2.0,1.0,3.6666666666666665],"row_count":3,"maxs":[3.0,2.0,9.0],"stds":[1.0,1.0,4.725815626252609],"mins":[1.0,0.0,0.0]} |

### Correlations

Calculate pearson and spearman correlations.

This API calculates correlations of two column pairs if exists three or more columns.

```sh
curl -X POST http://localhost:28000/correlations \
  -H "Content-Type: application/json"
  -d '{"records":[[1.0, 2.0, 0.0], [2.0, 1.0, 2.0], [3.0, 0.0, 9.0]]}'
```

| Content | <span style="width: 300px; display: inline-block;">Values</span> | Example |
| - | - | - |
| Path | /correlations |  |
| Request json body | ・records: Array in array of real number | { "records": [[1.0, 2.0, 3.0], [-1.0, -2.0, -3.0]] } |
| Response json body | ・combs: combination columns list<br>・correlations: pearson correlations<br>・spearman_correlations: spearman correlations | {"spearman_correlations":[-1.0,1.0,-1.0],"correlations":[-1.0,0.9522165814091075,-0.9522165814091075],"combs":[[1,2],[1,3],[2,3]]} |

### Gaussian Mixtures

Calculate gaussian mixtures.

```sh
curl -X POST http://localhost:28000/gaussian_mixtures \
  -H "Content-Type: application/json"
  -d '{"components": 2, "records": [[1.0, 2.0, 0.0], [2.0, 1.0, 2.0], [3.0, 0.0, 9.0]]}'
```

| Content | <span style="width: 300px; display: inline-block;">Values</span> | Example |
| - | - | - |
| Path | /gaussian_mixtures |  |
| Request json body | ・records: Array in array of real number<br>・components: component number. if want to calculate automatically, set null (limitation: less than or equal to the row count) | { "records": [[1.0, 2.0, 3.0], [-1.0, -2.0, -3.0]] } |
| Response json body | ・means: each gaussian distribution means<br>・weights: each gaussian distribution weights<br>・stds: each gaussian distribution standard deviations | {"means":[[2.49,0.999],[0.500,1.9999],[0.9999,8.99]],"weights":[[0.66,0.333],[0.6666,0.333],[0.666,0.333]],\"stds\":[[0.500,0.0010],[0.5000,0.00100],[1.0000,0.0010]]}" |

### k-means

Calculate k-means.

```sh
curl -X POST http://localhost:28000/kmeans \
  -H "Content-Type: application/json"
  -d '{"cluster_num": 2, "records": [[1.0, 2.0, 0.0], [2.0, 1.0, 2.0], [3.0, 0.0, 9.0]]}'
```

| Content | <span style="width: 300px; display: inline-block;">Values</span> | Example |
| - | - | - |
| Path | /kmeans |  |
| Request json body | ・records: Array in array of real number<br>・cluster_num: k-means cluster number | {"cluster_num": 2, "records": [[1.0, 2.0, 0.0], [2.0, 1.0, 2.0], [3.0, 0.0, 9.0]]} |
| Response json body | ・centers: k-means cluster center points<br>・clusters: k-means clusters | {"centers":[[1.5,1.5,1.0],[3.0,0.0,9.0]],"clusters":[[[1.0,2.0,0.0],[2.0,1.0,2.0]],[[3.0,0.0,9.0]]]} |

### g-means

Calculate g-means.

```sh
curl -X POST http://localhost:28000/gmeans \
  -H "Content-Type: application/json"
  -d '{"records": [[1.0, 2.0, 0.0], [2.0, 1.0, 2.0], [3.0, 0.0, 9.0]]}'
```

| Content | <span style="width: 300px; display: inline-block;">Values</span> | Example |
| - | - | - |
| Path | /gmeans |  |
| Request json body | ・records: Array in array of real number | {"records": [[1.0, 2.0, 0.0], [2.0, 1.0, 2.0], [3.0, 0.0, 9.0]]} |
| Response json body | ・centers: g-means cluster center points<br>・clusters: g-means clusters | {"centers":[[1.5,1.5,1.0],[3.0,0.0,9.0]],"clusters":[[[1.0,2.0,0.0],[2.0,1.0,2.0]],[[3.0,0.0,9.0]]]} |

### Hierachical clusterings

Calculate hierachical clusterings.

Differences are Euclidean, Mahalanobis and cosine.  
Linkages are Ward and average.

```sh
curl -X POST http://localhost:28000/hierachical_clusterings \
  -H "Content-Type: application/json"
  -d '{"labels": ["one", "two", "three"], "normalized": true,  "records": [[1.0, 2.0, 0.0], [2.0, 1.0, 2.0], [3.0, 0.0, 9.0]]}'
```

| Content | <span style="width: 300px; display: inline-block;">Values</span> | Example |
| - | - | - |
| Path | /hierachical_clusterings |  |
| Request json body | ・records: Array in array of real number<br>・labels: column labels<br>・normalized: normalize each column values | {"labels": ["one", "two", "three"], "normalized": true,  "records": [[1.0, 2.0, 0.0], [2.0, 1.0, 2.0], [3.0, 0.0, 9.0]]} |
| Response json body | ・charts: list of clusterings for each differences and linkages<br>・dist_type: difference type<br>・linkage: linkage type<br>・records: clusterings | {"charts":[{"dist_type":"euclidean","linkage":"ward","records":[["one","two"],"three"]},{"dist_type":"euclidean","linkage":"average","records":[["one","two"],"three"]},{"dist_type":"mahalanobis","linkage":"ward","records":[["one","two"],"three"]},{"dist_type":"mahalanobis","linkage":"average","records":[["one","two"],"three"]},{"dist_type":"cosine","linkage":"ward","records":[["one","two"],"three"]},{"dist_type":"cosine","linkage":"average","records":[["one","two"],"three"]}]} |

### Time series analysis

Calculate time series analysis.

```sh
curl -X POST http://localhost:28000/time_series \
  -H "Content-Type: application/json"
  -d '{"records": [["2021-04-01", 2.0], ["2021-04-02", 1.0], ["2021-04-03", 0.0]], "time_category": "date", "grouping_type": "average"}'
```

| Content | <span style="width: 300px; display: inline-block;">Values</span> | Example |
| - | - | - |
| Path | /time_series |  |
| Request json body | ・records: Array in array of real number<br>・time_category: time category (date, year, year_month, date_hour, date_hour_minute, secound, number)<br>・grouping_type: grouping policy for duplicated time (min, max, average, sum, count) | {"records": [["2021-04-01", 2.0], ["2021-04-02", 1.0], ["2021-04-03", 0.0]], "time_category": "date", "grouping_type": "average"} |
| Response json body | ・correlogram: correlograms<br>・fast Fourier transform (spectrum analysis)<br>・hist: histgrams | {"correlogram":[[0.0,1.0],[1.0,0.0],[2.0,-0.5]],"fft":[["1/6",1.0],["1/2",0.5773502691896257]],"hist":[[0.0,1.0],[0.5,0.0],[1.0,1.0],[1.5,0.0],[2.0,1.0]]} |

## License

Mi-Analyzer backend (mianalyzer_backend) is under [MIT License](https://github.com/naokirin/mianalyzer_backend/blob/main/LICENSE)

## Authors

* [naokirin](https://github.com/naokirin)
