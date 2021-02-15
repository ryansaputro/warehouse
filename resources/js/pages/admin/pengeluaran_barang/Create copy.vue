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
              <model-select :options="getGudang"
                              v-model="form.id_unit_pengirim"
                              placeholder="Pilih Unit Pengirim"
                              >
              </model-select>
            </div>
            <div class="form-group">
              <label>Unit Penerima</label>
              <model-select :options="getUnit"
                              v-model="form.id_unit_penerima"
                              placeholder="Pilih Unit Penerima"
                              >
              </model-select>
            </div>
          </div>
          <div class="col-md-12">
            <div class="form-group">
              <router-link class="btn btn-danger" to="/pengeluaran_barang">Kembali</router-link>
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
import { ModelSelect, BasicSelect  } from 'vue-search-select'
//you need to import the CSS manually (in case you want to override it)
export default {
  components: {DatePicker, ModelSelect, BasicSelect  },
  data(){
    return{
      options: [],
      getUnit: [],
      getGudang: [],
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
  },
  updated(){
      $('a.vsm--link.active').attr('class', 'router-link-exact-active ryan active vsm--link vsm--link_level-1 vsm--link_active vsm--link_exact-active')
  },
  mounted() {
      this.$refs.datePicker.currentValue = [new Date()];
      $('a.vsm--link.active').attr('class', 'router-link-exact-active active vsm--link vsm--link_level-1 vsm--link_active vsm--link_exact-active')
 },
  methods: {
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

            })
            .catch(errors => {
                console.log(errors);
            }).finally(() => {
                this.loading =  false
            });
    },

  },
  computed: {
  },
  watch : {
  }
};
</script>