if(!require("pacman")) install.packages("pacman")
pacman::p_load(
  here, DescTools, tidyverse, magrittr, janitor,
  knitr, kableExtra, patchwork, ggpubr, gt, gtsummary
)


here::i_am(
  "analysis/01_tabular.R"
)


survey <- read.csv(here::here("data",
                              "raw", "surveysDepreST-CAT.csv"))

colnames(survey) <- gsub("\\.\\.\\.", " ", colnames(survey))
survey  %<>%
  filter(complete.cases(.)) %>%
  filter(PriorDepressionTreatment %in% c("Yes", "No")) %>%
  mutate(
    StudentStatus = case_when(
      str_detect(StudentStatus, "^No") ~ "Not Student",
      TRUE ~ "Student"
    ),
    
    Remote = case_when(
      str_detect(Remote, "^No") ~ "Not Remote",
      TRUE ~ "Remote"
    ),
    
    Group = case_when(
      str_detect(Group, "^Asian") ~ "Asian",
      str_detect(Group, "^Black") ~ "Black",
      str_detect(Group, "^Hispanic") ~ "Hispanic",
      str_detect(Group, "^Native") ~ "Native American",
      str_detect(Group, "^White") ~ "White",
      TRUE ~ "Other"
    ),
    
    Age = case_when(
      Age %in% c("40-55", "56+") ~ "40+",
      TRUE ~ Age
    )
  )

saveRDS(survey, here::here("data/intermediate/survey.rds"))

p <- survey %>%
  select(-c(id, Timestamp, id, `PHQ Total`, `GAD Total`)) %>%
  tbl_summary(
    by = appVersion,  
    label = list(
      PriorDepressionTreatment ~ "Previous Depression Treatment", 
      Gender ~ "Gender",
      Age ~ "Age",
      StudentStatus ~ "Student Status",
      Remote ~ "Remote",
      COVID ~ "COVID-19",
      Group ~ " Race Group"
    ),
    statistic = list(
      all_categorical() ~ "{n} ({p}%)",
      all_continuous2() ~ c("{mean} ({sd})", "{min}, {max}")
    ),
    percent = "row"
  ) %>%
  bold_labels() %>%
  add_overall(statistic = all_categorical() ~ "{n}") %>%
  add_p(test = list(
    all_categorical() ~ "chisq.test",
    all_continuous() ~ "t.test"
  )) %>%
  bold_p() %>%
  modify_spanning_header(c("stat_1", "stat_2") ~ "**Data Collection Method**") %>%
  as_gt()


saveRDS(p, here::here("output/tabular.rds"))