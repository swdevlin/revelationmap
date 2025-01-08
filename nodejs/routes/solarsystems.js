const express = require('express');
const router = express.Router();
const knex = require('../db/connection');
const {sectorSelections, addClauses, parseQueryParams} = require('../utils/queryHelpers');

router.get('/', parseQueryParams, async (req, res) => {
  try {
    const query = knex('solar_system')
      .join('sector', 'solar_system.sector_id', 'sector.id')
      .select('solar_system.*', 'sector.x as sector_x', 'sector.y as sector_y', 'sector.name as sector_name');
    addClauses(query, req);

    const systems = await query;
    res.status(200).json(systems);
  } catch (error) {
    console.error(error);
    res.status(500).json({error: 'Failed to retrieve solar system data'});
  }
});

module.exports = router;
