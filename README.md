# 👁️ Visualizing Reader Focus: Eye-Tracking Fixation Analysis in R 

## 🚀 Project Overview
This project explores eye-tracking fixation data collected during a reading experiment. Using R, we analyze how participants' visual attention shifts across different Areas of Interest (AOIs) in reading materials. The analysis provides insightful patterns of reader engagement and focus.

## 📁 Dataset Information
The dataset consists of 10 sheets, each representing a unique reading material. Each sheet contains fixation data across 20 AOIs, representing different sections of the text. The primary goal is to analyze how much focus is given to each AOI by participants.

### 🔗 Files:
- **ET_analysis1.R**: The R script for processing, analyzing, and visualizing the eye-tracking data.
- **Eye_Tracking_Reading_Experiment_Report.pdf**: A detailed report of the analysis, key findings, and insights.
- **README.md**: This file.

## 🎯 Analysis Objectives
The analysis covers multiple objectives:
1. Calculate fixation frequencies for all AOIs.
2. Visualize fixation frequencies using bar charts, heatmaps, and line charts.
3. Compare fixation patterns across multiple datasets and AOIs.
4. Extract key insights on visual attention during reading.

## 📊 Key Visualizations
Here are the key visualizations generated during the analysis:
1. **📈 Fixation Frequency Across All AOIs (Sorted)**: Sorted bar chart showing the total fixation counts for each AOI.
2. **🔥 Heatmap of Fixation Frequencies (All Datasets)**: A heatmap representing fixation concentration across AOIs and datasets.
3. **📊 Fixation Comparison Between Datasets (Faceted)**: A faceted bar chart comparing fixation counts for each AOI across datasets.
4. **📉 Distribution of Total Fixations per Participant**: A set of histograms visualizing fixation distribution across participants and datasets.
5. **📦 Box Plot of Total Fixations per Participant**: A box plot visualizing the distribution of fixations across different datasets.
6. **📉 Fixation Trends for AOIs s01 to s10**: A line chart tracking fixation trends for AOIs s01 to s10.
7. **📉 Fixation Trends for AOIs s11 to s20**: A line chart showing fixation trends for AOIs s11 to s20.

## 🛠️ Tools and Libraries Used
- **R**: Primary tool for data analysis.
- **ggplot2**: For creating all visualizations.
- **dplyr**: For data manipulation and preparation.
- **readxl**: To import the Excel dataset.
- **reshape2**: To transform the data into a format suitable for visualization.

## 📌 Key Insights
- AOIs attract varying levels of attention, with specific areas consistently receiving higher focus.
- Each dataset shows distinct fixation patterns, suggesting differences in reading engagement.
- Visual attention trends shift unpredictably across AOIs and datasets, providing insights into how different reading materials influence focus.

## 📝 Conclusion
This project successfully highlights the patterns of reader focus through eye-tracking data analysis. By visualizing fixation data across multiple reading materials, we gain insights into reader engagement and attention allocation.
