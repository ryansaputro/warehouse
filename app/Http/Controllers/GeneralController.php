<?php
/**
 * @author ryan saputro
 * @email ryansaputro52@gmail.com
 * @create date 2020-09-28 11:01:41
 * @modify date 2020-09-28 11:01:41
 * @desc menghandle request dr modul master lokasi
 */

namespace App\Http\Controllers;

use Illuminate\Http\Request;

// import file model Person
use Illuminate\Support\Facades\Auth;
use Ixudra\Curl\Facades\Curl;
use DB;

class GeneralController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
    }

    // mengambil data vendor, no penerimaan, data barang
    public function MasterData()
    {
        $list_barang = DB::table('barang')
                        ->select('id AS value', DB::raw('CONCAT(kode_barang, " - ", nama_barang) AS text'))
                        ->orderby('kode_barang', 'ASC')
                        ->get();

        $vendor = DB::table('vendor')
                        ->select('id AS value', DB::raw('CONCAT(kode_vendor, " - ", nama_vendor) AS text'))
                        ->orderby('kode_vendor', 'ASC')
                        ->get();

        $no_penerimaan = DB::table('penerimaan_barang')
                        ->where(DB::raw('MONTH(tgl_penerimaan)'), '=', DB::raw('MONTH(now())'))
                        ->orderby('id', 'DESC')
                        ->get();

        $cek_last = $no_penerimaan != null ? count($no_penerimaan)+1 : 1;
       
        if($cek_last == 0){
            $cek_last = $cek_last;
        }else if($cek_last < 10){
            $cek_last = '000'.$cek_last;
        }else if($cek_last < 100){
            $cek_last = '00'.$cek_last;
        }else if($cek_last < 1000){
            $cek_last = '0'.$cek_last;
        }else{
            $cek_last = $cek_last;
        }

        $format = "Rcv-".date('Ymd').$cek_last;

        return ['data' => $list_barang, 'vendor' => $vendor, 'format' => $format, 'status' => 200];
    }
    // mengambil data vendor, no penerimaan, data barang
    public function GetDataSatuan(Request $request)
    {
        $satuan_barang_kecil = DB::table('barang')
                        ->select('barang.nama_barang', 'barang_satuan.id', DB::raw('UPPER(nama_satuan) AS nama_satuan'), 'fraction', 
                        DB::raw('IF(id_satuan_barang_kecil = barang_satuan.id, "kecil", "besar") AS jenis')
                        )
                        ->join('barang_satuan', function($join){
                            $join->on('barang_satuan.id', '=', 'barang.id_satuan_barang_besar');
                            $join->Oron('barang_satuan.id', '=', 'barang.id_satuan_barang_kecil');
                        })
                        ->where('barang.id', $request->id)
                        ->where(DB::raw('IF(id_satuan_barang_kecil = barang_satuan.id, 1, 0)'), '!=', 0)
                        ->get()->toArray();

        $satuan_barang_besar = DB::table('barang')
                        ->select('barang_satuan.id', DB::raw('UPPER(nama_satuan) AS nama_satuan'), 'fraction',
                        DB::raw('IF(id_satuan_barang_besar = barang_satuan.id, "besar", "kecil") AS jenis')
                        )
                        ->join('barang_satuan', function($join){
                            $join->on('barang_satuan.id', '=', 'barang.id_satuan_barang_besar');
                            $join->Oron('barang_satuan.id', '=', 'barang.id_satuan_barang_kecil');
                        })
                        ->where('barang.id', $request->id)
                        ->where(DB::raw('IF(id_satuan_barang_besar = barang_satuan.id, 1, 0)'), '!=', 0)
                        ->get()->toArray();

        $all_satuan = array_merge($satuan_barang_kecil,$satuan_barang_besar);
        $fraction = (Int)$satuan_barang_kecil[0]->fraction;
        
        $data = array("id_barang" => $request->id, "nama_barang" => $satuan_barang_kecil[0]->nama_barang, 
                        "id_satuan_kecil" => $satuan_barang_kecil[0]->id, 
                        "nama_satuan_kecil" => $satuan_barang_kecil[0]->nama_satuan, 
                        "id_satuan_besar" => $satuan_barang_besar[0]->id, 
                        "nama_satuan_besar" => $satuan_barang_besar[0]->nama_satuan,
                        "fraction" => $fraction);        

        return ['satuan' =>$all_satuan, 'fraction' => $fraction, 'list_data' => $data,  'status' => 200];
    }
    // mengambil data vendor, no penerimaan, data barang
    public function GetInfoStok()
    {
        // satuan yg masuk ke stock satuan terkecil
        $list_barang = DB::table('stok_barang')
                        ->select(DB::raw('SUM(qty) AS stok'), 'kode_barang', 'nama_barang', 'nama_satuan')
                        ->join('barang', 'barang.id', '=', 'stok_barang.id_barang')
                        ->join('barang_satuan', 'barang.id_satuan_barang_kecil', '=', 'barang_satuan.id')
                        ->groupBy('id_barang')
                        ->orderby('kode_barang', 'ASC')
                        ->get();

        return ['data' => $list_barang];
    }
    // mengambil data vendor, no penerimaan, data barang
    public function UpdateStok(Request $request)
    {
        DB::beginTransaction();
        try {
            $request->status = "pengeluaran";
            $request->qty = 100;
            $request->id_barang = 1;
            // satuan yg masuk ke stock satuan terkecil
            $list_barang = DB::table('stok_barang')->where('id_barang', $request->id_barang);
            
            //cek jika status dikeluarin 
            if($request->status = "pengeluaran"){
                $list_barang->update([
                    'qty' => DB::raw('qty-'.$request->qty)
                ]);            
            }else{
                $list_barang->update([
                    'qty' => DB::raw('qty+'.$request->qty)
                ]); 
            }
        } catch (\Illuminate\Database\QueryException $ex) {
            //throw $th;
            DB::rollback();
            return response()->json(['status' => 'failed', 'message' => $ex->getMessage()], 500);
        }
        DB::commit();

        return ['status' => 200];
    }
    // mengambil data vendor, no penerimaan, data barang
    public function GetKodeBarangbyRFID(Request $request)
    {
        $request->id_barang = 1;
        $list_barang = DB::table('penerimaan_barang_detail_epc_tag')
                        ->select('barang.id AS id_barang', 'nama_barang', 'barang_epc_tag.epc_tag')
                        ->join('barang', 'barang.id', '=', 'penerimaan_barang_detail_epc_tag.id_barang')
                        ->join('barang_epc_tag', 'barang_epc_tag.id', '=', 'penerimaan_barang_detail_epc_tag.id_barang')
                        ->orderby('kode_barang', 'ASC')
                        ->where('id_barang', $request->id_barang)
                        ->get();

        return ['data' => $list_barang, 'status' => 200];
    }


}
