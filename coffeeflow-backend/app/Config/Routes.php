<?php

use CodeIgniter\Router\RouteCollection;

/** @var RouteCollection $routes */
$routes->get('/', 'Home::index');

$routes->group('api', ['namespace' => 'App\Controllers\Api'], function ($routes) {
    // Handle CORS preflight options
    $routes->options('(:any)', function () {
        $response = service('response');
        return $response
            ->setHeader('Access-Control-Allow-Origin', '*')
            ->setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
            ->setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, Accept')
            ->setStatusCode(200);
    });

    $routes->resource('menus', ['controller' => 'Menus']);
    $routes->resource('orders', ['controller' => 'Orders']);
});
