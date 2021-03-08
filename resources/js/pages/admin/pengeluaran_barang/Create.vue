<template>
  <div>
    <form @submit.prevent="addData()">
      <div class="loader" v-if="loading"></div>
      <div class="user-data p-3">
        <div class="row">
          <div class="col-md-6">
            <div class="form-group">
              <label>Nomor Pengeluaran</label>
              <input type="text" readonly required v-model="form.no_pengeluaran" class="form-control">
            </div>
            <div class="form-group">
              <label>Tanggal</label>
              <date-picker ref="datePicker" :placeholder="waterMark"  v-model="form.tanggal" style="width:100%;"  valueType="format"></date-picker>
            </div>
            <div class="form-group">
              <label>Status Posting</label>
              <select class="form-control" readonly disabled v-model="form.status_posting">
                <option value="1">Belum Diposting</option>
                <!-- <option value="0">Telah Diposting</option> -->
              </select>
            </div>

          </div>
          <div class="col-md-6">
            <div class="form-group">
              <label>Unit Pengirim</label>
              <!-- <model-select :options="getUnit"
                              v-model="form.id_unit_pengirim"
                              placeholder="Pilih Unit Pengirim"
                              >
              </model-select> -->
              <select
                class="form-control"
                v-model="form.id_unit_pengirim"
                >
                <option v-for="(data, idx) in getUnit" :key="idx" :value="data.value">{{data.text}}</option>
              </select>
            </div>
            <div class="form-group">
              <label>Lokasi Pengirim</label>
              <!-- <model-select :options="getGudang"
                              v-model="form.id_lokasi_pengirim"
                              placeholder="Pilih Lokasi Pengirim"
                              >
              </model-select> -->
              <select
                class="form-control"
                v-model="form.id_lokasi_pengirim"
                >
                <option v-for="(data, idx) in getGudang" :key="idx" :value="data.value">{{data.text}}</option>
              </select>
            </div>
            <div class="form-group">
              <label>Unit Penerima</label>
              <!-- <model-select :options="getUnit"
                              v-model="form.id_unit_penerima"
                              placeholder="Pilih Unit Penerima"
                              >
              </model-select> -->
              <select
                class="form-control"
                v-model="form.id_unit_penerima"
                >
                <option v-for="(data, idx) in getUnit" :key="idx" :value="data.value" :disabled="data.value == form.id_unit_pengirim  ? true : false">{{data.text}}</option>
              </select>

            </div>
            <div class="form-group">
              <label>Lokasi Penerimaan</label>
              <!-- <model-select :options="getGudang"
                              v-model="form.id_lokasi_penerima"
                              placeholder="Pilih Lokasi Penerimaan"
                              >
              </model-select> -->
              <select
                class="form-control"
                v-model="form.id_lokasi_penerima"
                >
                <option v-for="(data, idx) in getGudang" :key="idx" :value="data.value" :disabled="data.value == form.id_lokasi_pengirim ? true : false">{{data.text}}</option>
              </select>
            </div>
          </div>
        </div>
      </div>
      <div class="user-data p-3 mt-3" v-if="form.id_lokasi_pengirim != ''">
        <div class="row">  
          <div class="col-md-6 mb-2">
            <div class="form-group">
              <label>Barang</label>
              <model-select :options="getBarang"
                              v-model="form.id_barang"
                              placeholder="barang"
                              class="barang"
                              >
              </model-select>
            </div>
            <div class="form-group" v-if="form.id_barang != ''">
              <label>Satuan Pengeluaran Barang</label>
              <select class="form-control" v-model="form.satuan" @change="onChange($event)">
                <option value="" disabled>-Pilih Satuan-</option>
                <option value="satuan_besar">Satuan Besar</option>
                <option value="satuan_kecil">Satuan Kecil</option>
              </select>
            </div>
            <div class="form-group" v-if="form.satuan == 'satuan_besar'">
              <label>Satuan Besar</label>
              <input type="text" class="form-control" v-model="form.id_satuan_barang_besar" value="Box" readonly>
            </div>
            <div class="form-group" v-else-if="form.satuan == 'satuan_kecil'">
              <label>Satuan Kecil</label>
              <input type="text" class="form-control" v-model="form.id_satuan_barang_kecil" value="Pcs" readonly>
            </div>
            <div class="form-group" v-if="form.satuan != ''">
              <label>Jumlah Kuantitas</label>
              <input type="number" :max="form.stok" min="1" @input="qtyCheck" required v-model="form.qty" class="form-control">
            </div>
          </div>
          <div class="col-md-6 mb-2" v-if="form.qty > 0" style="height: 330px;overflow-y: auto;">
            <div v-for="index in getNumbers(0,form.qty)" :key="index">
              <div class="form-group">
                
                <label v-if="form.satuan == 'satuan_kecil'"> {{form.id_satuan_barang_kecil}} ke {{index+1}} </label>
                <label v-else> {{form.id_satuan_barang_besar}} ke {{index+1}}</label>
                <!-- <model-select :options="getTag"
                              v-model="form.id_epc_tag[index]"
                              placeholder="Pilih Tag"
                              >
                </model-select> -->
                <select
                  v-model="form.id_epc_tag[index]"
                  class="form-control"
                >
                  <option v-for="(data, idx) in getTag" :key="idx" :value="data.text" :disabled="checkData == data.text ? true : false">{{data.text}}</option>
                </select>
                <!-- <multiselect v-model="form.id_epc_tag[index]" :options="getTag" :hideSelected="true"  placeholder="Select one" label="text" track-by="value"></multiselect> -->
                <!-- <input type="text" required v-model="form.id_epc_tag[index]" class="form-control is-invalid" v-if="form.id_epc_tag[index] == '' || form.id_epc_tag.length == 0 || form.id_epc_tag[index] === undefined">
                <input type="text" required v-model="form.id_epc_tag[index]" class="form-control is-valid" v-else> -->

              </div>
            </div>
            <button type="button" class="btn btn-primary btn-sm btn-block" @click="addItem(form.id_barang)" >Tambah</button>
          </div>
          <div class="col-md-12">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th>Barang</th>
                  <th>Satuan</th>
                  <th>Qty</th>
                  <th>Aksi</th>
                </tr>
              </thead>
              <tbody class="barangTemporary">
                <tr v-for="(datas, indx) in ListData" :key="indx">
                  <td>{{datas[1]}}</td>
                  <td>{{datas[2]}}</td>
                  <td>{{datas[3]}}</td>
                  <td>
                    <button class="btn btn-warning btn-sm" type="button" @click="EditList(datas[0])">daftar tag</button>
                    <button class="btn btn-danger btn-sm" type="button" @click="HapusList(indx, datas[0])">hapus list</button>
                  </td>
                </tr>
              </tbody>
            </table>
            <div class="col-md-12">
              <div class="form-group">
                <router-link class="btn btn-danger" to="/pengeluaran_barang">Kembali</router-link>
                <button class="btn btn-primary">Simpan</button>
              </div>
            </div>
          </div>
        </div>
      </div>

    </form>
  </div>
</template>
<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>
<script>
// import 'vue2-daterange-picker/dist/vue2-daterange-picker.css'
import DatePicker from 'vue2-datepicker';
import 'vue2-datepicker/index.css';
import 'vue-search-select/dist/VueSearchSelect.css'
import { ModelSelect, BasicSelect  } from 'vue-search-select'
import Multiselect from 'vue-multiselect'
//you need to import the CSS manually (in case you want to override it)
export default {
  components: {DatePicker, ModelSelect, BasicSelect, Multiselect  },
  data(){
    return{
      options: [],
      getUnit: [],
      getGudang: [],
      getBarang: [],
      getTag: [],
      ListData:[],
      listItem:[],
      listTag:[],

      form:{
        tanggal: moment(new Date()).format('YYYY-M-D'),
        status_posting: '1',
        no_pengeluaran: '',
        id_unit_pengirim: '',
        id_unit_penerima: '',
        id_barang: '',
        id_satuan_barang_besar: 'Box',
        id_satuan_barang_kecil: 'Pcs',
        satuan:'',
        id_lokasi_pengirim:'',
        id_lokasi_penerima:'',
        id_epc_tag: [],
        qty: '',
        stok:0
      },
      id_satuan:'',
      loading: false,
      waterMark : new Date().toISOString().slice(0,10),
    }
  },
  created() {
    this.getMaster();
  },
  updated(){
      $('a.vsm--link.active').attr('class', 'router-link-exact-active ryan active vsm--link vsm--link_level-1 vsm--link_active vsm--link_exact-active')
  },
  mounted() {
      this.$refs.datePicker.currentValue = [new Date()];
      $('a.vsm--link.active').attr('class', 'router-link-exact-active active vsm--link vsm--link_level-1 vsm--link_active vsm--link_exact-active')
 },
  methods: {
    qtyCheck() {
      if(this.form.qty > this.form.stok){
        this.form.qty = 0;
      }
    },
    addData() {
      if((this.form.no_pengeluaran == '') || 
          (this.form.tanggal == '') || 
            (this.form.status_posting == '') || 
              (this.form.id_unit_pengirim == '') ||
                (this.form.id_unit_penerima == ''))
      {
        this.$swal('Maaf', 'Sepertinya ada inputan yang belum diisi.', 'error');
      }else{
        // post data ke api menggunakan axios
        this.loading = true
        axios
          .post("pengeluaran_barang/create", {
              no_pengeluaran: this.form.no_pengeluaran,  
              tanggal: this.form.tanggal,  
              status_posting: this.form.status_posting,  
              id_unit_pengirim: this.form.id_unit_pengirim,  
              id_unit_penerima: this.form.id_unit_penerima,  
              id_lokasi_pengirim: this.form.id_lokasi_pengirim,  
              id_lokasi_penerima: this.form.id_lokasi_penerima,  
              list_data: this.ListData,
              list_tag: this.listTag
          })
          .then(response => {
            // push router ke read data
            this.$router.push("/pengeluaran_barang");
            this.$swal('Berhasil', 'Pengeluaran Barang berhasil dibuat', 'success');
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
    getMaster() {
      this.loading = true
      axios.get('MasterData')
            .then(response => {
                this.getUnit = response.data.unit;
                this.getGudang = response.data.gudang;
                this.form.no_pengeluaran = response.data.format_pengeluaran;
                this.getBarang = response.data.data;

            })
            .catch(errors => {
                console.log(errors);
            }).finally(() => {
                this.loading =  false
            });
    },
    onChange(event) {
      this.loading = true
      axios.post("GetDataSatuan", {
          id: this.form.id_barang,
          tipe_satuan: event.target.value,
          lokasi_pengirim: this.form.id_lokasi_pengirim
        })
          .then(response => {
            // console.log(response.data.satuan[0].nama_satuan)
              this.form.satuan = event.target.value;
              this.form.satuan == 'satuan_kecil' ? this.form.id_satuan_barang_kecil = response.data.satuan[0].nama_satuan : this.id_satuan = response.data.satuan[1].nama_satuan; 
              this.form.satuan == 'satuan_kecil' ? this.id_satuan = response.data.satuan[0].id : this.id_satuan = response.data.satuan[1].id; 
              this.getTag = response.data.usedTag;
              this.form.stok = Number(response.data.stok);
              
          })
          .catch(errors => {
              console.log(errors);
          }).finally(() => {
              this.loading =  false
          });
    },
    getNumbers:function(start,stop){
      return new Array(stop-start).fill(start).map((n,i)=>n+i);
    },
    addItem(id_item) {
      var barang = $('.barang').find('.menu').find('.item.selected').text();
      var epc = this.form.id_epc_tag;
      var data = Array();

      if (($.inArray('', epc) >= 0)  || epc.length != this.form.qty || (id_item == '')){
          this.$swal('Maaf', 'EPC Tag belum terisi semua', 'error');
          
      }else {
          this.listTag[id_item] = epc;

          if(this.form.satuan == 'satuan_kecil'){
            var satuan = this.form.id_satuan_barang_kecil;
            this.info_satuan = this.form.id_satuan_barang_kecil;;
          }else{
            var satuan = this.form.id_satuan_barang_besar;
            this.info_satuan = this.form.id_satuan_barang_besar;;
          }


          var listItem = this.listItem;
          if($.inArray(id_item, listItem) >= 0){
            this.$swal('Maaf', 'Barang sudah masuk ke dalam list', 'error');

          }else{
            listItem.push(id_item);
            this.ListData[id_item] = Array(id_item, barang, satuan, epc.length, this.id_satuan)
            // remove null value of array
            this.ListData = this.ListData.filter(function (el) {
              return el != null && el != "";
            });
          }

          //reset inputan
          this.form.id_barang = '';
          this.form.satuan = '';
          this.form.qty = '';
          this.form.id_epc_tag = [];

      }
    },
    EditList(a) {
      var input = "<table class='table table-striped'><tr><th>No</th><th>List Barang</th><th>List Tag</th></tr>";
      $.each(this.listTag[a], function(k,v){
        input += '<tr><td>'+(k+1)+'</td><td>Epc tag ke '+parseInt(k+1)+'</td><td>'+v+'</td></tr>';
      });
      input += "</table>"

      this.$swal.fire({
            html: input,  
            width: 800,
            allowOutsideClick:false,
            showConfirmButton: true
          })
    },
    HapusList(idx, id_item){
      //remove from list data
      var arrayData = this.listItem.splice(idx, 1);
      // remove from list data table
      this.ListData.splice(idx, 1);      
    },

  },
  computed: {
    checkData: function() {
      return this.form.id_epc_tag;
    },
    cekUnit: function() {
      return this.form.id_unit_penerima;
    },
    cekLokasi: function() {
      return this.form.id_lokasi_penerima;
    }
  },
  watch : {
  },
  updated() {
  },
};
</script>