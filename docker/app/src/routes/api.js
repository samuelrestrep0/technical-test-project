const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

// Definir una ruta para obtener usuarios
router.get('/users', userController.getUsers);

// Agregar más rutas según sea necesario

module.exports = router;
