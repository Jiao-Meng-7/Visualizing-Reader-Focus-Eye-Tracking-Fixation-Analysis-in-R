# Load necessary libraries
library(readxl)
library(ggplot2)
library(dplyr)
library(reshape2)

# Step 1: Load and Merge All Datasets
# Create a list of file names (assuming they are in the working directory)
files <- list.files(pattern = "*.xlsx")

# Initialize an empty list to store data from all files
data_list <- list()

# Loop through each file and read the data
for (i in seq_along(files)) {
  data <- read_excel(files[i])
  # Append the dataset to the list using the index 'i'
  data_list[[i]] <- data
}

# Combine all datasets into one large data frame
merged_data <- bind_rows(data_list, .id = "Dataset")

# Step 2: Data Preprocessing
# Convert -1 to 0 for missing fixation data
merged_data[merged_data == -1] <- 0


# Step 3: Fixation Frequency Calculation Across All Datasets
# Sum the fixation counts across all datasets for each AOI (column)
fixation_counts <- colSums(merged_data[-1] == 1)  # Exclude "Dataset" column

# Step 4: Visualize Fixation Frequency Across All AOIs
ggplot(data.frame(AOI = names(fixation_counts), Count = fixation_counts), aes(x = AOI, y = Count)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Fixation Frequency Across All AOIs (Combined Data)", x = "AOIs", y = "Fixation Count") +
  theme_minimal()

# Step 4.1: Visualize Fixation Frequency Sorted from Smallest to Largest
ggplot(data.frame(AOI = reorder(names(fixation_counts), fixation_counts), Count = fixation_counts), aes(x = AOI, y = Count)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Fixation Frequency Across All AOIs (Sorted)", x = "AOIs", y = "Fixation Count") +
  theme_minimal()

# Step 5: Heatmap of Fixation Patterns Across All Datasets
# Specify 'Dataset' as the ID variable to exclude it from being melted
melted_data <- melt(merged_data, id.vars = "Dataset")  # Specify "Dataset" as the ID

# Create the heatmap
# Create the heatmap with a custom legend title
ggplot(melted_data, aes(x = variable, y = Dataset, fill = value)) +
  geom_tile() +
  scale_fill_viridis_c(option = "magma", name = "Fixation Count") +  # Change the legend title here
  labs(title = "Heatmap of Fixation Frequencies (All Datasets)", x = "AOIs", y = "Datasets") +
  theme_minimal()


# Step 6: Compare Fixation Behavior Between Datasets
# Group by dataset and calculate fixation statistics for comparison
fixation_by_dataset <- merged_data %>%
  group_by(Dataset) %>%
  summarize(across(starts_with("s"), ~ sum(. == 1)))

# Visualize comparison of fixation counts between datasets
melted_dataset <- melt(fixation_by_dataset, id.vars = "Dataset")

ggplot(melted_dataset, aes(x = variable, y = value, fill = Dataset)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Fixation Comparison Between Datasets", x = "AOIs", y = "Fixation Count") +
  theme_minimal()

# Additional making: Use a Faceted Plot for Easier Comparison
ggplot(melted_dataset, aes(x = variable, y = value, fill = Dataset)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~ Dataset, scales = "free_x") +  # Facet by Dataset
  labs(title = "Fixation Comparison Between Datasets (Faceted)", x = "AOIs", y = "Fixation Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1), strip.text.x = element_text(size = 10))


# Step 7: Distribution of Total Fixations per Dataset
merged_data$total_fixations <- rowSums(merged_data[-1] == 1)

# 7.1 Distribution of Total Fixations per Participant Across Datasets
ggplot(merged_data, aes(x = total_fixations, fill = as.factor(Dataset))) +
  geom_histogram(binwidth = 2, color = "black", position = "dodge") +  # Increase bin width for clarity
  scale_fill_brewer(palette = "Set3") +  # Use a simpler color palette
  facet_wrap(~ Dataset, scales = "free_y") +  # Facet by Dataset to make comparison easier
  labs(title = "Distribution of Total Fixations per Participant Across Datasets",
       x = "Total Fixations",
       y = "Count of Participants",
       fill = "Dataset") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),  # Rotate x-axis labels for readability
        legend.position = "bottom")  # Move legend to the bottom for better visibility

# 7.2: Box Plot of Total Fixations per Participant Across Datasets
ggplot(merged_data, aes(x = factor(Dataset, levels = 1:10), y = total_fixations, fill = as.factor(Dataset))) +
  geom_boxplot(outlier.colour = "red", outlier.shape = 16, outlier.size = 2) +  # Highlight outliers
  scale_fill_brewer(palette = "Set3") +  # Use a color palette to distinguish datasets
  labs(title = "Box Plot of Total Fixations per Participant Across Datasets",
       x = "Dataset", y = "Total Fixations", fill = "Dataset") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for readability

# 7.3: Faceted Density Plot for Each Dataset
ggplot(merged_data, aes(x = total_fixations, fill = as.factor(Dataset))) +
  geom_density(alpha = 0.6) +  # Density plot with transparency
  scale_fill_brewer(palette = "Set3") +  # Use a color palette to distinguish datasets
  facet_wrap(~ Dataset, scales = "free") +  # Facet by dataset
  labs(title = "Faceted Density Plot of Total Fixations per Participant Across Datasets",
       x = "Total Fixations", y = "Density", fill = "Dataset") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "none")  # Remove legend for faceted plots


# Step 8: Line Chart for Fixation Trends Across Datasets by AOI
# Step 1: Replace Missing Values with Zero for both subsets and ensure Dataset is ordered
# Fix subset_AOI_1_10 for AOIs s01 to s10
subset_AOI_1_10 <- melted_dataset %>%
  filter(variable %in% paste0("s", sprintf("%02d", 1:10))) %>%
  mutate(value = ifelse(is.na(value), 0, value),
         Dataset = factor(Dataset, levels = 1:10))  # Order dataset from 1 to 10

# Fix subset_AOI_11_20 for AOIs s11 to s20
subset_AOI_11_20 <- melted_dataset %>%
  filter(variable %in% paste0("s", sprintf("%02d", 11:20))) %>%
  mutate(value = ifelse(is.na(value), 0, value),
         Dataset = factor(Dataset, levels = 1:10))  # Order dataset from 1 to 10

# Line Chart for AOIs s01 to s10
ggplot(subset_AOI_1_10, aes(x = as.factor(Dataset), y = value, group = variable, color = variable)) +
  geom_line(size = 1.2) +  # Draw lines between datasets for each AOI
  geom_point(size = 2) +  # Add points to emphasize data points
  scale_color_brewer(palette = "Paired") +  # Use a color palette that supports more colors
  labs(title = "Fixation Trends for AOIs s01 to s10 Across Datasets", x = "Dataset", y = "Fixation Count", color = "AOI") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for readability

# Line Chart for AOIs s11 to s20 
ggplot(subset_AOI_11_20, aes(x = as.factor(Dataset), y = value, group = variable, color = variable)) +
  geom_line(size = 1.2) +  # Draw lines between datasets for each AOI
  geom_point(size = 2) +  # Add points to emphasize data points
  scale_color_brewer(palette = "Paired") +  # Use a color palette that supports more colors
  labs(title = "Fixation Trends for AOIs s11 to s20 Across Datasets", x = "Dataset", y = "Fixation Count", color = "AOI") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for readability


