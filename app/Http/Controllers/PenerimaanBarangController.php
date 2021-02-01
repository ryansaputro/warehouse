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

class PenerimaanBarangController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
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

    // mengambil data vendor, no penerimaan, data barang
    public function getDataListBarang()
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

    public function getDataListSatuan(Request $request)
    {   
        $jenis = ($request->tipe_satuan == 'satuan_besar') ? 'barang.id_satuan_barang_besar' : 'barang.id_satuan_barang_kecil';
        $satuan_barang = DB::table('barang')
                        ->select('barang_satuan.id', DB::raw('UPPER(nama_satuan) AS nama_satuan'))
                        ->join('barang_satuan', 'barang_satuan.id', '=', $jenis)
                        ->where('barang.id', $request->id)
                        ->first();

        return [$satuan_barang, 'status' => 200];
    }

    // mengambil data by id
    public function show($id)
    {
        $data = DB::table('penerimaan_barang')
                    ->select('penerimaan_barang.*', 'nama_vendor')
                    ->join('vendor', 'vendor.id', '=', 'penerimaan_barang.id_vendor')
                    ->where('no_penerimaan', $id)->first();
        $detail = DB::table('penerimaan_barang_detail')
                    ->select('id_barang', 'nama_barang', 'qty', 'nama_satuan')
                    ->join('barang', 'barang.id', '=', 'penerimaan_barang_detail.id_barang')
                    ->join('barang_satuan', 'barang_satuan.id', '=', 'penerimaan_barang_detail.id_satuan_barang_besar')
                    ->where('penerimaan_barang_detail.id_penerimaan_barang', $data->id)
                    ->get();
        $id_barang = $detail->pluck('id_barang')->toArray();

        return ['data' => $data, 'detail' => $detail, 'id_barang' => $id_barang, 'status' => 200];
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
                'status_posting' => $request->status_posting,
                'id_vendor' => $request->id_vendor,
            ]);

            foreach((array)$request->list_data AS $k => $v){
                $detail = PenerimaanBarangDetail::create([
                    'id_penerimaan_barang' => $data->id, 
                    'id_barang' => $v['id_barang'], 
                    'id_satuan_barang_besar' => $v['id_satuan'], 
                    'id_satuan_barang_kecil' => $v['id_satuan'], 
                    'qty' => $v['qty'], 
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
        $data = DB::table('divisi')->where('id', $id)->first();
        //validate the data before processing
        $rules = [
            "nama_divisi"=> "required|unique:divisi,nama_divisi,".$data->nama_divisi.',nama_divisi',
            "deskripsi" => "required|",
            "status" => "required|",
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
            $data = DB::table('divisi')->where('id',$id)->update([
                'nama_divisi'  => $request->nama_divisi,
                'deskripsi' => $request->deskripsi,
                'status' => $request->status,
            ]);
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
        
        DB::beginTransaction();
        try {
            $data = DB::table('penerimaan_barang_detail')
                    ->where('id_penerimaan_barang', $request->id_penerimaan)
                    ->where('id_barang', $request->id_barang)
                    ->delete();
        } catch (\Throwable $th) {
            //throw $th;
        }
        return response()->json(['status' => 'success']);
    }

 // menghapus data
    public function deletePenerimaan(Request $request)
    {
        
        DB::beginTransaction();
        try {
            $data = DB::table('pengeluaran_barang')
                    ->where('id', $request->id_penerimaan)
                    ->delete();

            $detail = DB::table('pengeluaran_barang_detail')
                    ->where('id_pengeluaran', $request->id_penerimaan)
                    ->delete();

        } catch (\Throwable $th) {
            //throw $th;
        }
        return response()->json(['status' => 'success']);
    }}
