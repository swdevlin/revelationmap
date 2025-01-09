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
                        maxX = lr.hx;
                    }

                    if (y === ul.sy) {
                        minY = ul.hy;
                        if (y === lr.sy)
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

const addClauses = (query, req) => {
    query.where(function() {
        this
          .whereBetween('solar_system.origin_x', [req.ul.x, req.lr.x])
          .andWhereBetween('solar_system.origin_y', [req.lr.y, req.ul.y]);
    });
}

const parseQueryParams = (req, res, next) => {
    try {
        let { sx, sy, ulx, uly, lrx, lry } = req.query;

        if (sx !== undefined && sy !== undefined) {
            ulx = sx * 32 + 1;
            uly = sy * 40 - 1;
            lrx = ulx + 31;
            lry = uly - 39;
        } else if (
                ulx === undefined || uly === undefined ||
                lrx === undefined || lry === undefined ||
          +ulx > +lrx || +uly < +lry
        ) {
                return res.status(400).json({ error: 'hex Xs and Ys incorrect' });
        }
        req.ul = {
            x: +ulx,
            y: +uly
        };

        req.lr = {
            x: +lrx,
            y: +lry
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
