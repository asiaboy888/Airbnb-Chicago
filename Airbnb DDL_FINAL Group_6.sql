

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS airbnb;
CREATE SCHEMA airbnb;
USE airbnb;

--
-- Table structure for table `listing`
--

CREATE TABLE listing (
  listing_id INT NOT NULL,
  latitude FLOAT NOT NULL,
  longitude FLOAT NOT NULL,
  neighbourhood_id INT NOT NULL,
  property_id INT NOT NULL,
  room_id INT NOT NULL,
  instant_bookable VARCHAR(10) NOT NULL,
  accomodates INT NOT NULL,
  bathrooms_text VARCHAR(30),
  bedrooms VARCHAR(4),
  beds VARCHAR(4),
  price DECIMAL(8,2) NOT NULL,
  availability_30 INT NOT NULL,
  availability_60 INT NOT NULL,
  availability_90 INT NOT NULL,
  availability_365 INT NOT NULL,
  review_key INT,
  host_id INT NOT NULL,
  last_update DATE NOT NULL,
  PRIMARY KEY  (listing_id),
  CONSTRAINT `neighbourhood_listing_fk`
		FOREIGN KEY (`neighbourhood_id`)
		REFERENCES `airbnb`.`neighbourhood` (`neighbourhood_id`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
   CONSTRAINT `property_listing_fk`
		FOREIGN KEY (`property_id`)
		REFERENCES `airbnb`.`property` (`property_id`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	 CONSTRAINT `room_listing_fk`
		FOREIGN KEY (`room_id`)
		REFERENCES `airbnb`.`room` (`room_id`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	 CONSTRAINT `host_listing_fk`
		FOREIGN KEY (`host_id`)
		REFERENCES `airbnb`.`host` (`host_id`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
  ) 
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;
  
 # Table structure for table `neighbourhood`


CREATE TABLE neighbourhood (
  neighbourhood_id INT NOT NULL AUTO_INCREMENT,
  neighbourhood VARCHAR(30) NOT NULL,
  neighbourhood_latitude FLOAT NOT NULL,
  neighbourhood_longitude FLOAT NOT NULL,
  city_id INT NOT NULL,
  PRIMARY KEY  (neighbourhood_id),
  CONSTRAINT `city_neighbourhood_fk`
		FOREIGN KEY (`city_id`)
		REFERENCES `airbnb`.`city` (`city_id`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
  )
ENGINE=InnoDB 
DEFAULT CHARSET=latin1;
  
   #Table structure for table `city`
CREATE TABLE city (
   city_id INT NOT NULL AUTO_INCREMENT,
   city VARCHAR(20) NOT NULL,
   state VARCHAR(20) NOT NULL,
   country VARCHAR(20) NOT NULL,
   PRIMARY KEY (city_id)
   ) 
   ENGINE=InnoDB 
DEFAULT CHARSET=latin1;

   #Table structure for table `property`
   CREATE TABLE property (
   property_id INT NOT NULL AUTO_INCREMENT,
   property_type VARCHAR(50) NOT NULL,
   PRIMARY KEY (property_id)
   )
   ENGINE=InnoDB 
   DEFAULT CHARSET=latin1;

	#Table structure for table `room`
   CREATE TABLE room (
   room_id INT NOT NULL AUTO_INCREMENT,
   room_type VARCHAR(40) NOT NULL,
   PRIMARY KEY (room_id)
   )
   ENGINE=InnoDB 
   DEFAULT CHARSET=latin1;
   
     #Table structure for table `amenity`
   CREATE TABLE amenity (
   amenity_key INT NOT NULL,
   amenity_type VARCHAR(80),
   PRIMARY KEY (amenity_key)
   )
   ENGINE=InnoDB 
   DEFAULT CHARSET=latin1;
   
   
   #Table structure for table `listing_amenity`
   CREATE TABLE listing_amenity (
   listing_id INT NOT NULL,
   amenity_key INT NOT NULL,
   CONSTRAINT `listing_listing_amenity_fk`
		FOREIGN KEY (`listing_id`)
		REFERENCES `airbnb`.`listing` (`listing_id`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT `amenity_listing_amenity_fk`
		FOREIGN KEY (`amenity_key`)
		REFERENCES `airbnb`.`amenity` (`amenity_key`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
   )
   ENGINE=InnoDB 
   DEFAULT CHARSET=latin1;
      
    #Table structure for table `review`
 CREATE TABLE review (
   review_key INT NOT NULL AUTO_INCREMENT,
   number_of_reviews INT NOT NULL,
   number_of_reviews_ltm INT NOT NULL,
   number_of_reviews_l30d INT NOT NULL,
   review_score_rating INT,
   review_scores_accuracy INT,
   review_scores_cleanliness INT,
   review_scores_checkin INT,
   review_scores_communication INT,
   review_scores_location INT,
   review_scores_value INT,
   listing_id INT NOT NULL UNIQUE,
   PRIMARY KEY (review_key),
	CONSTRAINT `listing_review_fk`
		FOREIGN KEY (`listing_id`)
		REFERENCES `airbnb`.`listing` (`listing_id`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION

   )
   ENGINE=InnoDB 
   DEFAULT CHARSET=latin1;
   
    #Table structure for table `host`
     CREATE TABLE host (
   host_id INT NOT NULL,
   host_since DATE NOT NULL,
   host_is_super_host VARCHAR(10) NOT NULL,
   host_response_rate FLOAT,
   host_has_profile_pic VARCHAR(10) NOT NULL,
   host_identity_verified VARCHAR(10) NOT NULL,
   PRIMARY KEY (host_id)
   )
   ENGINE=InnoDB 
   DEFAULT CHARSET=latin1;
   
	#Table structure for table `review_date`
   CREATE TABLE review_date (
   listing_id INT NOT NULL,
   review_date DATE NOT NULL,
   CONSTRAINT `listing_review_date_fk`
		FOREIGN KEY (`listing_id`)
		REFERENCES `airbnb`.`listing` (`listing_id`)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
   )
   ENGINE=InnoDB 
   DEFAULT CHARSET=latin1;