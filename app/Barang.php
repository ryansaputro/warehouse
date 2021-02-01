<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Barang extends Model
{
    protected $table = 'barang';
    protected $fillable = ['id', 'kode_barang', 'nama_barang', 'id_kategori_barang', 'id_user', 'created_at', 'updated_at', 'status_aktif', 'spesifikasi', 'id_satuan_barang_kecil', 'id_satuan_barang_besar', 'fraction'];
}
