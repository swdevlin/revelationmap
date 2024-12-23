use crate::hex_address::SectorRegion;
use crate::hex_address::{HexAddress, MapRegion};
use crate::hexrange::map_region_to_sector_regions;
use crate::solarsystem::{SolarSystem, SolarSystemStars};
use crate::{
    model::Sector,
    AppState,
};
use actix_files::NamedFile;
use actix_web::{get, web, HttpRequest, HttpResponse, Responder};
use futures_util::StreamExt;
use serde_json::json;
use sqlx::Postgres;
use std::path::PathBuf;

#[get("/sectors")]
pub async fn sectors(data: web::Data<AppState>) -> impl Responder {

    let query_result = sqlx::query_as!(
        Sector,
        "SELECT * from sector ORDER by x, y"
    )
    .fetch_all(&data.db)
    .await;

    if query_result.is_err() {
        let message = "Something bad happened while fetching all note items";
        return HttpResponse::InternalServerError()
            .json(json!({"message": message}));
    }

    let sectors = query_result.unwrap();

    let json_response = serde_json::json!([
        sectors
    ]);
    HttpResponse::Ok().json(json_response)
}


#[get("/systemmap")]
pub async fn systemmap(address: web::Query<HexAddress>, data: web::Data<AppState>,  req: HttpRequest) -> impl Responder {
    match sqlx::query_as!(Sector, "SELECT * FROM sector WHERE x = $1 AND y = $2", address.sx, address.sy)
    .fetch_one(&data.db)
    .await {
        Ok(sector) => {
            let hex = format!("{:02}{:02}", address.hx, address.hy);
            let dir = std::env::var("STELLAR_DATA").unwrap_or_else(|_| "./data".to_string());
            let file_path = PathBuf::from(&dir)
                .join(&sector.name)
                .join(format!("{}-map.svg", hex));

            if !file_path.exists() {
                return HttpResponse::NotFound().body(format!("SVG file not found {} {} {}", dir, hex, &sector.name));
            }

            let named_file = match NamedFile::open(file_path) {
                Ok(file) => file,
                Err(err) => {
                    eprintln!("Error serving SVG file: {}", err);
                    return HttpResponse::InternalServerError().body("Error serving the SVG file");
                }
            };

            return named_file.into_response(&req);
        },
        Err(sqlx::Error::RowNotFound) => return HttpResponse::NotFound().body("Sector not found"),
        Err(err) => {
            eprintln!("Database error: {}", err);
            return HttpResponse::InternalServerError().body("Failed to retrieve sector");
        }
    };
}


fn add_where_clauses(builder: &mut sqlx::QueryBuilder<Postgres>, mapped_sectors: &Vec<SectorRegion>) {
    let mut joiner = "";
    for sector in mapped_sectors {
        builder.push(joiner);
        builder.push("(sector.x = ");
        builder.push_bind(sector.x);
        builder.push(" and sector.y = ");
        builder.push_bind(sector.y);
        builder.push(" and solar_system.x between ");
        builder.push_bind(sector.ulhx);
        builder.push(" and ");
        builder.push_bind(sector.lrhx);
        builder.push(" and solar_system.y between ");
        builder.push_bind(sector.ulhy);
        builder.push(" and ");
        builder.push_bind(sector.lrhy);
        builder.push(")");
        joiner = " and ";
    }
}

async fn fetch_rows<T>(
    query: sqlx::query::QueryAs<'_, Postgres, T, sqlx::postgres::PgArguments>,
    db: &sqlx::PgPool,
) -> Result<Vec<T>, HttpResponse>
where
    T: Send + Unpin + for<'r> sqlx::FromRow<'r, sqlx::postgres::PgRow>,
{
    let mut rows = query.fetch(db);
    let mut records = Vec::new();
    while let Some(row) = rows.next().await {
        match row {
            Ok(record) => records.push(record),
            Err(err) => {
                eprintln!("Error fetching row: {}", err);
                return Err(HttpResponse::InternalServerError().finish());
            }
        }
    }
    Ok(records)
}

#[get("/solarsystems")]
pub async fn solarsystems(params: MapRegion, data: web::Data<AppState>,  _req: HttpRequest) -> impl Responder {
    let mut builder: sqlx::QueryBuilder<Postgres> = sqlx::QueryBuilder::new("SELECT solar_system.*, sector.x as sector_x, sector.y as sector_y, sector.name as sector_name FROM solar_system ");
    builder.push("join sector on sector.id = solar_system.sector_id ");
    builder.push("where ");
    let mapped_sectors = map_region_to_sector_regions(&params);
    if mapped_sectors.is_empty() {
        return HttpResponse::BadRequest().finish();
    }

    add_where_clauses(&mut builder, &mapped_sectors);
    let query = builder.build_query_as::<SolarSystem>();
    match fetch_rows(query, &data.db).await {
        Ok(systems) => HttpResponse::Ok().json(systems),
        Err(response) => response,
    }
}

#[get("/stars")]
pub async fn stars(params: MapRegion, data: web::Data<AppState>,  _req: HttpRequest) -> impl Responder {
    let mut builder: sqlx::QueryBuilder<Postgres> = sqlx::QueryBuilder::new("SELECT
      solar_system.name,
      solar_system.x,
      solar_system.y,
      solar_system.scan_points,
      solar_system.survey_index,
      solar_system.gas_giant_count,
      solar_system.terrestrial_planet_count,
      solar_system.planetoid_belt_count,
      solar_system.stars,
      solar_system.allegiance,
      sector.x as sector_x,
      sector.y as sector_y,
      sector.name as sector_name
      FROM solar_system
      join sector on sector.id = solar_system.sector_id
      where ");
    let mapped_sectors = map_region_to_sector_regions(&params);
    if mapped_sectors.is_empty() {
        return HttpResponse::BadRequest().finish();
    }

    add_where_clauses(&mut builder, &mapped_sectors);
    let query = builder.build_query_as::<SolarSystemStars>();
    match fetch_rows(query, &data.db).await {
        Ok(systems) => HttpResponse::Ok().json(systems),
        Err(response) => response,
    }
}
