<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PenerimaanBarang extends Model
{
    protected $table = 'penerimaan_barang';
    protected $fillable = ['id', 'no_penerimaan', 'no_purchase_order', 'no_spk', 'tgl_penerimaan', 'id_user', 'status_posting', 'id_vendor', 'created_at', 'updated_at'];
}
