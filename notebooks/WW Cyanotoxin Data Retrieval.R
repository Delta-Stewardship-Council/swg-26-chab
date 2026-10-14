library(dataRetrieval)
library(writexl)
library(dplyr)

# Define stations and parameter codes
site_no <- c(
  "USGS-380640121405701", "USGS-380504121405601", "USGS-380232121241801", "USGS-375952121243601",
  "USGS-375949121251001", "USGS-374045121155200", "USGS-380348121511801", "USGS-11455508",
  "USGS-11455478", "USGS-380217121290301", "USGS-11313440", "USGS-11447650", "USGS-380245121354801",
  "USGS-380749121344701", "USGS-380856121352901", "USGS-380631122032201", "USGS-382205121311300",
  "USGS-381038121352501", "USGS-11455315", "USGS-11336790", "USGS-381540121445301", "USGS-375713121174401",
  "USGS-11312676", "USGS-383340121310601", "USGS-11185185", "USGS-11312674", "USGS-11312685",
  "USGS-11336685", "USGS-380837121333401", "USGS-11313405", "USGS-11313250", "USGS-380300121344801",
  "USGS-11313325", "USGS-380412121344001", "USGS-375841121225601", "USGS-381424121405601",
  "USGS-11313460", "USGS-381627121395101", "USGS-11455420", "USGS-375747121215401", "USGS-380931121410501",
  "USGS-11455385", "USGS-11447890", "USGS-11455276", "USGS-375944121252301", "USGS-11337190",
  "USGS-375711121182001", "USGS-375719121205401", "USGS-375709121190301", "USGS-375831121223701",
  "USGS-380353121403701", "USGS-375706121201001", "USGS-375615121200501", "USGS-380536121342901",
  "USGS-375649121202101", "USGS-380500121351901", "USGS-380131121280501", "USGS-380831121301301",
  "USGS-382010121402301", "USGS-380831121281201", "USGS-11455485", "USGS-11311300",
  "USGS-381330121332401", "USGS-11447540"
)

discrete_parm_code <- c(
  "57793", "57791", "57792", "57794", "89025", "89031", "68287", "57795",
  "57796", "89026", "89009", "57798", "57797", "52686", "89027", "89029",
  "52690", "52836", "57789", "52688", "52694", "57788", "57790", "52695",
  "52689", "63686", "52691", "52693", "57787", "52692", "89030", "52696",
  "89007", "57801", "57802", "57800", "57799", "89028"
)

begin_date <- "2020-07-27"
end_date <- "2024-12-17"

# Initialize list
all_data_list <- list()

# Loop over each site
for (i in site_no) {
  message("Retrieving data for site: ", i)
  df <- tryCatch({
    readWQPqw(i, discrete_parm_code, begin_date, end_date, legacy = FALSE)
  }, error = function(e) {
    warning(paste("Failed to retrieve data for site:", i))
    return(NULL)
  })
  
  if (!is.null(df)) {
    df$SiteID <- i
    df <- mutate_all(df, as.character)  # <-- Convert all columns to character
    all_data_list[[i]] <- df
  }
}

# Combine and write
all_data_combined <- bind_rows(all_data_list)
write_xlsx(all_data_combined, paste0("WW_Cyanotoxin_Data_", begin_date, "_to_", end_date, ".xlsx"))
