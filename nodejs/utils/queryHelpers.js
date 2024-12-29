const sectorSelections = (ul, lr) => {
    const regions = [];
    if (isNaN(lr.sx)) {
        regions.push({
            sx:ul.sx,
            sy:ul.sy,
            minX: 1,
            maxX: 32,
            minY: 1,
            maxY: 40,
        });
    } else {
        if (ul.sx === lr.sx && ul.sy === lr.sy) {
            regions.push({
                sx:ul.sx,
                sy:ul.sy,
                minX: ul.hx,
                maxX: lr.hx,
                minY: ul.hy,
                maxY: lr.hy,
            });
        } else {
            for (let x = ul.sx; x <= lr.sx; x++)
                for (let y = ul.sy; y >= lr.sy; y--) {
                    let minX, minY, maxX, maxY;
                    if (x === ul.sx) {
                        minX = ul.hx;
                        if (x === lr.sx)
                            maxX = lr.hx;
                        else
                            maxX = 32;
                    } else if (x > ul.sx && x < lr.sx) {
                        minX = 1;
                        maxX = 32;
                    } else {
                        minX = 1;
                        maxX = lr.sx;
                    }

                    if (y === ul.sy) {
                        minY = ul.hy;
                        if (x === lr.sx)
                            maxY = lr.hy;
                        else
                            maxY = 40;
                    }
                    else if (y < ul.sy && y > lr.sy) {
                        minY = 1;
                        maxY = 40;
                    } else {
                        minY = 1;
                        maxY = lr.hy;
                    }
                    regions.push({
                        sx:x,
                        sy:y,
                        minX: minX,
                        maxX: maxX,
                        minY: minY,
                        maxY: maxY,
                    });
                }
        }
    }
    return regions;
}

const addClauses = (query, clauses) => {
    query.where(function() {
        this
            .where('sector.x', clauses[0].sx)
            .andWhere('sector.y', clauses[0].sy)
            .andWhereBetween('solar_system.x', [clauses[0].minX, clauses[0].maxX])
            .andWhereBetween('solar_system.y', [clauses[0].minY, clauses[0].maxY])
        ;
    });

    for (let i = 1; i < clauses.length; i++) {
        query.orWhere(function() {
            this
                .where('sector.x', clauses[i].sx)
                .andWhere('sector.y', clauses[i].sy)
                .andWhereBetween('solar_system.x', [clauses[i].minX, clauses[i].maxX])
                .andWhereBetween('solar_system.y', [clauses[i].minY, clauses[i].maxY])
            ;
        });
    }
}

const parseQueryParams = (req, res, next) => {
    try {
        const { ulsx, ulsy, ulhx, ulhy, lrsx, lrsy, lrhx, lrhy } = req.query;

        if (ulsx === undefined || ulsy === undefined) {
            return res.status(400).json({ error: 'At least upper left sector x and y required' });
        }

        if (lrsx !== undefined && lrsy !== undefined) {
            if (
                ulhx === undefined || ulhy === undefined ||
                lrhx === undefined || lrhy === undefined ||
                +ulsx > +lrsx || +ulsy < +lrsy
            ) {
                return res.status(400).json({ error: 'hex Xs and Ys incorrect' });
            }
        }
        req.ul = {
            sx: +ulsx,
            sy: +ulsy,
            hx: +ulhx,
            hy: +ulhy
        };

        req.lr = {
            sx: +lrsx,
            sy: +lrsy,
            hx: +lrhx,
            hy: +lrhy
        };

        next();
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Invalid query parameters' });
    }
};

const parseHexAddress = (req, res, next) => {
    try {
        const { sx, sy, hx, hy } = req.query;

        if (sx === undefined || sy === undefined || hx === undefined || hy === undefined) {
            return res.status(400).json({ error: 'sx, sy, hx, hy required' });
        }

        req.address = {
            sx: +sx,
            sy: +sy,
            hx: +hx,
            hy: +hy
        };
        next();
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'invalid hex address' });
    }
};

module.exports = { sectorSelections, addClauses, parseQueryParams, parseHexAddress };
