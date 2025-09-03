library(dplyr)
library(xml2)
library(tools)  # For file_path_sans_ext

# Define filtering values - change if needed
comment_threshold <- 85  # Threshold for 'confidence' in step 3
hotspot_size_threshold <- 100000  # Threshold for 'CNV_size' when 'hotspot_region' is TRUE in step 6
non_hotspot_size_threshold <- 350000  # Threshold for 'CNV_size' when 'hotspot_region' is FALSE in step 7

# Read the XML file - change the name!!
xml_filename <- "2025_07_23_LT_MS_EW_cells.xml"
xml_data <- read_xml(xml_filename)

# Extract the base name of the XML file
base_name <- file_path_sans_ext(basename(xml_filename))

# Define hotspot locations directly in the script
hotspot_locations <- data.frame(
  hot_chr = c(20, 12, 17, 1, 5, 18, 17, 7, 9, 11, 13, 1, 8, 14, 6, 15, 3, 22),
  hot_start = c(31260580, 11784484, 53204134, 172930860, 105164299, 58532768, 7307685, 132915240, 40965786, 2778770, 87047745, 15873505, 92287772, 18375541, 129978855, 66907662, 19121, 23925838),
  hot_end = c(32166810, 25403186, 54216532, 185830860, 118068501, 63932768, 8140855, 134100999, 87165786, 10678770, 101047745, 16748447, 126218590, 106573063, 138678855, 67007662, 26358322, 49228316)
)

# Initialize lists to store extracted data
sample_ids <- c()
chr_nums <- c()
base_start_positions <- c()
base_end_positions <- c()
values <- c()
comments <- c()

# Iterate over each bookmark element and extract the required data
bookmarks <- xml_find_all(xml_data, ".//bookmark")
for (bookmark in bookmarks) {
  sample_id <- xml_text(xml_find_first(bookmark, "sample_id"))
  chr_num <- xml_text(xml_find_first(bookmark, "chr_num"))
  base_start_pos <- xml_text(xml_find_first(bookmark, "base_start_pos"))
  base_end_pos <- xml_text(xml_find_first(bookmark, "base_end_pos"))
  value <- xml_text(xml_find_first(bookmark, "value"))
  comment_text <- xml_text(xml_find_first(bookmark, "comment"))
  
  # Extract the number from the comment using regex
  comment_number <- as.numeric(sub(".*?(\\d+\\.\\d+).*", "\\1", comment_text))
  
  # Append the extracted data to the lists
  sample_ids <- c(sample_ids, sample_id)
  chr_nums <- c(chr_nums, chr_num)
  base_start_positions <- c(base_start_positions, base_start_pos)
  base_end_positions <- c(base_end_positions, base_end_pos)
  values <- c(values, value)
  comments <- c(comments, comment_number)
}

# Combine the extracted data into a data frame
extracted_data <- data.frame(
  sample_id = sample_ids,
  chr_num = chr_nums,
  base_start_pos = base_start_positions,
  base_end_pos = base_end_positions,
  value = values,
  comment = comments,
  stringsAsFactors = FALSE
)

# Rename columns before saving the extracted data
extracted_data <- extracted_data %>%
  rename(confidence = comment)

# Save the data frame to a CSV file with the XML filename as prefix
write.csv(extracted_data, paste0(base_name, "_extracted_data.csv"), row.names = FALSE)

# Print a message to confirm the data has been saved
print(paste("Data has been successfully saved to", paste0(base_name, "_extracted_data.csv")))

# Check the structure of the data
str(extracted_data)

# Convert to numeric and handle NAs
extracted_data <- extracted_data %>%
  mutate(base_end_pos = as.numeric(base_end_pos),
         base_start_pos = as.numeric(base_start_pos)) %>%
  filter(!is.na(base_end_pos) & !is.na(base_start_pos)) %>%
  mutate(CNV_size = base_end_pos - base_start_pos)

# Step 2: Create a column 'hotspot_region' with boolean values
extracted_data$hotspot_region <- FALSE

# Step 3: Keep only rows with 'confidence' greater than the threshold
extracted_data <- extracted_data %>%
  filter(confidence > comment_threshold)

# Step 4: Keep rows with 'value' equal to 2 and 'chr_num' different than 'X'
extracted_data <- extracted_data %>%
  filter(!(value == 2 & chr_num == "X"))

# Step 5: Check if the region is in the hotspot area
for (i in 1:nrow(extracted_data)) {
  if (extracted_data$value[i] != 2) {
    chr_matches <- hotspot_locations %>%
      filter(hot_chr == extracted_data$chr_num[i])
    
    if (nrow(chr_matches) > 0) {
      for (j in 1:nrow(chr_matches)) {
        if (!is.na(extracted_data$base_start_pos[i]) && !is.na(extracted_data$base_end_pos[i]) &&
            !is.na(chr_matches$hot_start[j]) && !is.na(chr_matches$hot_end[j])) {
          if ((extracted_data$base_start_pos[i] > chr_matches$hot_start[j] & extracted_data$base_start_pos[i] < chr_matches$hot_end[j]) |
              (extracted_data$base_end_pos[i] > chr_matches$hot_start[j] & extracted_data$base_end_pos[i] < chr_matches$hot_end[j])) {
            extracted_data$hotspot_region[i] <- TRUE
            break
          }
        }
      }
    }
  }
}

# Step 6: Keep rows with 'hotspot_region' TRUE and 'CNV_size' greater than the threshold
# Step 7: Keep rows with 'hotspot_region' FALSE and 'CNV_size' greater than the threshold
filtered_data <- extracted_data %>%
  filter((hotspot_region == TRUE & CNV_size > hotspot_size_threshold) |
           (hotspot_region == FALSE & CNV_size > non_hotspot_size_threshold))

# Print the number of rows where 'hotspot_region' is TRUE
hotspot_true_count <- filtered_data %>%
  filter(hotspot_region == TRUE) %>%
  nrow()

print(paste("Number of rows with hotspot_region = TRUE:", hotspot_true_count))

# Save the filtered data to a new CSV file with the XML filename as prefix
write.csv(filtered_data, paste0(base_name, "_filtered_data.csv"), row.names = FALSE)

# Print a message to confirm the data has been saved
print(paste("Filtered data has been successfully saved to", paste0(base_name, "_filtered_data.csv")))
