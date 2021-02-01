<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class BarangKategori extends Model
{
    protected $table = 'barang_kategori';
    protected $fillable = ['id', 'kode_kategori', 'status_aktif', 'keterangan', 'created_at', 'updated_at', 'id_user'];
}
