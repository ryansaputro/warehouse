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

class PengeluaranBarangController extends Controller
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
        $data = DB::table('pengeluaran_barang')
                    ->select('pengeluaran_barang.*', 'penerima.nama AS nama_penerima_unit', 'penerima.nama AS nama_pengirim_unit')
                    ->join('unit AS pengirim', 'pengirim.id', '=', 'pengeluaran_barang.id_unit_pengirim')
                    ->join('unit AS penerima', 'penerima.id', '=', 'pengeluaran_barang.id_unit_penerima')
                    ->orderBy('no_pengeluaran', 'DESC')
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
            "no_pengeluaran"=> "required|unique:penerimaan_barang,no_penerimaan",
            "id_unit_pengirim" => "required|",
            "id_unit_penerima" => "required|",
            "tanggal_pengeluaran"=> "required|date",
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
            $data = PengeluaranBarang::create([
                'no_pengeluaran'  => $request->no_penerimaan,
                'id_user' => Auth::user()->id,
                'id_unit_pengirim' => $request->id_unit_pengirim,
                'id_unit_penerima' => $request->id_unit_penerima,
                'tanggal_pengeluaran'  => $request->tanggal_pengeluaran,
                'status_posting' => '1',
            ]);

            foreach((array)$request->list_data AS $k => $v){
                $detail = PengeluaranBarangDetail::create([
                    'id_pengeluaran' => $data->id, 
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
        //validate the data before processing
        $rules = [
            "no_pengeluaran"=> "required|unique:penerimaan_barang,no_penerimaan",
            "id_unit_pengirim" => "required|",
            "id_unit_penerima" => "required|",
            "tanggal_pengeluaran"=> "required|date",
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
            $data = PengeluaranBarang::where('no_pengeluaran', $request->no_pengeluaran);
            //proses menyimpan data ke database...
            $data->update([
                'no_pengeluaran'  => $request->no_penerimaan,
                'id_user' => Auth::user()->id,
                'id_unit_pengirim' => $request->id_unit_pengirim,
                'id_unit_penerima' => $request->id_unit_penerima,
                'tanggal_pengeluaran'  => $request->tanggal_pengeluaran,
                'status_posting' => '1',
            ]);

            $data->first();
            foreach((array)$request->list_data AS $k => $v){
                $detail = PengeluaranBarangDetail::where('id_pengeluaran', $data->id)->update([
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

    // menghapus data
    public function deleteItemPengeluaran(Request $request)
    {
        
        DB::beginTransaction();
        try {
            $data = DB::table('pengeluaran_barang_detail')
                    ->where('id_pengeluaran', $request->id_penerimaan)
                    ->where('id_barang', $request->id_barang)
                    ->delete();
        } catch (\Throwable $th) {
            //throw $th;
        }
        return response()->json(['status' => 'success']);
    }
    
    // menghapus data
    public function deletePengeluaran(Request $request)
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
    }
}
