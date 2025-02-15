const express = require('express');
const router = express.Router();
const knex = require('../db/connection');

router.get('/', async (req, res) => {
    try {
        const hexes = await knex('route').select(
          'route.*',
          knex.raw('sector_x * 32 + hex_x -1  as origin_x'),
          knex.raw('sector_y * 40 - hex_y -1 as origin_y')
          ).orderBy(['year', 'day']);
        res.status(200).json(hexes);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to retrieve route' });
    }
});

module.exports = router;
