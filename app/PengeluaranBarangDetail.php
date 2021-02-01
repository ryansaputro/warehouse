<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PengeluaranBarangDetail extends Model
{
    protected $table = 'pengeluaran_barang_detail';
    protected $primaryKey = 'id';
    public $incrementing = true;
    public $timestamps = false;
    protected $fillable = ['id', 'id_pengeluaran', 'id_barang', 'id_satuan_barang_besar', 'id_satuan_barang_kecil', 'qty', 'keterangan', 'id_epc_tag'];
}
