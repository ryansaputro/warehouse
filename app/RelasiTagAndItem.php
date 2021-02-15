<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class RelasiTagAndItem extends Model
{
    protected $table = 'relasi_epc_barang';
    protected $primaryKey = 'id';
    public $incrementing = true;
    public $timestamps = false;
    protected $fillable = ['id', 'id_barang', 'id_epc_tag', 'is_used'];
}
