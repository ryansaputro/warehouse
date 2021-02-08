<template>
  <div>
    <form @submit.prevent="addData()">
      <div class="loader" v-if="loading"></div>
      <div class="user-data p-3">
        <div class="row">
          <table class="table table-striped">
            <tr>
              <th>Nomor Penerimaan</th>
              <th>:</th>
              <th>{{form.no_penerimaan}}</th>
              <th>Tanggal</th>
              <th>:</th>
              <th>{{form.tanggal}}</th>
            </tr>
            <tr>
              <th>Nomor Purchase Order</th>
              <th>:</th>
              <th>{{form.no_purchase_order}}</th>
              <th>Vendor</th>
              <th>:</th>
              <th>{{form.id_vendor}}</th>
            </tr>
            <tr>
              <th>Nomor Spk</th>
              <th>:</th>
              <th>{{form.no_spk}}</th>
              <th>Status</th>
              <th>:</th>
              <th>{{form.status_posting == '1' ? 'belum posting' : 'telah posting'}}</th>
            </tr>
          </table>
        </div>
      </div>
      <div class="user-data p-3 mt-3">
        <div class="row">  
          <div class="col-md-12">
            <table class="table table-striped">
              <thead>
                <tr>
                  <th>Barang</th>
                  <th>Satuan Kecil</th>
                  <th>Satuan Besar</th>
                  <th>Fraction</th>
                  <th>Gudang</th>
                </tr>
              </thead>
              <tbody class="barangTemporary">
                <tr v-for="(datas, indx) in ListData" :key="indx">
                  <td>{{datas.nama_barang}}</td>
                  <td>
                    {{qtyInputKecil[datas.id_barang]}} <strong class="text-uppercase">{{datas.nama_satuan_kecil}}</strong>
                  </td>
                  <td>
                    {{qtyInputBesar[datas.id_barang]}} <strong class="text-uppercase">{{datas.nama_satuan_besar}}</strong>
                  </td>
                  <td>{{datas.fraction}}</td>
                  <td>
                    <!-- <select class="form-control" v-model="form.id_gudang[datas.id_barang]">
                      <option v-for="(data, idx) in getGudang" :value="data.value" :key="idx" :selected= "data.value === 1">
                        {{data.text}} - {{idx}}
                      </option>
                    </select> -->
                    <model-select :options="getGudang"
                              v-model="form.id_gudang[datas.id_barang]"
                              placeholder="Pilih Gudang"
                              >
                    </model-select>
                  </td>
                </tr>
              </tbody>
            </table>
                <div class="form-group">
                  <router-link class="btn btn-danger" to="/penerimaan_barang">Kembali</router-link>
                  <button class="btn btn-primary" v-if="ListData.length > 0">Posting</button>
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
      getGudang: [],
      form:{
        no_penerimaan: '',
        no_purchase_order: '',
        no_spk: '',
        tanggal: moment(new Date()).format('YYYY-M-D'),
        status_posting: '1',
        id_vendor: '',
        id_gudang: [],
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
        id_barang_db: []
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
  // props: {
  //   id_gudang: {
  //     type: Object,
  //     default: () => { return { value: '1' } }
  //   }
  // },
  created() {
    this.loadDataPenerimaan();
  },
  updated(){
      $('a.vsm--link.active').attr('class', 'router-link-exact-active ryan active vsm--link vsm--link_level-1 vsm--link_active vsm--link_exact-active')
  },
  mounted() {
    $('a.vsm--link.active').attr('class', 'router-link-exact-active active vsm--link vsm--link_level-1 vsm--link_active vsm--link_exact-active')
 },
  methods: {
    addData() {
      var gudang = this.form.id_gudang.filter(function (el) {
        return el != null && el != "";
      });
      
      if(gudang.length < this.ListData.length)
      {
        this.$swal('Maaf', 'Gudang belum terisi semua.', 'error');
      }else{
        var data = {}
        $.each(this.ListData, function(k,v){
          data[k] = {"id_barang": v.id_barang, "qty": v.qty_kecil, "id_gudang":gudang[k]}
        });

        // post data ke api menggunakan axios
        this.loading = true
        axios.post("penerimaan_barang/updateStok", {
              no_penerimaan:this.$route.params.id,
              list_data:data,
              status:'penerimaan'
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
    loadDataPenerimaan() {
      this.loading = true
      // load data berdasarkan id
      axios.get("penerimaan_barang/" + this.$route.params.id +"/update")
        .then(response => {
            // form main
            this.form.no_penerimaan = response.data.data.no_penerimaan
            this.form.no_purchase_order = response.data.data.no_purchase_order
            this.form.no_spk = response.data.data.no_spk
            this.form.tanggal = this.$moment(response.data.data.tgl_penerimaan).locale('id').format('dddd, LL')//moment(response.data.data.tgl_penerimaan).format('MMM Do YYYY')//response.data.data.tgl_penerimaan
            this.form.status_posting = response.data.data.status_posting
            this.form.id_vendor = response.data.data.nama_vendor
            this.getGudang = response.data.gudang;
            console.log(response.data)

            //form detail
            this.ListData = response.data.detail;
            var inputKecil = Array();
            var inputBesar = Array();
            var fraction = Array();
            var idBrgDB = Array();
            var listItem = this.listItem;

            $.each(response.data.qty, function(k,v){
              inputKecil[k] =  v;
              inputBesar[k] =  Math.ceil(parseInt(v)/ parseInt(response.data.id_barang[k]));
              fraction[k] =  response.data.id_barang[k];
              //validasi utk hapus ke db 
              idBrgDB[k] = k;
              //validasi jika item sudah di tambahakan kedalam list 
              listItem.push(k);
            });

            this.id_barang_db = idBrgDB;
            this.qtyInputKecil = inputKecil;
            this.qtyInputBesar = inputBesar;
            this.form.fraction = fraction;

        }).catch(errors => {
              if (errors.response) {
                  this.$swal({
                      title: "Opps",
                      text: "Data tidak tersedia atau telah diposting",
                      type: "error"
                  }).then(function() {
                      window.location = "/penerimaan_barang";
                  });
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


  },
}
</script>