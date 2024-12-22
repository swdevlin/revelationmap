use serde::Deserialize;

#[derive(Deserialize, Debug)]
pub struct HexAddress {
    pub sx: i32,
    pub sy: i32,
    pub hx: i32,
    pub hy: i32,
}

#[derive(Deserialize, Debug)]
pub struct MapRegion {
    pub upper_left: HexAddress,
    pub lower_right: HexAddress,
}

pub fn build_empty_region() -> MapRegion {
    MapRegion {
        upper_left: HexAddress {
            sx: 0,
            sy: 0,
            hx: 1,
            hy: 1,
        },
        lower_right: HexAddress {
            sx: 0,
            sy: 0,
            hx: 32,
            hy: 40,
        },
    }
}

#[derive(Deserialize, Debug)]
pub struct SectorRegion {
    pub x: i32,
    pub y: i32,
    pub ulhx: i32,
    pub ulhy: i32,
    pub lrhx: i32,
    pub lrhy: i32,
}
