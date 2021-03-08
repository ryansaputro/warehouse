<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PengeluaranBarang extends Model
{
    protected $table = 'pengeluaran_barang';
    protected $primaryKey = 'id';
    public $incrementing = true;
    public $timestamps = true;
    protected $fillable = ['id', 'no_pengeluaran', 'id_user', 'tgl_pengeluaran', 'id_unit_pengirim', 'id_unit_penerima','id_lokasi_pengirim', 'id_lokasi_penerima', 'status_posting', 'created_at', 'updated_at'];
}
