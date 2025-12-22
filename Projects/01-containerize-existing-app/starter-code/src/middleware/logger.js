const logger = (req, res, next) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = Date.now() - start;
    const log = {
      method: req.method,
      path: req.path,
      status: res.statusCode,
      duration: `${duration}ms`,
      timestamp: new Date().toISOString(),
    };
    
    if (process.env.NODE_ENV === 'production') {
      console.log(JSON.stringify(log));
    } else {
      console.log(`${log.method} ${log.path} ${log.status} ${log.duration}`);
    }
  });
  
  next();
};

module.exports = logger;
