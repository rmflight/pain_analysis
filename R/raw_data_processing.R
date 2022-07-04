process_barometric_data = function(all_files){
  all_readings = purrr::map_dfr(all_files, function(in_file){
    #message(in_file)
    tmp = read.table(in_file, sep = "\t", header = TRUE)
    tmp %>%
      janitor::clean_names() %>%
      tibble::as_tibble() %>%
      unique() %>%
      dplyr::arrange(timestamp_unix_time)
  })
  all_readings
}

process_journal_data = function(all_files){
  NULL
}

process_single_journal = function(in_file){
  journal_date = gsub(".md", "", basename(in_file))

  journal_contents = readLines(in_file)
  n_vals = nchar(journal_contents)
  journal_contents = journal_contents[n_vals > 0]
  second_and_more = grep("^##", journal_contents)
  third_header_locs = grep("^###", journal_contents)
  out_list_data = vector("list", length(second_header_locs))

  has_daughter = grep("Daughter", journal_contents)
  if (length(has_daughter) > 0) {
    daughter_locs = second_and_more[second_and_more > has_daughter]
    me_locs = second_and_more[second_and_more < has_daughter]
  } else {
    daughter_locs = vector("integer", 0)
    me_locs = second_and_more
  }

  me_header_locs = second_header_locs
  for (iloc in seq_along(second_header_locs)) {
    if (grepl("Daughter", journal_contents[second_header_locs[iloc]])) {
      break()
    }

    jloc = iloc + 1
    if (jloc > length(journal_contents)) {
      jloc = length(journal_contents)
    }
    if (second_header_locs[jloc] - 1 == second_header_locs[iloc]) {
      break()
    }
    use_data = journal_contents[seq(second_header_locs[iloc] + 1, second_header_locs[jloc] - 1)]
    split_dash = strsplit(use_data, " - |, ")
    data_df = purrr::map_df(split_dash, function(in_dash){
      in_dash = trimws(in_dash)
      # remove medicine amounts
      in_dash = gsub(";.*", "", in_dash)
      timepoint = in_dash[1]
      n_entry = length(in_dash)
      tibble::tibble(timepoint = in_dash[1], what = in_dash[2:n_entry])
    })
    data_df$class = gsub("^## ", "", journal_contents[second_header_locs[iloc]])
    out_list_data[[iloc]] = data_df
  }
}
