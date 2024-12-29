use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use serde_json::Value;

#[derive(Debug, FromRow, Deserialize, Serialize)]
pub struct Sector {
    pub id: i32,
    pub name: String,
    pub x: i32,
    pub y: i32,
    pub abbreviation: String
}

#[derive(Debug, Serialize, FromRow)]
pub struct SolarSystem {
    pub sector_x: i32,
    pub sector_y: i32,
    pub sector_name: String,
    pub name: String,
    pub x: i32,
    pub y: i32,
    pub scan_points: i32,
    pub survey_index: i32,
    pub gas_giant_count: i32,
    pub planetoid_belt_count: i32,
    pub terrestrial_planet_count: i32,
    pub bases: String,
    pub remarks: String,
    pub native_sophont: bool,
    pub extinct_sophont: bool,
    pub star_count: i32,
    pub main_world: Value,
    pub primary_star: Value,
    pub stars: Value,
    pub allegiance: Option<String>,
}

#[derive(Debug, Serialize, FromRow)]
pub struct SolarSystemStars {
    pub sector_x: i32,
    pub sector_y: i32,
    pub sector_name: String,
    pub name: String,
    pub x: i32,
    pub y: i32,
    pub scan_points: i32,
    pub survey_index: i32,
    pub gas_giant_count: i32,
    pub planetoid_belt_count: i32,
    pub terrestrial_planet_count: i32,
    pub stars: Value,
    pub allegiance: Option<String>,
}