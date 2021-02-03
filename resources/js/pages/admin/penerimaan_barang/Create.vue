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
                  <th>Fraction</th>
                  <th>Aksi</th>
                </tr>
              </thead>
              <tbody class="barangTemporary">
                <tr v-for="(datas, indx) in ListData" :key="indx">
                  <td>{{datas.nama_barang}}</td>
                  <td>
                      <input type="number" class="form-control" @input="getIdBarang(datas.id_barang)" min="0" value="1" style="display: inline-grid;width: 30%; height:20px;"   v-model="qtyInputKecil[datas.id_barang]"> <strong>{{datas.nama_satuan_kecil}}</strong>
                  </td>
                  <td>
                      <input type="number" class="form-control" @input="getIdBarang(datas.id_barang)" min="0" value="1" style="display: inline-grid;width: 30%; height:20px;"   v-model="qtyInputBesar[datas.id_barang]"> <strong>{{datas.nama_satuan_besar}}</strong>
                  </td>
                  <td>{{datas.fraction}}</td>
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
        fraction: [],
      },
      loading: false,
      ListData:[],
      listItem:[],
      listTag:[],
      listSatuan:[],
      qtyInputKecil:[],
      qtyInputBesar:[],
      nama_satuan:'',
      jenis_satuan:[],
      detail:[],
      waterMark : new Date().toISOString().slice(0,10),
    }
  },
  created() {
    this.getListBrg();
  },
  updated(){
    $('a.vsm--link.active').attr('class', 'router-link-exact-active ryan active vsm--link vsm--link_level-1 vsm--link_active vsm--link_exact-active')
 },
  mounted() {
      this.$refs.datePicker.currentValue = [new Date()];
      $('a.vsm--link.active').attr('class', 'router-link-exact-active active vsm--link vsm--link_level-1 vsm--link_active vsm--link_exact-active')
 },
  methods: {
    getIdBarang(id_barang) {
      this.form.id_barang = id_barang;
    },
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
            
            this.form.fraction[items.value] = response.data.fraction;
            var listItem = this.listItem;

            if($.inArray(this.form.id_barang, listItem) >= 0){
              this.$swal('Maaf', 'Barang sudah masuk ke dalam list', 'error');

            }else{
              var data = response.data.list_data;
              this.ListData[this.form.id_barang] = data;
              
              // remove null value of array
              this.ListData = this.ListData.filter(function (el) {
                return el != null && el != "";
              });

              listItem.push(this.form.id_barang);
              this.qtyInputKecil[this.form.id_barang] = 1;
              this.qtyInputBesar[this.form.id_barang] = 1;
            }

          })
          .catch(errors => {
              console.log(errors);
          }).finally(() => {
              this.loading =  false
          });

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
        // remove null value of array
        var qtyInputKecilx = this.qtyInputKecil.filter(function (el) {
          return el != null && el != "";
        });
        // remove null value of array
        var qtyInputBesarx = this.qtyInputBesar.filter(function (el) {
          return el != null && el != "";
        });

        var x = Array();
        $.each(this.ListData, function (k, v) {
            x[k] = {"id_barang": v.id_barang, "id_satuan_barang_besar": v.id_satuan_besar, "id_satuan_barang_kecil": v.id_satuan_kecil, "qty_besar":qtyInputBesarx[k], "qty_kecil":qtyInputKecilx[k]}
        });  
       
        this.detail = x;
        // post data ke api menggunakan axios
        this.loading = true
        axios
          .post("penerimaan_barang/create", {
              no_penerimaan: this.form.no_penerimaan,  
              no_purchase_order: this.form.no_purchase_order,  
              no_spk: this.form.no_spk,  
              tanggal: this.form.tanggal,  
              status_posting: this.form.status_posting,  
              id_vendor: this.form.id_vendor,  
              list_data:this.detail
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
  },
  watch : {
      qtyInputKecil:function(val) {
        this.qtyInputKecil = val;
        var x = this.qtyInputKecil[this.form.id_barang]/ parseInt(this.form.fraction[this.form.id_barang]);
        this.qtyInputBesar[this.form.id_barang] = Math.ceil(x);
      },
      qtyInputBesar : function (val) {
        this.qtyInputBesar = val;
        var x = this.qtyInputBesar[this.form.id_barang]* parseInt(this.form.fraction[this.form.id_barang]);
        this.qtyInputKecil[this.form.id_barang] = Math.ceil(x);
      }
  }
};
</script>