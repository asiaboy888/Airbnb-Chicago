rm(list = ls())
#library(mctest)
dataPath <- "C:/Users/mars_/Documents/Personal Document/MSCA classes/MSCA 31012 2 Data Engineering Platforms for Analytics/Final project/"


listing <- read.csv(file=paste0(dataPath,"listings v3.csv"))
listing_amenity <- read.csv(file=paste0(dataPath,"listing_amenity table.csv"),header = FALSE)

# Define top amenities by frequency
top_12 <- c(34,22,18,11,45,31,7,15,3,14,24,2)
top_10 <- top_12[1:10]
top_5 <- top_12[1:5]
top_3 <- top_12[1:3]


# Create list of list that show the amenity_ids for each listing
listing_id <- listing$id
listing_amenity_list <- vector(mode = "list", length = length(listing_id))
names(listing_amenity_list) <- listing_id
for (i in 1:length(listing_amenity$V1)) {
  for (j in 1:length(listing$id)) {
    if (listing$id[j] == listing_amenity$V1[i]) {
      listing_amenity_list[[j]] <- append(listing_amenity_list[[j]], listing_amenity$V2[i])
    }
  }
}

#save(listing_amenity_list, file = "C:/Users/ygao3/Documents/Personal Document/MSCA classes/MSCA 31012 2 Data Engineering Platforms for Analytics/Final project/listing_amenity_list.RData")

# Define binary vector good_amenity that is TRUE if all the top amenities are included for a listing, and FALSE otherwise
good_amenity <- c()
for (k in 1:length(listing_amenity_list)) {
  if (all(top_10 %in% listing_amenity_list[[k]])) {
    good_amenity[k] <- "TRUE"
  }
  else {
    good_amenity[k] <- "FALSE"
  }
}
names(good_amenity) <- "good_amenity"

# Create listing_y1 and listing_y2 that are corresponding to the response booked_30 and review_scores_rating
#booked_365 <- 365- listing$availability_365
booked_30 <- 30 - listing$availability_30
names(booked_30) <- "booked_365"
listing <- cbind(listing, good_amenity,booked_30)
listing_y1 <- listing
#listing_y1 <- listing_y1[listing$host_response_rate != '',]
listing_y1 <- listing_y1[!is.na(listing$host_response_rate),]
#listing_y1 <- na.omit(listing_y1)
listing_y2 <- listing
#listing_y2 <- listing_y2[listing$host_response_rate != '' & listing$review_scores_rating != '' & (listing$number_of_reviews > 2),]
listing_y2 <- listing_y2[!is.na(listing$host_response_rate) & !is.na(listing$review_scores_rating) & (listing$number_of_reviews > 100),]
#listing_y2 <- na.omit(listing_y2)

# Run lm for listing_y1 and listing_y2, and remove insignificant variables 
listing_y1_lm<-lm(booked_30~price+neighbourhood+number_of_reviews+room_type+accommodates+instant_bookable+host_is_superhost+host_identity_verified
+host_has_profile_pic+host_response_rate+good_amenity,listing_y1)
summary(listing_y1_lm)
listing_y1_final_lm <- step(listing_y1_lm,direction="both")
summary(listing_y1_final_lm)
#imcdiag(listing_y1_final_lm)
#plot(listing_y1_final_lm$fitted.values,listing_y1_final_lm$residuals)
listing_y2_lm<-lm(review_scores_rating~price+neighbourhood+number_of_reviews+room_type+accommodates+instant_bookable+host_is_superhost+host_identity_verified
                  +host_has_profile_pic+host_response_rate+good_amenity,listing_y2)
summary(listing_y2_lm)
listing_y2_final_lm <- step(listing_y2_lm,direction="both")
summary(listing_y2_final_lm)
data.frame("variable" = c("host_is_superhost"
                          ,"neighbourhood"
                          ,"accommodates"
                          ,"price"
                          ,"number_of_reviews"
                          ,"room_type"
                          ,"instant_bookable"
                          ,"host_response_rate"),
           "AIC" = c(1659.8
                     ,1348.4
                     ,1310.3
                     ,1310
                     ,1305.7
                     ,1304.8
                     ,1304
                     ,1301.2
           ))

barplot( c(1659.8
           ,1348.4
           ,1310.3
           ,1310
           ,1305.7
           ,1304.8
           ,1304
           ,1301.2
),names.arg = c("host_is_superhost"
                ,"neighbourhood"
                ,"accommodates"
                ,"price"
                ,"number_of_reviews"
                ,"room_type"
                ,"instant_bookable"
                ,"host_response_rate"),width = 1, main = "The important of final variables",xlab = "VARIABLE", ylab = "AIC", ylim = c(0,2000))
#imcdiag(listing_y2_final_lm)
