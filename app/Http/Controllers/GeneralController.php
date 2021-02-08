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
use App\Stok;

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

        $no_pengeluaran = DB::table('pengeluaran_barang')
                        ->where(DB::raw('MONTH(tgl_pengeluaran)'), '=', DB::raw('MONTH(now())'))
                        ->orderby('id', 'DESC')
                        ->get();

        $unit = DB::table('unit')
                        ->select('id AS value', DB::raw('CONCAT(kode, " - ", nama) AS text'))
                        ->orderby('kode', 'ASC')
                        ->get();

        $gudang = DB::table('lokasi')
                        ->select('id AS value', DB::raw('CONCAT(kode, " - ", nama_lokasi) AS text'))
                        ->orderby('kode', 'ASC')
                        ->get();

        $cek_last = $no_penerimaan != null ? count($no_penerimaan)+1 : 1;
        $cek_last_pengeluaran = $no_pengeluaran != null ? count($no_pengeluaran)+1 : 1;
       
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

        if($cek_last_pengeluaran == 0){
            $cek_last_pengeluaran = $cek_last_pengeluaran;
        }else if($cek_last_pengeluaran < 10){
            $cek_last_pengeluaran = '000'.$cek_last_pengeluaran;
        }else if($cek_last_pengeluaran < 100){
            $cek_last_pengeluaran = '00'.$cek_last_pengeluaran;
        }else if($cek_last_pengeluaran < 1000){
            $cek_last_pengeluaran = '0'.$cek_last_pengeluaran;
        }else{
            $cek_last_pengeluaran = $cek_last_pengeluaran;
        }

        $format = "IN".date('Ymd').$cek_last;
        $format_pengeluaran = "OUT".date('Ymd').$cek_last_pengeluaran;

        return ['data' => $list_barang, 'vendor' => $vendor, 'unit' => $unit, 'gudang' => $gudang,  'format' => $format, 'format_pengeluaran' => $format_pengeluaran, 'status' => 200];
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
    public function GetInfoStok(Request $request)
    {
        // satuan yg masuk ke stock satuan terkecil
        if($request->input('filter') == null){
            $list_barang = DB::table('stok_barang')
                        ->select(DB::raw('SUM(qty) AS stok'), 'kode_barang', 'nama_barang', 'nama_satuan', 'nama_lokasi')
                        ->join('barang', 'barang.id', '=', 'stok_barang.id_barang')
                        ->join('barang_satuan', 'barang.id_satuan_barang_kecil', '=', 'barang_satuan.id')
                        ->join('lokasi', 'lokasi.id', '=', 'stok_barang.id_gudang')
                        ->groupBy('id_barang')
                        ->groupBy('id_gudang')
                        ->orderby('kode_barang', 'ASC')
                        ->get();
        }
        // satuan yg masuk ke stock satuan terkecil
        else if($request->input('filter') == 'gudang'){
            $list_barang = DB::table('stok_barang')
                        ->select(DB::raw('SUM(qty) AS stok'), 'kode_barang', 'nama_barang', 'nama_satuan', 'nama_lokasi')
                        ->join('barang', 'barang.id', '=', 'stok_barang.id_barang')
                        ->join('barang_satuan', 'barang.id_satuan_barang_kecil', '=', 'barang_satuan.id')
                        ->join('lokasi', 'lokasi.id', '=', 'stok_barang.id_gudang')
                        ->groupBy('id_gudang')
                        ->orderby('kode_barang', 'ASC')
                        ->get();
        }
        // satuan yg masuk ke stock satuan terkecil
        else if($request->input('filter') == 'item'){
            $list_barang = DB::table('stok_barang')
                        ->select(DB::raw('SUM(qty) AS stok'), 'kode_barang', 'nama_barang', 'nama_satuan')
                        ->join('barang', 'barang.id', '=', 'stok_barang.id_barang')
                        ->join('barang_satuan', 'barang.id_satuan_barang_kecil', '=', 'barang_satuan.id')
                        // ->join('lokasi', 'lokasi.id', '=', 'stok_barang.id_gudang')
                        ->groupBy('id_barang')
                        ->orderby('kode_barang', 'ASC')
                        ->get();
        }

        return ['data' => $list_barang];
    }
    // mengambil data vendor, no penerimaan, data barang
    public function UpdateStok($jenis_permintaan, $list_data, $nomor_surat)
    {
        DB::beginTransaction();
        try {

            //cek jika status dikeluarin 
            if($jenis_permintaan == "pengeluaran"){
                foreach($list_data AS $k => $v){
                    // satuan yg masuk ke stock satuan terkecil
                    $list_barang = Stok::updateOrCreate([
                        'id_barang' => $v['id_barang'],
                        'id_gudang' => $v['id_gudang'],
                    ],[
                        'qty' => DB::raw('qty-'.$v['qty'])
                    ]);            
                }

                $data = DB::table('pengeluaran_barang')->where('no_pengeluaran', $nomor_surat)->update(['status_posting' => '0']);
            }else{
                foreach($list_data AS $k => $v){
                    // satuan yg masuk ke stock satuan terkecil
                    $list_barang = Stok::updateOrCreate([
                        'id_barang' => $v['id_barang'],
                        'id_gudang' => $v['id_gudang'],
                    ],[
                        'qty' => DB::raw('qty+'.$v['qty'])
                    ]);            
                }

                // update status posting
                $data = DB::table('penerimaan_barang')->where('no_penerimaan', $nomor_surat)->update(['status_posting' => '0']);
            }
            
        } catch (\Illuminate\Database\QueryException $ex) {
            //throw $th;
            DB::rollback();
            return false;
        }
        DB::commit();

        return true;
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
