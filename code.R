
library(readxl)
library(readr)
library(dplyr)
library(tidyr)
library(lubridate)
library(writexl)
library(stringr)
library(ggplot2)

#PHẦN 1: ĐỌC VÀ CHUYỂN ĐỔI DỮ LIỆU TỪ FILE GỐC 
fname <- "D:/KPDL/BT/TH2_Input_22166022.xlsx"
allSheets <- excel_sheets(fname)
allData <- tibble()

for (sheet_name in allSheets) {
  temp <- read_excel(path = fname, sheet = sheet_name)
  if (nrow(temp) == 0) next  # Bỏ qua sheet trống
  
  names(temp)[1] <- "day"
  year_id <- trimws(sheet_name)
  
  temp <- temp %>% mutate(across(-day, as.character))  # Chuyển tất cả cột tháng sang ký tự
  
  temp_long <- temp %>%
    pivot_longer(-day, names_to = "month", values_to = "runoff") %>%
    mutate(
      runoff = na_if(runoff, "-"),
      runoff = as.numeric(runoff),
      month = str_remove(month, "\\."),
      month_num = case_when(
        month == "Jan" ~ 1, month == "Feb" ~ 2, month == "Mar" ~ 3,
        month == "Apr" ~ 4, month == "May" ~ 5, month == "Jun" ~ 6,
        month == "Jul" ~ 7, month == "Aug" ~ 8, month == "Sep" ~ 9,
        month == "Oct" ~ 10, month == "Nov" ~ 11, month == "Dec" ~ 12
      ),
      year_val = as.numeric(year_id),
      Dates = suppressWarnings(make_date(year_val, month_num, day)),
      year = year(Dates),
      month = month(Dates),
      day = day(Dates)
    ) %>%
    filter(!is.na(Dates)) %>%
    select(Dates, year, month, day, runoff)
  
  allData <- bind_rows(allData, temp_long)
}

allData <- allData %>% arrange(Dates)
write_xlsx(allData, "D:/KPDL/BT/TH2_Output_22166022.xlsx")


# PHẦN 2: XỬ LÝ VÀ THỐNG KÊ DỮ LIỆU DÒNG CHẢY 
data <- read_excel("D:/KPDL/BT/TH2_Output_22166022.xlsx")

data_filtered <- data %>%
  group_by(year, month) %>%
  mutate(n_rows = n(), na_count = sum(is.na(runoff))) %>%
  filter(na_count < n_rows) %>%
  ungroup()

month_avg <- data_filtered %>%
  group_by(year, month) %>%
  summarise(Month_Avg_Flow = mean(runoff, na.rm = TRUE), .groups = "drop")
write_xlsx(month_avg,"D:/KPDL/avg.xlsx")

stats <- data_filtered %>%
  group_by(month) %>%
  summarise(
    Mean   = mean(runoff, na.rm = TRUE),
    Median = median(runoff, na.rm = TRUE),
    Range  = max(runoff, na.rm = TRUE) - min(runoff, na.rm = TRUE),
    .groups = "drop")
write_xlsx(stats, "D:/KPDL/stats.xlsx")

hop <- data_filtered %>%
  filter(!is.na(runoff)) %>%
  group_by(month)

hop$month <- factor(hop$month, levels = 1:12, labels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                                         "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
ggplot(data = hop, mapping = aes(x = month, y = runoff)) +
  geom_boxplot(fill = "lightgreen", color = "black", outlier.colour = "red") +
  labs(
    title = "CHU KỲ BIẾN ĐỘNG CỦA DỮ LIỆU DÒNG CHẢY THEO THÁNG",
    y = "runoff (m³/s)"
  ) +
  theme(plot.title = element_text(hjust = 0.5))


#PHẦN 3: HỒI QUY GIỮA DÒNG CHẢY & THỜI GIAN 
data <- read_xlsx("D:/KPDL/avg.xlsx")
data$Time_decimal <- data$year + (data$month - 1) / 12
model <- lm(data = data, Month_Avg_Flow ~ Time_decimal)

ggplot(data, mapping = aes(x = Time_decimal, y = Month_Avg_Flow)) +
  geom_point(color = "black", alpha = 0.5) +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  labs(
    title = "Hồi quy giữa Month_Avg_Flow và Năm",
    x = "Năm",
    y = "Lưu lượng trung bình tháng (Month_Avg_Flow)"
  ) +
  scale_x_continuous(breaks = seq(1923, max(data$year), 5)) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))


# PHẦN 4: PHÂN TÍCH TƯƠNG QUAN VỚI CHỈ SỐ NINO 
nino <- read_excel("D:/KPDL/BT/nino34.long.anom.data.xlsx")

nino_summary <- nino %>%
  rowwise() %>%
  mutate(
    Year_Avg = mean(c_across(Jan:Dec), na.rm = TRUE),
    Jan_Apr_Avg = mean(c_across(Jan:Apr), na.rm = TRUE),
    May_Dec_Avg = mean(c_across(May:Dec), na.rm = TRUE)
  ) %>%
  ungroup() %>%
  select(year, Year_Avg, Jan_Apr_Avg, May_Dec_Avg)

data <- read_excel("D:/KPDL/BT/TH2_Output_22166022.xlsx")
flow_summary <- data %>%
  group_by(year) %>%
  summarise(
    Year_Avg = mean(runoff, na.rm = TRUE),
    Jan_Apr_Avg = mean(runoff[month >= 1 & month <= 4], na.rm = TRUE),
    May_Dec_Avg = mean(runoff[month >= 5 & month <= 12], na.rm = TRUE),
    .groups = "drop"
  )

combined_data <- left_join(flow_summary, nino_summary, by = "year")

data_filtered <- combined_data %>%
  filter(year >= 1922 & year <= 2018)

ggplot(data_filtered, aes(x = Year_Avg.y, y = Year_Avg.x)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "darkblue") +
  labs(
    title = "Hồi quy Year_Avg (1922-2018)",
    x = "Chỉ số Nino trung bình năm",
    y = "Dòng chảy trung bình năm"
  ) +
  theme_minimal()

ggplot(data_filtered, aes(x = Jan_Apr_Avg.y, y = Jan_Apr_Avg.x)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(
    title = "Hồi quy Jan_Apr_Avg (1922-2018)",
    x = "Chỉ số Nino trung bình mùa khô",
    y = "Dòng chảy trung bình mùa khô"
  ) +
  theme_minimal()

ggplot(data_filtered, aes(x = May_Dec_Avg.y, y = May_Dec_Avg.x)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "lightgreen") +
  labs(
    title = "Hồi quy May_Dec_Avg (1922-2018)",
    x = "Chỉ số Nino trung bình mùa lũ",
    y = "Dòng chảy trung bình mùa lũ"
  ) +
  theme_minimal()
