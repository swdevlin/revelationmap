use crate::hex_address::{build_empty_region, MapRegion, SectorRegion};
use actix_web::{web, FromRequest};
use serde::Deserialize;
use std::future::{ready, Ready};

#[derive(Deserialize, Debug)]
struct HexRange {
    ulsx: i32,
    ulsy: i32,
    ulhx: Option<i32>,
    ulhy: Option<i32>,
    lrsx: Option<i32>,
    lrsy: Option<i32>,
    lrhx: Option<i32>,
    lrhy: Option<i32>,
}

impl FromRequest for MapRegion {
    type Error = actix_web::Error;
    type Future = Ready<Result<Self, Self::Error>>;

    fn from_request(req: &actix_web::HttpRequest, _: &mut actix_web::dev::Payload) -> Self::Future {
        match web::Query::<HexRange>::from_query(req.query_string()) {
            Ok(query) => {
                let hex_range = query.into_inner();
                if hex_range.ulsx == 0 || hex_range.ulsy == 0 {
                    return ready(Err(actix_web::error::ErrorBadRequest(
                        "upper left sector x and y are required",
                    )));
                }

                let optionals = [
                    &hex_range.ulhx,
                    &hex_range.ulhy,
                    &hex_range.lrhx,
                    &hex_range.lrhy
                ];

                let all_none = hex_range.lrsx.is_none() && hex_range.lrsy.is_none() && optionals.iter().all(|&opt| opt.is_none());
                let all_some = hex_range.lrsx.is_some() && hex_range.lrsy.is_some() && optionals.iter().all(|&opt| opt.is_some());

                if !all_none && !all_some {
                    return ready(Err(actix_web::error::ErrorBadRequest(
                        "both hexes need to be specified or just the upper left sector",
                    )));
                }

                let mut map_region = build_empty_region();

                if all_none {
                    map_region.upper_left.sx = hex_range.ulsx;
                    map_region.upper_left.sy = hex_range.ulsy;
                    map_region.upper_left.hx = 1;
                    map_region.upper_left.hy = 1;
                    map_region.lower_right.sx = hex_range.ulsx;
                    map_region.lower_right.sy = hex_range.ulsy;
                    map_region.lower_right.hx = 32;
                    map_region.lower_right.hy = 40;
                } else {
                    map_region.upper_left.sx = hex_range.ulsx;
                    map_region.upper_left.sy = hex_range.ulsy;
                    map_region.upper_left.hx = hex_range.ulhx.unwrap();
                    map_region.upper_left.hy = hex_range.ulhy.unwrap();
                    map_region.lower_right.sx = hex_range.lrsx.unwrap();
                    map_region.lower_right.sy = hex_range.lrsy.unwrap();
                    map_region.lower_right.hx = hex_range.lrhx.unwrap();
                    map_region.lower_right.hy = hex_range.lrhy.unwrap();
                }
                
                ready(Ok(map_region))
            }
            Err(_) => ready(Err(actix_web::error::ErrorBadRequest(
                "Invalid query parameters",
            ))),
        }
    }
}

pub fn map_region_to_sector_regions(map_region: &MapRegion) -> Vec<SectorRegion> {
    let mut sector_regions = Vec::new();
    let ul = &map_region.upper_left;
    let lr = &map_region.lower_right;

    for x in ul.sx..=lr.sx {
        for y in (ul.sy..=lr.sy).rev() {
            let (min_x, max_x) = if x == ul.sx {
                (ul.hx, if x == lr.sx { lr.hx } else { 32 })
            } else if x > ul.sx && x < lr.sx {
                (1, 32)
            } else {
                (1, lr.hx)
            };

            let (min_y, max_y) = if y == ul.sy {
                (ul.hy, if x == lr.sx { lr.hy } else { 40 })
            } else if y < ul.sy && y > lr.sy {
                (1, 40)
            } else {
                (1, lr.hy)
            };

            sector_regions.push(SectorRegion {
                x,
                y,
                ulhx: min_x,
                lrhx: max_x,
                ulhy: min_y,
                lrhy: max_y,
            });
        }
    }

    sector_regions
}
