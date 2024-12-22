use serde::{Deserialize, Serialize};
use sqlx::FromRow;

#[derive(Debug, FromRow, Deserialize, Serialize)]
pub struct Sector {
    pub id: i32,
    pub name: String,
    pub x: i32,
    pub y: i32,
    pub abbreviation: String
}