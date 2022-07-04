## Load your packages, e.g. library(targets).
source("./packages.R")

## Load your R files
lapply(list.files("./R", full.names = TRUE), source)

all_barometer_exports = dir("raw_data/barometer_readings", pattern = "^export", full.names = TRUE)
all_journal_entries = dir("raw_data/daily_log", pattern = "^20", full.names = TRUE)

## tar_plan supports drake-style targets and also tar_target()
tar_plan(

  barometric_data = process_barometric_data(all_barometer_exports),
  journal_data = process_journal_data(all_journal_entries)

# target = function_to_make(arg), ## drake style

# tar_target(target2, function_to_make2(arg)) ## targets style

)
