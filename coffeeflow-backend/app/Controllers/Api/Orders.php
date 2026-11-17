<?php

namespace App\Controllers\Api;

use CodeIgniter\RESTful\ResourceController;
use App\Models\OrderModel;
use App\Models\OrderItemModel;

class Orders extends ResourceController
{
    protected $modelName = OrderModel::class;
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
     * Return all orders with items
     * GET /api/orders
     */
    public function index()
    {
        $orders = $this->model->orderBy('id', 'DESC')->findAll();
        $itemModel = new OrderItemModel();

        foreach ($orders as &$order) {
            $order['id'] = (int)$order['id'];
            $order['total_amount'] = (float)$order['total_amount'];
            $order['date'] = $order['created_at'];

            $items = $itemModel->where('order_id', $order['id'])->findAll();
            $formattedItems = [];
            foreach ($items as $item) {
                $formattedItems[] = [
                    'menu' => [
                        'id'    => (int)$item['menu_id'],
                        'name'  => $item['menu_name'],
                        'price' => (float)$item['price'],
                    ],
                    'quantity' => (int)$item['quantity'],
                    'subtotal' => (float)$item['subtotal'],
                ];
            }
            $order['items'] = $formattedItems;
        }

        return $this->respond([
            'status'  => 200,
            'message' => 'Orders retrieved successfully',
            'data'    => $orders
        ]);
    }

    /**
     * Create a new order with items
     * POST /api/orders
     */
    public function create()
    {
        $input = $this->request->getJSON(true) ?? $this->request->getPost();

        if (empty($input['items'])) {
            return $this->failValidationErrors(['items' => 'Items tidak boleh kosong']);
        }

        $db = \Config\Database::connect();
        $db->transStart();

        $orderNumber = $input['order_number'] ?? ('CF-' . date('Ymd') . '-' . rand(100, 999));
        $totalAmount = (float)($input['total_amount'] ?? 0);

        $orderId = $this->model->insert([
            'order_number' => $orderNumber,
            'total_amount' => $totalAmount,
            'created_at'   => date('Y-m-d H:i:s'),
        ]);

        $itemModel = new OrderItemModel();
        foreach ($input['items'] as $item) {
            $menu = $item['menu'] ?? [];
            $itemModel->insert([
                'order_id'  => $orderId,
                'menu_id'   => (int)($menu['id'] ?? 0),
                'menu_name' => $menu['name'] ?? '',
                'price'     => (float)($menu['price'] ?? 0),
                'quantity'  => (int)($item['quantity'] ?? 1),
                'subtotal'  => (float)($item['subtotal'] ?? 0),
            ]);
        }

        $db->transComplete();

        if ($db->transStatus() === false) {
            return $this->failServerError('Gagal menyimpan pesanan.');
        }

        return $this->respondCreated([
            'status'  => 201,
            'message' => 'Order created successfully',
            'data'    => [
                'id'           => (int)$orderId,
                'order_number' => $orderNumber,
                'total_amount' => $totalAmount,
                'date'         => date('Y-m-d H:i:s'),
                'items'        => $input['items'],
            ]
        ]);
    }
}
