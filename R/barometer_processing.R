all_csv = dir("org_barometer_readings", pattern = "^export", full.names = TRUE)

all_readings = purrr::map_df(all_csv, read.table, header = TRUE, sep = "\t")
all_readings = unique(all_readings)

saveRDS(all_readings, file = "barometer_readings/barometer.rds")
