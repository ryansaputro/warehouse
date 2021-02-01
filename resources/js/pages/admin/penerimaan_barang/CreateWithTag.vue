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
              <select class="form-control" v-model="form.status_posting">
                <option value="1">Aktif</option>
                <option value="0">Tidak Aktif</option>
              </select>
            </div>
          </div>
        </div>
      </div>
      <div class="user-data p-3 mt-3">
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
              <!-- <model-select :options="options"
                              v-model="form.id_satuan_barang_besar"
                              placeholder="barang"
                              >
              </model-select> -->
            </div>
            <div class="form-group" v-else-if="form.satuan == 'satuan_kecil'">
              <label>Satuan Kecil</label>
              <input type="text" class="form-control" v-model="form.id_satuan_barang_kecil" value="Pcs" readonly>
              <!-- <model-select :options="options"
                              v-model="form.id_satuan_barang_kecil"
                              placeholder="barang"
                              >
              </model-select> -->
            </div>
            <div class="form-group" v-if="form.satuan != ''">
              <label>Jumlah Kuantitas</label>
              <input type="number" required v-model="form.qty" class="form-control">
            </div>
          </div>
          <div class="col-md-6 mb-2" v-if="form.qty > 0" style="height: 330px;overflow-y: auto;">
            <div v-for="index in getNumbers(0,form.qty)" :key="index">
              <div class="form-group">
                <label v-if="form.satuan == 'satuan_kecil'"> {{form.id_satuan_barang_kecil}} ke {{index+1}} </label>
                <label v-else> {{form.id_satuan_barang_besar}} ke {{index+1}}</label>
                <input type="text" required v-model="form.id_epc_tag[index]" class="form-control is-invalid" v-if="form.id_epc_tag[index] == '' || form.id_epc_tag.length == 0 || form.id_epc_tag[index] === undefined">
                <input type="text" required v-model="form.id_epc_tag[index]" class="form-control is-valid" v-else>

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
                <div class="form-group">
                  <router-link class="btn btn-danger" to="/data-kehadiran">Kembali</router-link>
                  <button class="btn btn-primary">Simpan</button>
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
        no_penerimaan: '',
        no_purchase_order: '',
        no_spk: '',
        tanggal: '',
        status_posting: '1',
        id_vendor: '',
        id_barang: '',
        id_satuan_barang_besar: 'Box',
        id_satuan_barang_kecil: 'Pcs',
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
    this.getNik();
    this.getListBrg();
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
    onChange(event) {
      this.loading = true
      axios.post("penerimaan_barang/getDataListSatuan", {
          id: this.form.id_barang,
          'tipe_satuan': event.target.value
        })
          .then(response => {
              this.form.satuan = event.target.value;
              this.form.satuan == 'satuan_kecil' ? this.form.id_satuan_barang_kecil = response.data[0].nama_satuan : this.form.id_satuan_barang_besar = response.data[0].nama_satuan; 
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
            this.ListData[id_item] = Array(id_item, barang, satuan, epc.length)
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
      var arrayData = this.listItem.splice(idx, 1);
      // remove from list data table
      this.ListData.splice(idx, 1);      
    },
    defaultValue(){
      // this.form.tanggal =  moment(new Date()).format('YYYY-M-D')
    },
      selectFromParentComponent1 () {
        // select option from parent component
        this.form.nik = this.options[0]
      },
    
    getNik() {
      this.loading = true
      axios.get('data-kehadiran/get-nik')
            .then(response => {
                this.options = response.data.data;
                // console.log(this.options)
               
            })
            .catch(errors => {
                console.log(errors);
            }).finally(() => {
                this.loading =  false
            });
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
      // post data ke api menggunakan axios
      this.loading = true
      axios
        .post("data-kehadiran/create", {
          tanggal: this.form.tanggal,
          nik: this.form.nik,
          status: this.form.status,
        })
        .then(response => {
          // push router ke read data
          this.$router.push("/data-kehadiran");
          this.$swal('Created', 'You successfully Created this file', 'success');
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
      getDataNik() {
        this.loading = true
        axios.get('data-kehadiran/get-data-nik', {
              params:{
                tanggal:this.form.tanggal,
                nik:this.form.nik
              }
            })
                .then(response => {
                    this.lastData = response.data.data;
                })
                .catch(errors => {
                    console.log(errors);
                }).finally(() => {
                    this.loading =  false
                });
      },  
  }
};
</script>