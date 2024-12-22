const express = require('express');
const router = express.Router();
const knex = require('../db/connection');

router.get('/', async (req, res) => {
    try {
        const sectors = await knex('sector').select('*').orderBy(['x', 'y']);
        res.status(200).json(sectors);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to retrieve sectors' });
    }
});

module.exports = router;
