import pandas as pd
import numpy as np
import os

## Load listing_amenity csv file
listing_amenity = pd.read_csv("C://Users/mars_/Documents/Personal Document/MSCA classes/MSCA 31012 2 Data Engineering Platforms for Analytics/Final project/listings_amenity.csv")

## Define length of flattened amenities
row_len = sum(list(map(lambda x: len(x.split(", ")), listing_amenity['amenities'])))
amenity_table = pd.DataFrame(index=range(row_len), columns=range(2))
n = -1

## Flatten listing amenity relationship
for i in range(len(listing_amenity)):
    for j in range(len(listing_amenity['amenities'][i].split(", "))):
        n = n + 1
        amenity_table.iloc[n, 0] = listing_amenity['id'][i]
        amenity_table.iloc[n, 1] = listing_amenity['amenities'][i].split(", ")[j].replace('[','').replace(']','').replace('"','')
amenity_table.columns =['listing_id', 'amenity']

## Setup amenity_key and amenity table without duplicates
amenity_nodup = list(dict.fromkeys(list(amenity_table['amenity'])))
amenity_key_table = pd.DataFrame(index=range(len(amenity_nodup)), columns=range(2))
for k in range(len(amenity_key_table)):
    amenity_key_table.iloc[k, 0] = k + 1
    amenity_key_table.iloc[k, 1] = amenity_nodup[k]
amenity_key_table.columns =['amenity_key', 'amenity']

## Create table with listing_id and amenity_key
listing_amenity_table = pd.merge(amenity_table,amenity_key_table,on='amenity')
listing_amenity_table = listing_amenity_table.drop(columns='amenity')
listing_amenity_table = listing_amenity_table.sort_values(by=['listing_id','amenity_key'])

amenity_key_table.to_csv('C://Users/mars_/Documents/Personal Document/MSCA classes/MSCA 31012 2 Data Engineering Platforms for Analytics/Final project/amenity.csv', header=False,index=False)
listing_amenity_table.to_csv('C://Users/mars_/Documents/Personal Document/MSCA classes/MSCA 31012 2 Data Engineering Platforms for Analytics/Final project/listing_amenity.csv', header=False,index=False)
