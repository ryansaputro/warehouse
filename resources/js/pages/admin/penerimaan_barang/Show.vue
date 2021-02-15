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
              <td>{{form.no_penerimaan}}</td>
              <th>Tanggal</th>
              <th>:</th>
              <td>{{form.tanggal}}</td>
            </tr>
            <tr>
              <th>Nomor Purchase Order</th>
              <th>:</th>
              <td>{{form.no_purchase_order}}</td>
              <th>Vendor</th>
              <th>:</th>
              <td>{{form.nama_vendor}}</td>
            </tr>
            <tr>
              <th>Nomor Spk</th>
              <th>:</th>
              <td>{{form.no_spk}}</td>
              <th>Status Posting</th>
              <th>:</th>
              <td>{{form.status_posting == 1 ? 'belum diposting' : 'telah diposting'}}</td>
            </tr>
          </table>
          <table class="table table-striped">
            <thead>
                <tr>
                  <th>Barang</th>
                  <th>Satuan Kecil</th>
                  <th>Satuan Besar</th>
                  <th>Fraction</th>
                  <th>List Tag</th>
                </tr>
              </thead>
              <tbody v-if="detail.length > 0">
                <tr v-for="(data, index) in detail" :key="index">
                  <td>{{data.nama_barang}}</td>
                  <td>{{data.qty_kecil}} {{data.nama_satuan_kecil}}</td>
                  <td>{{Math.ceil(parseInt(data.qty_kecil)/data.fraction)}} {{data.nama_satuan_besar}}</td>
                  <td>{{data.fraction}}</td>
                  <td><button type="button" class="btn btn-primary btn-sm" @click="checkListTag(data.id, data.id_barang)">list tag</button></td>
                </tr>
              </tbody>
              <tbody v-else>
                <tr>
                  <td colspan="5" class="text-center">Data tidak tersedia</td>
                </tr>
              </tbody>
          </table>
          <div class="col-md-12">
            <div class="form-group">
              <router-link class="btn btn-danger" to="/penerimaan_barang">Kembali</router-link>
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
      detail: [],
      getUnit: [],
      form:{
        tanggal: moment(new Date()).format('YYYY-M-D'),
        status_posting: '1',
        no_pengeluaran: '',
        id_unit_pengirim: '',
        id_unit_penerima: '',
      },
      loading: false,
      waterMark : new Date().toISOString().slice(0,10),
    }
  },
  created() {
    this.getMaster();
    this.loadData();
  },
  updated(){
      $('a.vsm--link.active').attr('class', 'router-link-exact-active ryan active vsm--link vsm--link_level-1 vsm--link_active vsm--link_exact-active')
  },
  mounted() {
      $('a.vsm--link.active').attr('class', 'router-link-exact-active active vsm--link vsm--link_level-1 vsm--link_active vsm--link_exact-active')
 },
  methods: {
    checkListTag(id_detail_penerimaan, id_barang) {
        // post data ke api menggunakan axios
        this.loading = true
        axios
          .post("penerimaan_barang/cekTagByItem", {
              id_detail_penerimaan: id_detail_penerimaan,  
              id_barang: id_barang,  
          })
          .then(response => {            
            var tbody = "";
            $.each(response.data.data, function(k,v){
              tbody += "<tr><td>"+(k+1)+"</td><td>"+v.nama_barang+"</td>"
              tbody += "<td>"+v.epc_tag+"</td></tr>"
            });

              this.$swal.fire({
                title: 'List Tag',
                html: '<table class="table table-striped"><thead><tr><th>No</th><th>Item</th><th>Epc Tag</th></tr></thead><tbody>'+tbody+'</tbody></table>',
              });
          })
          .catch(errors => {
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
    addData() {
      if((this.form.no_penerimaan == '') || 
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
          .post("penerimaan_barang/"+ this.$route.params.id +"/update", {
              tanggal: this.form.tanggal,  
              id_unit_pengirim: this.form.id_unit_pengirim,  
              id_unit_penerima: this.form.id_unit_penerima,  
          })
          .then(response => {
            // push router ke read data
            this.$router.push("/penerimaan_barang");
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
                this.form.no_pengeluaran = response.data.format_pengeluaran;

            })
            .catch(errors => {
                console.log(errors);
            }).finally(() => {
                this.loading =  false
            });
    },
    loadData() {
      this.loading = true
      axios.get('penerimaan_barang/'+ this.$route.params.id +'/update')
            .then(response => {

              this.form.no_penerimaan = response.data.data.no_penerimaan;
              this.form.status_posting = response.data.data.status_posting;
              this.form.tanggal = response.data.data.tgl_penerimaan;
              this.form.nama_vendor = response.data.data.nama_vendor;
              this.form.no_purchase_order = response.data.data.no_purchase_order;
              this.form.no_spk = response.data.data.no_spk;
              this.detail = response.data.detail;
              

            })
            .catch(errors => {
                console.log(errors);
            }).finally(() => {
                this.loading =  false
            });
    }

  },
  computed: {
  },
  watch : {
  }
};
</script>