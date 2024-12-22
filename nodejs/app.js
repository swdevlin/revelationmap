require('dotenv').config();
const express = require('express');
const morgan = require('morgan');
const winston = require('winston');

const cors = require('cors');
const app = express();
const PORT = process.env.PORT;
app.use(cors());

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.printf(({ timestamp, level, message }) => {
      return `${timestamp} ${level}: ${message}`;
    })
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'logs/app.log' })
  ]
});

app.use(express.json());

app.use(morgan('tiny', { stream: { write: (message) => logger.info(message.trim()) } }));

app.use('/systemmap', require('./routes/systemmap'));
app.use('/sectors', require('./routes/sectors'));
app.use('/solarsystems', require('./routes/solarsystems'));
app.use('/stars', require('./routes/stars'));

app.use((req, res, next) => {
  const startTime = Date.now();

  logger.info(`Received ${req.method} request for ${req.originalUrl}`);

  res.on('finish', () => {
    const endTime = Date.now();
    const timeTaken = endTime - startTime;
    logger.info(
      `Completed ${req.method} request for ${req.originalUrl} - Status: ${res.statusCode} - Time taken: ${timeTaken}ms`
    );
  });

  next();
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
