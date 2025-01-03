const express = require('express');
const router = express.Router();
const knex = require('../db/connection');
const { sectorSelections, addClauses, parseQueryParams } = require('../utils/queryHelpers');

router.get('/', parseQueryParams, async (req, res) => {
    try {
        const clauses = sectorSelections(req.ul, req.lr);

        const query = knex('solar_system')
            .join('sector', 'solar_system.sector_id', 'sector.id')
            .select(
                'solar_system.name',
                'solar_system.x',
                'solar_system.y',
                'sector.x as sector_x',
                'sector.y as sector_y',
                'sector.name as sector_name',
                'solar_system.scan_points',
                'solar_system.survey_index',
                'solar_system.gas_giant_count',
                'solar_system.terrestrial_planet_count',
                'solar_system.planetoid_belt_count',
                'solar_system.allegiance',
                'solar_system.stars',
            );

        addClauses(query, clauses);

        const systems = await query;
        res.status(200).json(systems);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to retrieve stars data' });
    }
});

module.exports = router;
