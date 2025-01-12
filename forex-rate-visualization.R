# load required packages
if (!require("pacman")) install.packages("pacman")

pacman::p_load(dplyr, ggplot2, magrittr, tidyr)



# extract data from national database
url <- paste0(
  "https://www150.statcan.gc.ca/t1/tbl1/en/dtl!downloadDbLoadingData" ,
  "-nonTraduit.action?pid=3310003601&latestN=0&startDate=20230109&" ,
  "endDate=20250108&csvLocale=en&selectedMembers" , 
  "=%5B%5B1%5D%2C%5B1%2C2%2C3%2C4%2C5%2C6%2C7%2C8%2C9%2C10%2C11%2C12%", 
  "2C13%2C14%2C15%2C16%2C17%2C18%2C19%2C20%2C21%2C22%2C23%2C24%2C25%2C26%5D%5D", 
  "&checkedLevels="
)
download.file(url, destfile = "data.csv")

# save data
data <- read.csv("data.csv")

# data cleaning
data$REF_DATE <- as.Date(data$REF_DATE) # convert to date format
data <- data %>% filter(!is.na(VALUE)) # get rid of missing values

# optional: specify currencies to graph
# data %<>%
#   filter(Type.of.currency %in% c(
#     "U.S. dollar, daily average",
#     "European euro, daily average",
#     "Hong Kong dollar, daily average"
#   ))

# pivot the data from long to wide for plotting
pivot_data <- data %>%
  select(REF_DATE, Type.of.currency, VALUE) %>%
  pivot_wider(names_from = Type.of.currency, values_from = VALUE)

# plot the data
ggplot(data, aes(x = REF_DATE, y = VALUE, color = Type.of.currency)) +
  geom_line(aes(group = Type.of.currency), size = 1.1) +
  labs(
    title = "Exchange Rates (Canadian Dollars to Other Currencies)",
    x = "Date",
    y = "Exchange Rate",
    color = "Currency"
  ) +
  # manually selecting colors so they don't repeat 
  scale_color_manual(values = c( 
    "Australian dollar, daily average" = "#ffbb78",
    "Brazilian real, daily average" = "#1f77b4",
    "Chinese renminbi, daily average" = "#aec7e8",
    "European euro, daily average" = "#ff7f0e",
    "Hong Kong dollar, daily average" = "#40edd3",
    "Indian rupee, daily average" = "#2ca02c",
    "Indonesian rupiah, daily average" = "#98df8a",
    "Japanese yen, daily average" = "#d62728",
    "Mexican peso, daily average" = "#ff9896",
    "New Zealand dollar, daily average" = "#9467bd",
    "Norwegian krone, daily average" = "#c5b0d5",
    "Peruvian new sol, daily average" = "#3a3b35",
    "Russian ruble, daily average" = "#8c564b",
    "Saudi riyal, daily average" = "#c49c94",
    "Singapore dollar, daily average" = "#e377c2",
    "South African rand, daily average" = "#f7b6d2",
    "South Korean won, daily average" = "#7f7f7f",
    "Swedish krona, daily average" = "#c7c7c7",
    "Swiss franc, daily average" = "#bcbd22",
    "Taiwanese dollar, daily average" = "#dbdb8d",
    "Turkish lira, daily average" = "#17becf",
    "U.K. pound sterling, daily average" = "#9edae5",
    "U.S. dollar, daily average" = "#f0df26"
  )) + 
  theme_minimal() +
  theme(
    legend.position = "right",
    plot.title = element_text(size = 16, face = "bold"),
    axis.title = element_text(size = 12)
  )


# delete the .csv file so it doesn't interfere with 
# the program in the future
file.remove("data.csv")
