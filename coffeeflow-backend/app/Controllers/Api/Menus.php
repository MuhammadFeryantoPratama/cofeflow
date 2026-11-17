<?php

namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;
use App\Models\MenuModel;

class Menus extends ResourceController
{
    protected $modelName = MenuModel::class;
    protected $format    = 'json';

    public function __construct()
    {
        // Set CORS headers for Flutter
        header('Access-Control-Allow-Origin: *');
        header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
        header('Access-Control-Allow-Headers: Content-Type, Authorization, Accept');
        if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
            exit;
        }
    }

    /**
     * Return an array of resource objects
     * GET /api/menus
     */
    public function index()
    {
        $menus = $this->model->orderBy('id', 'ASC')->findAll();
        // Cast price and id for JSON consistency
        foreach ($menus as &$menu) {
            $menu['id'] = (int)$menu['id'];
            $menu['price'] = (float)$menu['price'];
        }

        return $this->respond([
            'status'  => 200,
            'message' => 'Menus retrieved successfully',
            'data'    => $menus
        ]);
    }

    /**
     * Return the properties of a resource object
     * GET /api/menus/{id}
     */
    public function show($id = null)
    {
        $menu = $this->model->find($id);
        if (!$menu) {
            return $this->failNotFound('Menu not found with id: ' . $id);
        }

        $menu['id'] = (int)$menu['id'];
        $menu['price'] = (float)$menu['price'];

        return $this->respond([
            'status'  => 200,
            'data'    => $menu
        ]);
    }

    /**
     * Create a new resource object
     * POST /api/menus
     */
    public function create()
    {
        $input = $this->request->getJSON(true) ?? $this->request->getPost();

        if (!$this->model->validate($input)) {
            return $this->failValidationErrors($this->model->errors());
        }

        $id = $this->model->insert([
            'name'     => $input['name'],
            'category' => $input['category'],
            'price'    => (float)$input['price'],
        ]);

        $created = $this->model->find($id);
        $created['id'] = (int)$created['id'];
        $created['price'] = (float)$created['price'];

        return $this->respondCreated([
            'status'  => 201,
            'message' => 'Menu created successfully',
            'data'    => $created
        ]);
    }

    /**
     * Add or update a model resource
     * PUT /api/menus/{id}
     */
    public function update($id = null)
    {
        $menu = $this->model->find($id);
        if (!$menu) {
            return $this->failNotFound('Menu not found with id: ' . $id);
        }

        $input = $this->request->getJSON(true) ?? $this->request->getRawInput();

        if (!$this->model->validate($input)) {
            return $this->failValidationErrors($this->model->errors());
        }

        $this->model->update($id, [
            'name'     => $input['name'] ?? $menu['name'],
            'category' => $input['category'] ?? $menu['category'],
            'price'    => isset($input['price']) ? (float)$input['price'] : (float)$menu['price'],
        ]);

        $updated = $this->model->find($id);
        $updated['id'] = (int)$updated['id'];
        $updated['price'] = (float)$updated['price'];

        return $this->respond([
            'status'  => 200,
            'message' => 'Menu updated successfully',
            'data'    => $updated
        ]);
    }

    /**
     * Delete the designated resource object
     * DELETE /api/menus/{id}
     */
    public function delete($id = null)
    {
        $menu = $this->model->find($id);
        if (!$menu) {
            return $this->failNotFound('Menu not found with id: ' . $id);
        }

        $this->model->delete($id);

        return $this->respondDeleted([
            'status'  => 200,
            'message' => 'Menu deleted successfully',
            'data'    => ['id' => (int)$id]
        ]);
    }
}
