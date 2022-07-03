journal_files = dir("daily_log", pattern = "md$", full.names = TRUE)


journal_process = function(file_path){
  # file_path = journal_files[1]
  all_contents = readLines(file_path)
}
