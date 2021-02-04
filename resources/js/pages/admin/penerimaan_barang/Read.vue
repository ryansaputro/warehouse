<template>
    <div class="projects">
        <div class="loader" v-if="loading"></div>
          <div>
                <vue-bootstrap4-table 
                    :rows="rows" 
                    :columns="columns" 
                    :config="config"
                    :actions="actions"
                    v-if="$can('read-divisi')"
                    @on-newdata="newData">

                    <template slot="status-slot" slot-scope="props">
                        <span class="badge badge-success" v-if="props.row.status_posting == '1'">Belum diposting</span>
                        <span class="badge badge-danger" v-else>Telah diposting</span>
                    </template>
                    <template slot="action-slot" slot-scope="props" v-if="$can('edit-divisi')">
                        <button type="button" class="btn btn-primary btn-sm" v-if="props.row.status_posting == '1'" @click="onEdit(props.row)"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> Edit</button>
                        <button type="button" class="btn btn-secondary  btn-sm" v-else @click="onNoEdit(props.row)"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> Edit</button>
                        <button type="button" class="btn btn-danger btn-sm" v-if="props.row.status_posting == '1'" @click="onDelete(props.row)"><i class="fa fa-trash" aria-hidden="true"></i> Hapus</button>
                        <button type="button" class="btn btn-info btn-sm" v-if="props.row.status_posting == '1'" @click="onPosting(props.row)" v-tooltip="'Posting dapat dilakukan jika tag pada item sudah terisi semua.'"><i class="fa fa-send" aria-hidden="true"></i> Posting</button>
                    </template>
                </vue-bootstrap4-table>
                <!--   -->
                <vue-bootstrap4-table 
                    :rows="rows" 
                    :columns="columns" 
                    :config="config"
                    v-else>
                    <template slot="status-slot" slot-scope="props">
                        <span class="badge badge-success" v-if="props.row.status_posting == '1'">Belum diposting</span>
                        <span class="badge badge-danger" v-else>Telah diposting</span>
                    </template>
                    <template slot="action-slot" slot-scope="props" v-if="$can('edit-divisi')">
                        <button type="button" class="btn btn-primary btn-sm" v-if="props.row.status_posting == '1'" @click="onEdit(props.row)"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> Edit</button>
                        <button type="button" class="btn btn-secondary  btn-sm" v-else @click="onNoEdit(props.row)"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> Edit</button>
                        <button type="button" class="btn btn-danger btn-sm" v-if="props.row.status_posting == '1'" @click="onDelete(props.row)"><i class="fa fa-trash" aria-hidden="true"></i> Hapus</button>
                        <button type="button" class="btn btn-info btn-sm" v-if="props.row.status_posting == '1'" @click="onPosting(props.row)" v-tooltip="'Posting dapat dilakukan jika tag pada item sudah terisi semua.'"><i class="fa fa-send" aria-hidden="true"></i> Posting</button>
                    </template>
                </vue-bootstrap4-table>
          </div>
    </div>
</template>

<script>
import Datatable from '../../../components/Datatables.vue';
import Pagination from '../../../components/Pagination.vue';
import DatePicker from 'vue2-datepicker';
import VueBootstrap4Table from 'vue-bootstrap4-table'
import 'vue2-datepicker/index.css';

export default {
    components: { datatable: Datatable, pagination: Pagination , DatePicker, VueBootstrap4Table},
    created() {
        this.getProjects();
    },
    data() {
        return {
            loading: false,
            rows: [],
            columns: [
                {
                    label: "Tanggal",
                    name: "created_at",
                    sort: true,
                },
                {
                    label: "No Penerimaan",
                    name: "no_penerimaan",
                    sort: true,
                },
                {
                    label: "Vendor",
                    name: "nama_vendor",
                    sort: true,
                },
                {
                    label: "Status Posting",
                    name: "status_posting",
                    slot_name: "status-slot"
                },
                {
                    label: "Aksi",
                    name: "aksi",
                    slot_name: "action-slot"
                }
                ],
            config: {
                loaderText: 'Mohon tunggu...',
                //  server_mode: true, //
                 card_mode: true,
                 selected_rows_info:true,
                 global_search: {
                        placeholder: "Pencarian...",
                        visibility: true,
                        case_sensitive: false,
                        showClearButton: false,
                        searchOnPressEnter: false,
                        searchDebounceRate: 500,
                        init: {
                            value : moment(new Date()).format('YYYY-MM-DD')
                        }                        
                    },
                    show_refresh_button: false, 
                    show_reset_button: false, 
            },
            actions: [
                {
                    btn_text: "Tambah Baru",
                    event_name: "on-newdata",
                    class: "btn btn-primary my-custom-class",
                    event_payload: {
                        msg: "my custom msg"
                    }
                }
            ],

        }
    },
    methods: {
        onNoEdit(row) {
            this.$swal('Maaf', 'Tidak dapat meng-edit <br>No Penerimaan: <b>'+row.no_penerimaan+'</b> dikarenakan telah diposting', 'error');
        },
        onEdit(row) {
            this.$router.push("/penerimaan_barang/"+row.no_penerimaan+"/edit");
        },
        onDelete(row) {
            axios.post("penerimaan_barang/deletePenerimaan", {
              no_penerimaan: row.no_penerimaan,  
            })
            .then(response => {
                this.getProjects();
                // push router ke read data
                this.$swal('Berhasil', 'Penerimaan Barang berhasil dihapus', 'success');
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

        onPosting(row) {
            axios.post("penerimaan_barang/cekposting", {
              no_penerimaan: row.no_penerimaan,  
            })
            .then(response => {
                if(response.data.status == 200){
                    this.$router.push("/penerimaan_barang/"+row.no_penerimaan+"/posting");
                }else{
                    this.$swal({
                      title: "Opps",
                      text: "Data tidak tersedia atau telah diposting",
                      type: "error"
                    }).then(function() {
                        window.location = "/penerimaan_barang";
                    });
                }
            })
            .catch(errors => {
                // this.$swal('Failed', 'You failed Created this file', 'error');
                if (errors.response) {
                    this.$swal({
                      title: "Opps",
                      text: "Maaf data item belum lengkap silahkan cek data tag pada item",
                      type: "error"
                    }).then(function() {
                        this.getProjects();
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
        doMath: function (index) {
            return index+1
        },
        newData(payload) {
                this.$router.push("/penerimaan_barang/create");
        },
        getProjects() {
            this.loading = true
            axios.get('penerimaan_barang/index')
                .then(response => {
                    this.rows = response.data.data;
                })
                .catch(errors => {
                    console.log(errors);
                }).finally(() => {
                    this.loading =  false
                });
        },

    },
    computed: {
    }
};
</script>