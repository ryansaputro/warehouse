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
use App\PengeluaranBarang;
use App\PengeluaranBarangDetail;
use App\PengeluaranBarangDetailEpc;
use App\Http\Controllers\GeneralController;

class PengeluaranBarangController extends Controller
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
        $data = DB::table('pengeluaran_barang')
                    ->select('pengeluaran_barang.*', 'penerima.nama AS nama_penerima_unit', 'pengirim.nama_lokasi AS nama_pengirim_unit')
                    ->join('lokasi AS pengirim', 'pengirim.id', '=', 'pengeluaran_barang.id_unit_pengirim')
                    ->join('unit AS penerima', 'penerima.id', '=', 'pengeluaran_barang.id_unit_penerima')
                    ->orderBy('no_pengeluaran', 'DESC')
                    ->get();

        return response()->json(['data' => $data, 'status' => 'success'], 200);
    }

    // mengambil data by id
    public function show($id)
    {
        $data = DB::table('pengeluaran_barang')
                    ->select('pengeluaran_barang.*', 'penerima.nama AS nama_penerima_unit', 'pengirim.nama_lokasi AS nama_pengirim_unit')
                    ->join('lokasi AS pengirim', 'pengirim.id', '=', 'pengeluaran_barang.id_unit_pengirim')
                    ->join('unit AS penerima', 'penerima.id', '=', 'pengeluaran_barang.id_unit_penerima')
                    ->where('no_pengeluaran', $id)
                    ->first();
        
        $detail = DB::table('pengeluaran_barang_detail')
                    ->select('pengeluaran_barang_detail.id', 'id_barang', 'nama_barang', 'qty AS qty_kecil', 'besar.nama_satuan AS nama_satuan_besar', 'kecil.nama_satuan AS nama_satuan_kecil', 'barang.fraction', 'besar.id AS id_satuan_besar', 'kecil.id AS id_satuan_kecil')
                    ->join('barang', 'barang.id', '=', 'pengeluaran_barang_detail.id_barang')
                    ->join('barang_satuan AS kecil', 'kecil.id', '=', 'pengeluaran_barang_detail.id_satuan_barang_kecil')
                    ->join('barang_satuan AS besar', 'besar.id', '=', 'pengeluaran_barang_detail.id_satuan_barang_besar')
                    ->where('pengeluaran_barang_detail.id_pengeluaran', $data->id)
                    ->orderBy('pengeluaran_barang_detail.id_barang', 'ASC')
                    ->get();


        return ['data' => $data, 'detail' => $detail, 'status' => 200];
    }

    // menambah data
    public function store(Request $request)
    {
        foreach($request->list_data AS $k => $v):
            // $dtl = PengeluaranBarangDetail::create([
            //     'id_pengeluaran' => $data->id, 
            //     'id_barang' => $v[1], 
            //     'id_satuan_barang_kecil' => $v[4], 
            //     'qty' => $v[3], 
            // ]);
            foreach($request->list_tag[$v[0]] AS $key => $val){
                // echo "id_barang :". $v[1]." -> ";
                // print_r($val)."<br>";
                // $epc = PengeluaranBarangDetail::create([
                //     'id_pengeluaran_barang_detail' => $dtl->id, 
                //     'id_barang' => $v[1], 
                //     'id_epc_tag' => $satuan[strtolower($v[2])], 
                // ]);
            }
        endforeach;
        // echo "<pre>".print_r($request->list_tag)."</pre>";
        // echo "<pre>".print_r($request->list_tag)."</pre>";
        // $satuan = DB::table('barang_satuan')->select('id', DB::raw('LOWER(nama_satuan) AS nama_satuan'))->pluck('id', 'nama_satuan')->toArray();
        // $satuan = DB::table('barang_satuan')->select('id', DB::raw('LOWER(nama_satuan) AS nama_satuan'))->pluck('id', 'nama_satuan')->toArray();
        
        dd($request->all());
        //validate the data before processing
        $rules = [
            "no_pengeluaran"=> "required|unique:pengeluaran_barang,no_pengeluaran",
            "id_unit_pengirim" => "required|",
            "id_unit_penerima" => "required|",
            "tanggal"=> "required|date",
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
                'no_pengeluaran'  => $request->no_pengeluaran,
                'id_user' => Auth::user()->id,
                'id_unit_pengirim' => $request->id_unit_pengirim,
                'id_unit_penerima' => $request->id_unit_penerima,
                'tgl_pengeluaran'  => $request->tanggal." ".date('H:i:s'),
                'status_posting' => '1',
            ]);

            // foreach($request->list_data AS $k => $v):
            //     $dtl = PengeluaranBarangDetail::create([
            //         'id_pengeluaran' => $data->id, 
            //         'id_barang' => $v[1], 
            //         'id_satuan_barang_kecil' => $satuan[strtolower($v[2])], 
            //         'qty' => $v[3], 
            //     ]);
            //     print_r($v[1]);
            //     print_r($request->list_tag[$v[0]]);
            //     foreach($request->list_tag[$v[0]] AS $key => $val){
                // '', 'id_barang', 'id_epc_tag'
                    // $epc = PengeluaranBarangDetail::create([
                //         'id_pengeluaran_barang_detail' => $dtl->id, 
                //         'id_barang' => $v[1], 
                //         'id_epc_tag' => $satuan[strtolower($v[2])], 
                //     ]);
            //     }
            // endforeach;


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
            "id_unit_pengirim" => "required|",
            "id_unit_penerima" => "required|",
            "tanggal"=> "required|date",
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
                'id_unit_pengirim' => $request->id_unit_pengirim,
                'id_unit_penerima' => $request->id_unit_penerima,
                'tgl_pengeluaran'  => $request->tanggal." ".date('H:i:s'),
                'status_posting' => '1',
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
    public function deletePengeluaran(Request $request)
    {
        
        DB::beginTransaction();
        try {
            $data = DB::table('pengeluaran_barang')
                    ->where('no_pengeluaran', $request->no_pengeluaran)
                    ->delete();

        } catch (\Throwable $th) {
          //throw $th;
            DB::rollback();
            return response()->json(['status' => 'failed', 'message' => $ex->getMessage()], 500);
        }
        DB::commit();
        return response()->json(['status' => 'success'], 200);
    }

    //get data and map the tag to item
    public function cekposting(Request $request) {
        //get id penerimaan 
        $data = DB::table('pengeluaran_barang')->where('no_pengeluaran', $request->no_pengeluaran)->first();

        //cek apakah tag sudah terisi semua atau belum
        $cekDataPengeluaran = DB::table('pengeluaran_barang_detail')->where('id_pengeluaran', $data->id);
        $id_barang = $cekDataPengeluaran->pluck('id_barang')->toArray();
        $qty = $cekDataPengeluaran->pluck('qty')->toArray();
        $no_surat = $request->no_pengeluaran;
        
        foreach($id_barang AS $k => $v){
            $list_barang[] = array("id_barang" => $v, "qty"=> $qty[$k], "id_unit_penerima" => $data->id_unit_penerima, 'id_gudang' => $data->id_unit_pengirim);
        }

        $data = $this->GeneralController->UpdateStok('pengeluaran', $list_barang, $no_surat);

        if($data){
            return response()->json(['status' => 'success'], 200);
        }else{
            return response()->json(['status' => 'failed'], 500);
        }

        
    }

    // get tag from item
    public function cekTagByItem(Request $request) {
        $data = DB::table('pengeluaran_barang_detail_epc_tag')
                ->select('barang_epc_tag.epc_tag', 'nama_barang')
                ->join('barang_epc_tag', 'pengeluaran_barang_detail_epc_tag.id_epc_tag', '=', 'barang_epc_tag.id')
                ->join('barang', 'pengeluaran_barang_detail_epc_tag.id_barang', '=', 'barang.id')
                ->where('pengeluaran_barang_detail_epc_tag.id_pengeluaran_barang_detail', $request->id_detail_pengeluaran)
                ->where('id_barang', $request->id_barang)
                ->get();
        return response()->json(['data' => $data, 'status' => 'success'], 200);
    }
}
