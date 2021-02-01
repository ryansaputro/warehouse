<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PengeluaranBarang extends Model
{
    protected $table = 'pengeluaran_barang';
     protected $primaryKey = 'id';
    public $incrementing = true;
    public $timestamps = false;
    protected $fillable = ['id', 'no_pengeluaran', 'id_user', 'tanggal_pengeluaran', 'id_unit_pengirim', 'id_unit_penerima', 'status_posting', 'created_at', 'updated_at'];
}
