<template>
  <div>
    <form @submit.prevent="addData()">
      <div class="loader" v-if="loading"></div>
      <div class="user-data p-3">
        <div class="row">
          <div class="col-md-6">
            <div class="form-group">
              <label>Nomor Penerimaan</label>
              <input type="text" readonly required v-model="form.no_penerimaan" class="form-control">
            </div>
            <div class="form-group">
              <label>Nomor Purchase Order</label>
              <input type="text" required v-model="form.no_purchase_order" placeholder="Masukkan Nomor Purchase Order" class="form-control">
            </div>
            <div class="form-group">
              <label>Nomor Spk</label>
              <input type="text" required v-model="form.no_spk" placeholder="Masukkan Nomor Spk" class="form-control">
            </div>
          </div>
          <div class="col-md-6">
            <div class="form-group">
              <label>Tanggal</label>
              <date-picker ref="datePicker" :placeholder="waterMark"  v-model="form.tanggal" style="width:100%;"  valueType="format"></date-picker>
            </div>
            <div class="form-group">
              <label>Vendor</label>
              <model-select :options="getVendor"
                              v-model="form.id_vendor"
                              placeholder="Pilih Vendor"
                              >
              </model-select>
            </div>
            <div class="form-group">
              <label>Status Posting</label>
              <select class="form-control" readonly disabled v-model="form.status_posting">
                <option value="1">Belum Diposting</option>
                <!-- <option value="0">Telah Diposting</option> -->
              </select>
            </div>
          </div>
        </div>
      </div>
      <div class="user-data p-3 mt-3">
        <div class="row">  
          <div class="col-md-12 mb-2">
            <div class="form-group">
              <label>Barang</label>
               <basic-select :options="getBarang"
                              @select="onSelect"
                              v-model="form.id_barang"
                              placeholder="barang"
                              class="barang">
              </basic-select>
            </div>
            <button type="button" v-if="form.satuan != '' && form.qty > 0" class="btn btn-primary btn-sm btn-block" @click="addItem(form.id_barang)" >Tambah</button>
          </div>
          <div class="col-md-12">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th>Barang</th>
                  <th>Satuan Kecil</th>
                  <th>Satuan Besar</th>
                  <th>Aksi</th>
                </tr>
              </thead>
              <tbody class="barangTemporary">
                <tr v-for="(datas, indx) in ListData" :key="indx">
                  <td>{{datas.nama_barang}}</td>
                  <td>
                      <input type="number" class="form-control" v-bind:readonly="jenis_satuan[datas.id_barang] == 0" style="display: inline-grid;width: 50%;"  @input="changeListQty(datas.id_barang)" v-model="qtyInputKecil"> {{datas.nama_satuan_kecil}}
                  </td>
                  <td>
                      <input type="number" class="form-control" v-bind:readonly="jenis_satuan[datas.id_barang] == 1" style="display: inline-grid;width: 50%;"   v-model="qtyInputBesar"> {{datas.nama_satuan_besar}}
                  </td>
                  <td>
                    <button class="btn btn-danger btn-sm" type="button" @click="HapusList(indx, datas[0])">hapus list</button>
                  </td>
                </tr>
              </tbody>
            </table>
                <div class="form-group">
                  <router-link class="btn btn-danger" to="/penerimaan_barang">Kembali</router-link>
                  <button class="btn btn-primary" v-if="ListData.length > 0">Simpan</button>
                </div>

          </div>
        </div>
      </div>
    </form>
  </div>
</template>
<script>
// import 'vue2-daterange-picker/dist/vue2-daterange-picker.css'
import DatePicker from 'vue2-datepicker';
import 'vue2-datepicker/index.css';
import 'vue-search-select/dist/VueSearchSelect.css'
import { ModelSelect, BasicSelect  } from 'vue-search-select'
//you need to import the CSS manually (in case you want to override it)
export default {
  components: {DatePicker, ModelSelect, BasicSelect  },
  data(){
    return{
      selectedDate1: "",
      options: [],
      getBarang: [],
      getVendor: [],
      form:{
        no_penerimaan: '',
        no_purchase_order: '',
        no_spk: '',
        tanggal: moment(new Date()).format('YYYY-M-D'),
        status_posting: '1',
        id_vendor: '',
        id_barang: '',
        id_satuan_barang_besar: '',
        nama_satuan_barang_besar: 'Box',
        id_satuan_barang_kecil: '',
        nama_satuan_barang_kecil: 'Box',
        id_satuan: '',
        konversi:'',
        satuan:'',
        id_epc_tag: [],
        qtylistkecil: [],
        qtylistbesar: [],
        qty: '',
        fraction: '',
      },
      loading: false,
      ListData:[],
      listItem:[],
      listTag:[],
      listSatuan:[],
      nama_satuan:'',
      jenis_satuan:[],
      waterMark : new Date().toISOString().slice(0,10),
    }
  },
  created() {
    this.getListBrg();
  },
  mounted() {
      this.$refs.datePicker.currentValue = [new Date()];
      $('a.vsm--link.active').attr('class', 'router-link-exact-active active vsm--link vsm--link_level-1 vsm--link_active vsm--link_exact-active')
 },
  methods: {
    changeFormat() {
      this.form.no_purchase_order.toUpperCase();
    },
    onSelect (items) {
      $('.ui.fluid.search.selection.dropdown.barang').find('.text.default').remove();
      $('.ui.fluid.search.selection.dropdown.barang').append('<div data-vss-custom-attr="" class="text default">'+items.text+'</div>');
      
      this.form.id_barang = items.value;
      this.loading = true
      axios.post("GetDataSatuan", {
          id: items.value,
        })
          .then(response => {
            // console.log(response.data);
            this.listSatuan = response.data.satuan;
            this.form.fraction = response.data.fraction;

          })
          .catch(errors => {
              console.log(errors);
          }).finally(() => {
              this.loading =  false
          });

      },
    //jumlah kuantitas
    getNumbers:function(start,stop){
      return new Array(stop-start).fill(start).map((n,i)=>n+i);
    },
    addItem(id_item) {
      var barang = $('.barang').find('.menu').find('.item.selected').text();
      var epc = this.form.id_epc_tag;

      if ((id_item == '')){
          this.$swal('Maaf', 'Silahkan pilih barang', 'error');
          
      }else {
          this.listTag[id_item] = epc;

          var listItem = this.listItem;
          if($.inArray(id_item, listItem) >= 0){
            this.$swal('Maaf', 'Barang sudah masuk ke dalam list', 'error');

          }else{
            listItem.push(id_item);
            // this.ListData[id_item] = Array(id_item, barang, this.nama_satuan, this.form.qty)
            this.ListData[id_item] = {id_barang:id_item, 
                                      nama_barang:barang, 
                                      id_satuan_besar:this.form.id_satuan_barang_besar, 
                                      nama_satuan_besar:this.form.nama_satuan_barang_besar, 
                                      id_satuan_kecil:this.form.id_satuan_barang_kecil, 
                                      nama_satuan_kecil:this.form.nama_satuan_barang_kecil, 
                                      qty_konversi:this.form.konversi,
                                      qty:this.form.qty}
            // remove null value of array
            this.ListData = this.ListData.filter(function (el) {
              return el != null && el != "";
            });
          }
          $('.ui.fluid.search.selection.dropdown.barang').find('.text.default').remove();
          $('.ui.fluid.search.selection.dropdown.barang').append('<div data-vss-custom-attr="" class="text default">barang</div>');
          this.listSatuan = [];
          //reset inputan
          // this.form.id_barang = '';
          this.form.satuan = '';
          // this.form.qty = '';
          this.form.id_epc_tag = [];

      }
    },
    EditList(a) {
      var input = "";
      $.each(this.listTag[a], function(k,v){
        input += '<label>Epc tag ke '+parseInt(k+1)+'</label> : '+v+'<br>';
      });

      this.$swal.fire({
            html: input,  
            width: 800,
            allowOutsideClick:false,
            showConfirmButton: true
          })
    },
    HapusList(idx, id_item){
      //remove from list data
      this.listItem.splice(idx, 1);
      // remove from list data table
      this.ListData.splice(idx, 1);      
    },
    getListBrg() {
      this.loading = true
      axios.get('MasterData')
            .then(response => {
                this.getBarang = response.data.data;
                this.getVendor = response.data.vendor;
                this.form.no_penerimaan = response.data.format;

            })
            .catch(errors => {
                console.log(errors);
            }).finally(() => {
                this.loading =  false
            });
    },
    addData() {
      if((this.form.no_penerimaan == '') || 
          (this.form.no_purchase_order == '') || 
            (this.form.no_spk == '') || 
              (this.form.tanggal == '') || 
                (this.form.status_posting == '') || 
                  (this.form.id_vendor == '') || 
                    (this.ListData == 0))
      {
        this.$swal('Maaf', 'Sepertinya ada inputan yang belum diisi.', 'error');
      }else{
        // post data ke api menggunakan axios
        // this.loading = true
        axios
          .post("penerimaan_barang/create", {
              no_penerimaan: this.form.no_penerimaan,  
              no_purchase_order: this.form.no_purchase_order,  
              no_spk: this.form.no_spk,  
              tanggal: this.form.tanggal,  
              status_posting: this.form.status_posting,  
              id_vendor: this.form.id_vendor,  
              list_data:this.ListData
          })
          .then(response => {
            // push router ke read data
            this.$router.push("/penerimaan_barang");
            this.$swal('Berhasil', 'Penerimaan Barang berhasil dibuat', 'success');
          })
          .catch(errors => {
              // this.$swal('Failed', 'You failed Created this file', 'error');
              if (errors.response) {
                  var data = '';
                  $.each(errors.response.data.errors, function(k,v){
                    data += v[0]+"\n";
                  });
                  this.$swal('Gagal', data, 'error');
                // client received an error response (5xx, 4xx)
              } else if (errors.request) {
                  console.log(errors.request);
                  console.log("request never left")
                // client never received a response, or request never left
              } else {
                console.log("lainnya")
              }
  
          }).finally(() => {
              this.loading =  false
          });
      }
    },
  },
  computed: {
    listDataWithInputChange: {
      get(){
        // this.form.qty = '';
        // this.form.konversi=''
        return this.ListData.filter((t) => {
          if(parseInt(t.qty) > t.qty_konversi){
            this.jenis_satuan[t.id_barang] = "kecil";
            this.form.qtylistkecil[t.id_barang] = t.qty;
            this.form.qtylistbesar[t.id_barang] = t.qty_konversi;
          }else{
            this.jenis_satuan[t.id_barang] = "besar";
            this.form.qtylistkecil[t.id_barang] = t.qty_konversi;
            this.form.qtylistbesar[t.id_barang] = t.qty;
          }

          // console.log(this.form.qtylistkecil)
          // console.log(this.form.qtylistbesar)
          return t; 
        });
      },
      set(newValue){
          // this.form.qty = newValue;
          console.log("values "+ this.form.qtylistkecil)
           this.ListData.filter((t) => {
          if(parseInt(t.qty) > t.qty_konversi){
            this.jenis_satuan[t.id_barang] = "kecil";
            this.form.qtylistkecil[t.id_barang] = newValue;
            this.form.qtylistbesar[t.id_barang] = t.qty_konversi;
          }else{
            this.jenis_satuan[t.id_barang] = "besar";
            this.form.qtylistkecil[t.id_barang] = t.qty_konversi;
            this.form.qtylistbesar[t.id_barang] = newValue;
          }

          console.log(this.form.qtylistkecil)
          console.log(this.form.qtylistbesar)
        //   return t; 
        });
      }

    },
    qtyInputKecil: {
      get(){
        console.log("satuan kecil "+this.jenis_satuan[this.form.id_barang]);
        console.log(this.form.qty)
        if(this.jenis_satuan[this.form.id_barang] == 0){
          this.form.qtylistkecil[this.form.id_barang] = this.form.qty;
          this.form.qtylistbesar[this.form.id_barang] = this.form.konversi;
        }else{
          this.form.qtylistkecil[this.form.id_barang] = this.form.konversi;
          this.form.qtylistbesar[this.form.id_barang] = this.form.qty;
        }
        return this.form.qtylistkecil[this.form.id_barang];
      },
      set(newValue){
        this.form.qtylistkecil[this.form.id_barang] = newValue;
          // this.value.second = newValue;
      }
    },
    
    qtyInputBesar: {
      get(){

        if(this.jenis_satuan[this.form.id_barang] == 1){
          this.form.qtylistkecil[this.form.id_barang] = this.form.konversi;
          this.form.qtylistbesar[this.form.id_barang] = this.form.qty;
        }else{
          this.form.qtylistbesar[this.form.id_barang] = this.form.konversi;
          this.form.qtylistkecil[this.form.id_barang] = this.form.qty;
        }
        
        return this.form.qtylistbesar[this.form.id_barang];
      },
      set(newValue){
        this.form.qtylistbesar[this.form.id_barang] = newValue;
          // this.value.second = newValue;
      }
    },

  }
};
</script>