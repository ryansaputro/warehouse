<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PengeluaranBarangDetailEpc extends Model
{
    protected $table = 'pengeluaran_barang_detail_epc_tag';
    protected $primaryKey = 'id';
    public $incrementing = true;
    public $timestamps = false;
    protected $fillable = ['id', 'id_pengeluaran_barang_detail', 'id_barang', 'id_epc_tag'];
}
