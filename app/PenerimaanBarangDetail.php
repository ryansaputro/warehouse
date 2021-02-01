<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PenerimaanBarangDetail extends Model
{
    protected $table = 'penerimaan_barang_detail';
    protected $primaryKey = 'id';
    public $incrementing = true;
    public $timestamps = false;
    protected $fillable = ['id', 'id_penerimaan_barang', 'id_barang', 'id_satuan_barang_besar', 'id_satuan_barang_kecil', 'qty', 'keterangan'];
}
