<?php

namespace App\Models;

use CodeIgniter\Model;

class MenuModel extends Model
{
    protected $table            = 'menus';
    protected $primaryKey       = 'id';
    protected $useAutoIncrement = true;
    protected $returnType       = 'array';
    protected $useSoftDeletes   = false;
    protected $protectFields    = true;
    protected $allowedFields    = ['name', 'category', 'price'];

    // Dates
    protected $useTimestamps = true;
    protected $dateFormat    = 'datetime';
    protected $createdField  = 'created_at';
    protected $updatedField  = 'updated_at';

    // Validation
    protected $validationRules = [
        'name'     => 'required|min_length[2]|max_length[100]',
        'category' => 'required|in_list[Coffee,Non-Coffee]',
        'price'    => 'required|numeric|greater_than[0]',
    ];

    protected $validationMessages = [
        'name' => [
            'required' => 'Nama menu wajib diisi.',
        ],
        'category' => [
            'required' => 'Kategori menu wajib dipilih.',
            'in_list'  => 'Kategori harus bernilai Coffee atau Non-Coffee.',
        ],
        'price' => [
            'required'     => 'Harga wajib diisi.',
            'numeric'      => 'Harga harus berupa angka.',
            'greater_than' => 'Harga harus lebih besar dari 0.',
        ],
    ];
}
