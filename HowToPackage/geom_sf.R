# set wd
setwd("~/Desktop/geo_plot")

# pacakage
library(maps)
library(tidyverse)
#library(viridis)
library(ggthemes)
library(ggmap)
library(sf)
library(dplyr)
library(classInt)
library(ggplot2)
library(stringi)
library(foreach)
library(readr)

# layer
japan_map <- st_read("shape/japan_ver81.shp")
# csv
data <- read_csv("geo_customer_store.csv")
data_ <- data %>% 
  filter(lon > 138.5 & lon < 141) %>% 
  filter(lat > 34.8 & lat < 36.4) %>% 
  filter(!is.na(lon)|!is.na(lat)) # Na 行削除
data_ <- st_as_sf(data_, coords = c("lon", "lat"), crs=4326) # 緯度経度を扱うために必要

# select data
Kanto_map <- japan_map %>% 
  filter((KEN == "東京都" & (grepl("区",SIKUCHOSON)|grepl("市",SIKUCHOSON)|SIKUCHOSON == "日の出町"|SIKUCHOSON == "瑞穂町"|
                            SIKUCHOSON == "奥多摩町"|SIKUCHOSON == "檜原村"))|
          KEN == "千葉県"|KEN == "神奈川県"|KEN == "埼玉県"|KEN == "茨城県"|KEN == "栃木県"|KEN == "群馬県")
Tokyo_map <- japan_map %>% 
  filter((KEN == "東京都" & (grepl("区",SIKUCHOSON)|grepl("市",SIKUCHOSON)|SIKUCHOSON == "日の出町"|SIKUCHOSON == "瑞穂町"|
                            SIKUCHOSON == "奥多摩町"|SIKUCHOSON == "檜原村")))

# plot map  
ggplot() +
  geom_sf(data = Kanto_map,colour = "white") +
  scale_y_continuous(limits = c(35,36.3)) +
  theme(legend.position = "none")

# plot map and data
ggplot() +
  geom_sf(data = Kanto_map,lwd=0) +
  geom_sf(data = data_[1:100,], color = "black",size=0.5) +
  scale_y_continuous(limits = c(35,36.3)) +
  facet_wrap(~mode_store) +
  labs(title = "kanto") + 
  theme_classic()
