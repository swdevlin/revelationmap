const express = require('express');
const router = express.Router();
const knex = require('../db/connection');
const {parseHexAddress} = require('../utils/queryHelpers');

router.get('/', parseHexAddress, async (req, res) => {
    try {
        const query = knex('solar_system')
            .join('sector', 'solar_system.sector_id', 'sector.id')
            .select('solar_system.*', 'sector.x as sector_x', 'sector.y as sector_y', 'sector.name as sector_name')
            .where({
                'sector.x': req.address.sx,
                'sector.y': req.address.sy,
                'solar_system.x': req.address.hx,
                'solar_system.y': req.address.hy,
            })
        const systems = await query;
        const solar_system = systems[0];
        res.status(200).json(solar_system);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'failed to retrieve solar system data' });
    }
});

module.exports = router;
