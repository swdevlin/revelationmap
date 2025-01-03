const express = require('express');
const router = express.Router();
const knex = require('../db/connection');

router.get('/', async (req, res) => {
    try {
        const hexes = await knex('route').select('*').orderBy(['year', 'day']);
        res.status(200).json(hexes);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to retrieve route' });
    }
});

module.exports = router;
