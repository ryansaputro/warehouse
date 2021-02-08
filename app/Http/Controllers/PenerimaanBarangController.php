<?php
/**
 * @author ryan saputro
 * @email ryansaputro52@gmail.com
 * @create date 2020-09-28 11:01:41
 * @modify date 2020-09-28 11:01:41
 * @desc menghandle penerimaan barang
 */

namespace App\Http\Controllers;

use Illuminate\Http\Request;

// import file model Person
use Illuminate\Support\Facades\Auth;
use Ixudra\Curl\Facades\Curl;
use DB;
use App\Barang;
use App\BarangKategori;
use App\PenerimaanBarang;
use App\PenerimaanBarangDetail;
use App\Http\Controllers\GeneralController;

class PenerimaanBarangController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    protected $GeneralController;
    public function __construct(GeneralController $GeneralController)
    {
        $this->GeneralController = $GeneralController;
    }

     // mengambil semua data
    public function index(Request $request)
    {
        $data = DB::table('penerimaan_barang')
                    ->select('penerimaan_barang.*', 'nama_vendor')
                    ->join('vendor', 'vendor.id', '=', 'penerimaan_barang.id_vendor')
                    ->orderBy('no_penerimaan', 'DESC')
                    ->get();
        return ['data' => $data, 'status' => 200];
    }

    // mengambil data by id
    public function show($id)
    {
        $data = DB::table('penerimaan_barang')
                    ->select('penerimaan_barang.*', 'nama_vendor')
                    ->join('vendor', 'vendor.id', '=', 'penerimaan_barang.id_vendor')
                    ->where('no_penerimaan', $id)
                    ->where('status_posting', '1')
                    ->first();
        
        if($data == null){
            return response()->json(['status' => 'failed', 'message' => 'data tidak tersedia'], 500);
        }

        $detail = DB::table('penerimaan_barang_detail')
                    ->select('id_barang', 'nama_barang', 'qty AS qty_kecil', 'besar.nama_satuan AS nama_satuan_besar', 'kecil.nama_satuan AS nama_satuan_kecil', 'barang.fraction', 'besar.id AS id_satuan_besar', 'kecil.id AS id_satuan_kecil')
                    ->join('barang', 'barang.id', '=', 'penerimaan_barang_detail.id_barang')
                    ->join('barang_satuan AS kecil', 'kecil.id', '=', 'penerimaan_barang_detail.id_satuan_barang_kecil')
                    ->join('barang_satuan AS besar', 'besar.id', '=', 'penerimaan_barang_detail.id_satuan_barang_besar')
                    ->where('penerimaan_barang_detail.id_penerimaan_barang', $data->id)
                    ->orderBy('penerimaan_barang_detail.id_barang', 'ASC')
                    ->get();
        
        $qty = $detail->pluck('qty_kecil', 'id_barang')->toArray();
        $id_barang = $detail->pluck('fraction', 'id_barang')->toArray();

        $gudang = DB::table('lokasi')
                ->select('id AS value', DB::raw('CONCAT(kode, " - ", nama_lokasi) AS text'))
                ->orderby('kode', 'ASC')
                ->get();


        return ['data' => $data, 'detail' => $detail, 'id_barang' => $id_barang, 'qty' => $qty, 'gudang' => $gudang, 'status' => 200];
    }

    // menambah data
    public function store(Request $request)
    {
        //validate the data before processing
        $rules = [
            "no_penerimaan"=> "required|unique:penerimaan_barang,no_penerimaan",
            "no_purchase_order" => "required|",
            "no_spk" => "required|",
            "tanggal"=> "required|date",
            "status_posting" => "required|",
            "id_vendor" => "required|",
            'list_data' => "array|required"
        ];

        
        $customMessages = [
            'required' => 'Isian :attribute tidak boleh kosong.',
            'numeric' => 'Isian :attribute harus berupa angka.',
            'digits_between' => 'Isian :attribute harus berupa angka dengan minimal 10 karakter dan maksimal 15.',
            'digits' => 'Isian :attribute harus berupa angka dengan 5 karakter.',
            'size' => 'Isian :attribute harus 3 karakter.'
        ];
        
        $this->validate($request, $rules, $customMessages);

        DB::beginTransaction();
        try {
            //proses menyimpan data ke database...
            $data = PenerimaanBarang::create([
                'no_penerimaan'  => $request->no_penerimaan,
                'no_purchase_order' => $request->no_purchase_order,
                'no_spk' => $request->no_spk,
                'tgl_penerimaan'  => $request->tanggal,
                'id_user' => Auth::user()->id,
                'status_posting' => '1',
                'id_vendor' => $request->id_vendor,
            ]);

            foreach((array)$request->list_data AS $k => $v){
                $detail = PenerimaanBarangDetail::create([
                    'id_penerimaan_barang' => $data->id, 
                    'id_barang' => $v['id_barang'], 
                    'id_satuan_barang_besar' => $v['id_satuan_barang_besar'], 
                    'id_satuan_barang_kecil' => $v['id_satuan_barang_kecil'], 
                    'qty' => $v['qty_kecil'], 
                ]);
            }
        } catch (\Illuminate\Database\QueryException $ex) {
            //throw $th;
            DB::rollback();
            return response()->json(['status' => 'failed', 'message' => $ex->getMessage()], 500);
        }
        DB::commit();
        return response()->json(['status' => 'success'], 200);
    }

    // mengubah data
    public function update($id, Request $request)
    {
        //validate the data before processing
        $data = PenerimaanBarang::where('no_penerimaan', $id)->first();
        $rules = [
            "no_penerimaan"=> "required|unique:penerimaan_barang,no_penerimaan,".$data->no_penerimaan.',no_penerimaan',
            "no_purchase_order" => "required|",
            "no_spk" => "required|",
            "status_posting" => "required|",
            "id_vendor" => "required|",
            'list_data' => "array|required"
        ];

        
        $customMessages = [
            'required' => 'Isian :attribute tidak boleh kosong.',
            'numeric' => 'Isian :attribute harus berupa angka.',
            'digits_between' => 'Isian :attribute harus berupa angka dengan minimal 10 karakter dan maksimal 15.',
            'digits' => 'Isian :attribute harus berupa angka dengan 5 karakter.',
            'size' => 'Isian :attribute harus 3 karakter.'
        ];
        
        $this->validate($request, $rules, $customMessages);

        DB::beginTransaction();
        try {
            
            //proses menyimpan data ke database...
            $update = $data->update([
                'no_penerimaan'  => $request->no_penerimaan,
                'no_purchase_order' => $request->no_purchase_order,
                'no_spk' => $request->no_spk,
                'id_user' => Auth::user()->id,
                'status_posting' => '1',
                'id_vendor' => $request->id_vendor,
            ]);

            

            foreach((array)$request->list_data AS $k => $v){
                $detail = PenerimaanBarangDetail::where('id_penerimaan_barang', $data->id)->updateOrCreate([
                    'id_penerimaan_barang' => $data->id, 
                    'id_barang' => $v['id_barang']
                ],[ 
                    'id_satuan_barang_besar' => $v['id_satuan_barang_besar'], 
                    'id_satuan_barang_kecil' => $v['id_satuan_barang_kecil'], 
                    'qty' => $v['qty_kecil'], 
                ]);
            }
        } catch (\Illuminate\Database\QueryException $ex) {
            //throw $th;
            DB::rollback();
            return response()->json(['status' => 'failed', 'message' => $ex->getMessage()], 500);
        }
        DB::commit();
        return response()->json(['status' => 'success'], 200);
    }

    // menghapus data
    public function deleteItemPenerimaan(Request $request)
    {
        
        $data = DB::table('penerimaan_barang')->where('no_penerimaan', $request->id_penerimaan_barang)->first();
        
        DB::beginTransaction();
        try {
            $data = DB::table('penerimaan_barang_detail')
                    ->where('id_penerimaan_barang', $data->id)
                    ->where('id_barang', $request->id_barang)
                    ->delete();
        } catch (\Illuminate\Database\QueryException $ex) {
            DB::rollback();
            return response()->json(['status' => 'failed', 'message' => $ex->getMessage()], 500);
        }
        DB::commit();
        return response()->json(['status' => 'success'], 200);
    }

    // menghapus data
    public function deletePenerimaan(Request $request)
    {
        $data = DB::table('penerimaan_barang')->where('no_penerimaan', $request->no_penerimaan)->first();
         
        DB::beginTransaction();
        try {

            $detail = DB::table('penerimaan_barang_detail')
                    ->where('id_penerimaan_barang', $data->id)
                    ->get();
            $data = DB::table('penerimaan_barang')
                    ->where('id', $data->id)
                    ->delete();

        } catch (\Illuminate\Database\QueryException $ex) {
            DB::rollback();
            return response()->json(['status' => 'failed', 'message' => $ex->getMessage()], 500);
        }
        DB::commit();
        return response()->json(['status' => 'success'], 200);
    }

    //get data and map the tag to item
    public function cekposting(Request $request) {
        //get id penerimaan 
        $data = DB::table('penerimaan_barang')->where('no_penerimaan', $request->no_penerimaan)->first();

        //cek apakah tag sudah terisi semua atau belum
        $cekDataPenerimaan = DB::table('penerimaan_barang_detail')->where('id_penerimaan_barang', $data->id)->pluck('id')->toArray();
        $tag = DB::table('penerimaan_barang_detail_epc_tag')->whereIn('id_penerimaan_barang_detail', $cekDataPenerimaan)->count();
        
        if(count($cekDataPenerimaan) != $tag){
            // return response()->json(['status' => 'failed', 'message' => 'tag belum terisi semua'], 500);
            return response()->json(['status' => 'success'], 200);
        }else{
            return response()->json(['status' => 'success'], 200);
        }
    }

    //update stock
    public function updateStok(Request $request) {

        $list_barang = $request->list_data;
        $no_surat = $request->no_penerimaan;
        $data = $this->GeneralController->UpdateStok('penerimaan', $list_barang, $no_surat);

        if($data){
            return response()->json(['status' => 'success'], 200);
        }else{
            return response()->json(['status' => 'failed'], 500);
        }
        
    }

}
