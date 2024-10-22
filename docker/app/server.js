const express = require('express');
const dotenv = require('dotenv');
const apiRoutes = require('./src/routes/api');

dotenv.config(); // Cargar las variables de entorno

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json()); // Para parsear JSON

// Usar las rutas de la API
app.use('/api', apiRoutes);

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
