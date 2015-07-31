# Source data:
# http://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/DEMO_G.XPT
# http://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/BMX_G.XPT

library(dplyr)
library(foreign)

demo = read.xport("DEMO_G.XPT")
bmx = read.xport("BMX_G.XPT")

# BMXHT: Standing height (cm), subjects 2 years - 150 years
# RIAGENDR: Gender; 1 (male), 2 (female)
# DMDBORN4: Country of birth; 1 for US, 2 for others
# INDFMPIR: Ratio of family income to poverty (0..5)

combined = inner_join(demo, bmx)
height_gender = combined %>%
  filter(!is.na(RIAGENDR), !is.na(BMXHT), !is.na(DMDBORN4), !is.na(INDFMPIR)) %>%
  transmute(Gender=RIAGENDR, Height_cm=BMXHT, US_born=DMDBORN4 == 1, Poverty=INDFMPIR <= 1)
height_gender$Gender = factor(height_gender$Gender, levels=c(1,2), labels=c("Male", "Female"))

write.csv(height_gender, "height_gender.csv", row.names=FALSE, quote=FALSE)