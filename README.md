# YouTube-Trending-Data-Lakehouse-with-Snowflake

This repository contains the code and documentation for the **Big Data Engineering** course's first assignment: **Data Lakehouse with Snowflake**. The goal of this project is to analyze a dataset of trending YouTube videos by leveraging a Data Lakehouse architecture using Snowflake.

## Table of Contents

- [Introduction](#introduction)
- [Dataset](#dataset)
- [Project Structure](#project-structure)
- [Tasks Overview](#tasks-overview)
  - [Part 1: Data Ingestion](#part-1-data-ingestion)
  - [Part 2: Data Cleaning](#part-2-data-cleaning)
  - [Part 3: Data Analysis](#part-3-data-analysis)
  - [Part 4: Business Question](#part-4-business-question)
- [Deliverables](#deliverables)
- [Handover Report](#handover-report)
- [How to Run](#how-to-run)
- [Assessment Criteria](#assessment-criteria)
- [Due Date](#due-date)
- [License](#license)

## Introduction

This project involves the creation of a Data Lakehouse using Snowflake to analyze trending YouTube video data from various countries. The analysis includes data ingestion, transformation, cleaning, and querying to derive insights from the dataset.

## Dataset

The dataset contains daily records of trending YouTube videos from multiple countries, covering a period from August 2020 to April 2024. The data includes video titles, channel titles, published times, views, likes, dislikes, and comment counts. The dataset is available on Kaggle: [YouTube Trending Video Dataset](https://www.kaggle.com/rsrishav/youtube-trending-video-dataset).

## Project Structure

- `part_1.sql` - SQL queries for data ingestion tasks.
- `part_2.sql` - SQL queries for data cleaning tasks.
- `part_3.sql` - SQL queries for data analysis tasks.
- `part_4.sql` - SQL queries for the business question.
- `handover_report.md` - A detailed report explaining the project, steps, issues, and solutions.

## Tasks Overview

### Part 1: Data Ingestion

The first part involves setting up the data lakehouse by ingesting data from cloud storage into Snowflake. The tasks include:
- Downloading the dataset and uploading it to Microsoft Azure.
- Creating external tables in Snowflake for the trending and category data.
- Transforming the data and storing it in structured tables.

### Part 2: Data Cleaning

The second part focuses on cleaning the ingested data, including:
- Identifying and handling duplicates.
- Filling missing values.
- Removing irrelevant records.

### Part 3: Data Analysis

In the third part, various SQL queries are used to analyze the data, such as:
- Identifying the most viewed videos in specific categories.
- Counting videos containing specific keywords.
- Calculating engagement metrics.

### Part 4: Business Question

The final part addresses a business question: If you were to launch a new YouTube channel, which category should you focus on to maximize the chances of appearing in the trending section, particularly in the US?


## How to Run

1. Set up a Snowflake account and Microsoft Azure storage account.
2. Upload the dataset to Azure.
3. Run the SQL scripts in sequence (`part_1.sql`, `part_2.sql`, `part_3.sql`, `part_4.sql`).
4. Review the output tables and analysis results.

## Assessment Criteria

The assignment will be assessed based on the quality of code, the accuracy of results, the clarity of the handover report, and the quality of findings and recommendations.


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
