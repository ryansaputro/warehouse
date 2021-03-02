<?php
/**
 * @author ryan saputro
 * @email ryansaputro52@gmail.com
 * @create date 2020-10-01 13:24:39
 * @modify date 2020-10-01 13:24:39
 * @desc handle url to request
 */

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});

//auth
Route::prefix('v1')->group(function () {
    Route::prefix('auth')->group(function () {
        Route::get('checkUser', 'HomeController@checkUser');

        // Below mention routes are public, user can access those without any restriction.
        // Create New User
        Route::post('register', 'AuthController@register');
        // Login User
        Route::post('login', 'AuthController@login');
        // Below mention routes are available only for the authenticated users.
        // // Refresh the JWT Token
        Route::get('refresh', 'AuthController@refresh');
        
        Route::middleware(['auth:api', 'jwt.verify'])->group(function () {
            Route::get('users', 'UserController@getAuthenticatedUser');
            // Get user info
            Route::get('user', 'AuthController@user');
            // Logout user from application
            Route::post('logout', 'AuthController@logout');

                    

        });

    });

    //utk update password pengguna aplikasi
    Route::post('/update-password','AuthController@updatePassword');

    //general 
    Route::get('/MasterData','GeneralController@MasterData');
    Route::post('/GetDataSatuan','GeneralController@GetDataSatuan');
    Route::get('/GetDataSatuan','GeneralController@GetDataSatuan');
    Route::get('/GetInfoStok','GeneralController@GetInfoStok');
    Route::post('/UpdateStok','GeneralController@UpdateStok');
    Route::get('/GetKodeBarangbyRFID','GeneralController@GetKodeBarangbyRFID');

    //penerimaan 
    Route::prefix('penerimaan_barang')->group(function() {
        Route::post('/create','PenerimaanBarangController@store');
        Route::get('/index','PenerimaanBarangController@index');
        Route::post('/deleteItemPenerimaan','PenerimaanBarangController@deleteItemPenerimaan');
        Route::post('/deletePenerimaan','PenerimaanBarangController@deletePenerimaan');
        Route::post('/cekposting','PenerimaanBarangController@cekposting');
        Route::post('/posting','PenerimaanBarangController@posting');
        Route::post('/updateStok','PenerimaanBarangController@updateStok');
        Route::post('/cekTagByItem','PenerimaanBarangController@cekTagByItem');
        Route::get('/{no_penerimaan}/posting','PenerimaanBarangController@show');
        Route::get('/{no_penerimaan}/update','PenerimaanBarangController@show');
        Route::post('/{no_penerimaan}/update','PenerimaanBarangController@update');
        Route::get('/{no_penerimaan}/MappingItemAndTag','PenerimaanBarangController@show');
        Route::post('/{no_penerimaan}/MappingItemAndTag','PenerimaanBarangController@MappingItemAndTagSave');
    });
    
    //pengeluaran
    Route::prefix('pengeluaran_barang')->group(function() {
        Route::get('/index','PengeluaranBarangController@index');
        Route::post('/create','PengeluaranBarangController@store');
        Route::post('/cekposting','PengeluaranBarangController@cekposting');
        Route::post('/posting','PengeluaranBarangController@posting');
        Route::post('/updateStok','PengeluaranBarangController@updateStok');
        Route::post('/deletePengeluaran','PengeluaranBarangController@deletePengeluaran');
        Route::get('/{no_pengeluaran}/update','PengeluaranBarangController@show');
        Route::post('/{no_pengeluaran}/update','PengeluaranBarangController@update');
        Route::post('/cekTagByItem','PengeluaranBarangController@cekTagByItem');
    });

});

