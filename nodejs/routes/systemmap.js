const express = require('express');
const router = express.Router();
const path = require('node:path');
const fs = require('fs');
const knex = require('../db/connection');

router.get('/', async (req, res) => {
    try {
        const { sx, sy, hex } = req.query;

        const sectors = await knex('sector').select('*').where('x', parseInt(sx)).andWhere('y', parseInt(sy));
        const sector = sectors[0];
        const filePath = path.join(process.env.STELLAR_DATA, sector.name, `${hex}-map.svg`);
        fs.access(filePath, fs.constants.F_OK, (err) => {
            if (err) {
                res.status(404).send('SVG file not found');
                return;
            }

            res.sendFile(filePath, (err) => {
                if (err) {
                    console.error('Error sending SVG file:', err);
                    res.status(500).send('Error serving the SVG file');
                }
            });
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Failed to retrieve sectors' });
    }
});

module.exports = router;
