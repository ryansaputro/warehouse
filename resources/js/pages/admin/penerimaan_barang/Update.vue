<template>
  <div>
    <form @submit.prevent="addData()">
      <div class="loader" v-if="loading"></div>
      <div class="user-data p-3">
        <div class="row">
          <table class="table table-striped">
            <tbody>
              <tr>
                <td>No Penerimaan</td>
                <td>:</td>
                <th>{{form.no_penerimaan}}</th>
                <td>Tanggal</td>
                <td>:</td>
                <th>{{form.tanggal}}</th>
              </tr>
              <tr>
                <td>No Purchase Order</td>
                <td>:</td>
                <th>{{form.no_purchase_order}}</th>
                <td>Vendor</td>
                <td>:</td>
                <th>{{form.nama_vendor}}</th>
              </tr>
              <tr>
                <td>No Spk</td>
                <td>:</td>
                <th>{{form.no_spk}}</th>
                <td>Status</td>
                <td>:</td>
                <th>{{form.status_posting == '1' ? 'Aktif' : 'Tidak Aktif'}}</th>
              </tr>
            </tbody>
          </table>
          <!-- <div class="col-md-6">
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
              <select class="form-control" v-model="form.status_posting">
                <option value="1">Aktif</option>
                <option value="0">Tidak Aktif</option>
              </select>
            </div>
          </div> -->
        </div>
      </div>
      <div class="user-data p-3 mt-3">
        <div class="row">  
          <div class="col-md-12 mb-2">
            <div class="form-group">
              <label>Barang</label>
              <model-select :options="getBarang"
                              v-model="form.id_barang"
                              placeholder="barang"
                              class="barang"
                              >
              </model-select>
            </div>
            <div class="form-group">
              <label>Satuan Penerimaan Barang</label>
              <select class="form-control" v-model="form.satuan" @change="onChange($event)">
                <option value="" disabled>-Pilih Satuan-</option>
                <option value="satuan_besar">Satuan Besar</option>
                <option value="satuan_kecil">Satuan Kecil</option>
              </select>
            </div>
            <div class="form-group" v-if="form.satuan == 'satuan_besar'">
              <label>Satuan Besar</label>
              <input type="text" class="form-control" v-model="form.id_satuan_barang_besar" value="Box" readonly>
              <input type="hidden" class="form-control" v-model="form.id_satuan" value="Box" readonly>
            </div>
            <div class="form-group" v-else-if="form.satuan == 'satuan_kecil'">
              <label>Satuan Kecil</label>
              <input type="text" class="form-control" v-model="form.id_satuan_barang_kecil" value="Pcs" readonly>
              <input type="hidden" class="form-control" v-model="form.id_satuan" value="Pcs" readonly>
            </div>
            <div class="form-group" v-if="form.satuan != ''">
              <label>Jumlah Kuantitas</label>
              <input type="number" required v-model="form.qty" class="form-control">
            </div>
            <button type="button" v-if="form.satuan != '' && form.qty > 0" class="btn btn-primary btn-sm btn-block" @click="addItem(form.id_barang)" >Tambah</button>
          </div>
          <div class="col-md-12">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th>Barang</th>
                  <th>Qty</th>
                  <th>Satuan</th>
                  <th>Aksi</th>
                </tr>
              </thead>
              <tbody class="barangTemporary">
                <tr v-for="(datas, indx) in ListData" :key="indx">
                  <td>{{datas.nama_barang}}</td>
                  <td>{{datas.qty}}</td>
                  <td class="text-uppercase">{{datas.nama_satuan}}</td>
                  <td>
                    <!-- <button class="btn btn-warning btn-sm" type="button" @click="EditList(datas[0])">daftar tag</button> -->
                    <button class="btn btn-danger btn-sm" type="button" @click="HapusList(indx, datas.id_barang)">hapus list</button>
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
import { ModelSelect } from 'vue-search-select'
//you need to import the CSS manually (in case you want to override it)
export default {
  components: {DatePicker, ModelSelect },
  data(){
    return{
      selectedDate1: "",
      options: [],
      getBarang: [],
      getVendor: [],
      form:{
        id_penerimaan: '',
        no_penerimaan: '',
        no_purchase_order: '',
        no_spk: '',
        tanggal: moment(new Date()).format('YYYY-M-D'),
        status_posting: '1',
        nama_vendor: '',
        id_barang: '',
        id_satuan_barang_besar: 'Box',
        id_satuan_barang_kecil: 'Pcs',
        id_satuan: '',
        satuan:'',
        id_epc_tag: [],
        qty: '',
      },
      loading: false,
      ListData:[],
      listItem:[],
      listTag:[],
      // time1:  moment(new Date()).format('YYYY-M-D'),
      waterMark : new Date().toISOString().slice(0,10),
    }
  },
  props: {
    value: {
      type: String,
      // default: moment().format('DD-MM-YYYY')
    }
  },
  created() {
    this.getListBrg();
    this.loadData();
    // var link = $('a.vsm--link.active').attr('href');
    // if(link == '/penerimaan_barang'){
      // $('a.vsm--link.active').attr('class', 'router-link-exact-active active vsm--link vsm--link_level-1 vsm--link_active vsm--link_exact-active')
    // }
    // this.time1 = moment(new Date()).format('YYYY-M-D');
  },
  mounted() {
      // this.time1 = moment(new Date()).format('YYYY-M-D');
      this.$refs.datePicker.currentValue = [new Date()];
      $('a.vsm--link.active').attr('class', 'router-link-exact-active active vsm--link vsm--link_level-1 vsm--link_active vsm--link_exact-active')
 },
  methods: {
    changeFormat() {
      this.form.no_purchase_order.toUpperCase();
      // no_spk
    },
    onChange(event) {
      this.loading = true
      axios.post("penerimaan_barang/getDataListSatuan", {
          id: this.form.id_barang,
          tipe_satuan: event.target.value
        })
          .then(response => {
              this.form.satuan = event.target.value;
              this.form.satuan == 'satuan_kecil' ? this.form.id_satuan_barang_kecil = response.data[0].nama_satuan : this.form.id_satuan_barang_besar = response.data[0].nama_satuan; 
              this.form.id_satuan = response.data[0].id;
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

          if(this.form.satuan == 'satuan_kecil'){
            var satuan = this.form.id_satuan_barang_kecil;
            this.info_satuan = this.form.id_satuan;
          }else{
            var satuan = this.form.id_satuan_barang_besar;
            this.info_satuan = this.form.id_satuan;
          }

          var listItem = this.listItem;
          if($.inArray(id_item, listItem) >= 0){
            this.$swal('Maaf', 'Barang sudah masuk ke dalam list', 'error');

          }else{
            listItem.push(id_item);
            this.ListData[id_item] = Array(id_item, barang, satuan, this.form.qty)
            this.ListData[id_item] = {id_barang:id_item, nama_barang:barang, nama_satuan:satuan, id_satuan:this.info_satuan, qty:this.form.qty}
            // remove null value of array
            this.ListData = this.ListData.filter(function (el) {
              return el != null && el != "";
            });
          }

          console.log(this.ListData)
          //reset inputan
          this.form.id_barang = '';
          this.form.satuan = '';
          this.form.qty = '';
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
      console.log(id_item)
        axios
          .post("penerimaan_barang/delete", {
              id_penerimaan: this.form.id_penerimaan,  
              id_barang: id_item,  
          })
          .then(response => {
              //remove from list data
              this.listItem.splice(idx, 1);
              // remove from list data table
              this.ListData.splice(idx, 1);      

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

    },
    defaultValue(){
      // this.form.tanggal =  moment(new Date()).format('YYYY-M-D')
    },    
    getListBrg() {
      this.loading = true
      axios.get('penerimaan_barang/getDataListBarang')
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
    loadData() {
       this.loading =  true;
      // put data ke api menggunakan axios
      axios
        .get("penerimaan_barang/" + this.$route.params.id+ "/edit")
        .then(response => {
          this.form.id_penerimaan = response.data.data.id;
          this.form.no_penerimaan = response.data.data.no_penerimaan;
          this.form.no_purchase_order = response.data.data.no_purchase_order;
          this.form.no_spk = response.data.data.no_spk;
          this.form.tanggal = response.data.data.created_at;
          this.form.status_posting = response.data.data.status_posting;
          this.form.nama_vendor = response.data.data.nama_vendor;
          this.ListData = response.data.detail;
          this.listItem = response.data.id_barang;
        })
        .catch(errors => {
            
        }).finally(() => {
            this.loading =  false
        });
    }
  }
};
</script>