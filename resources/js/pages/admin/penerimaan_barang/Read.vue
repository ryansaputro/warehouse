<template>
    <div class="projects">
        <div class="loader" v-if="loading"></div>
          <div>
                <vue-bootstrap4-table 
                    :rows="rows" 
                    :columns="columns" 
                    :config="config"
                    :actions="actions"
                    @on-newdata="newData">

                    <template slot="status-slot" slot-scope="props">
                        <span class="badge badge-success" v-if="props.row.status_posting == '1'">Aktif</span>
                        <span class="badge badge-danger" v-else>Tidak Aktif</span>
                    </template>
                    <template slot="action-slot" slot-scope="props">
                        <button type="button" class="btn btn-primary btn-sm" v-if="props.row.status_posting == '1'" @click="onEdit(props.row)">Edit</button>
                        <button type="button" class="btn btn-secondary  btn-sm" v-else @click="onNoEdit(props.row)">Edit</button>

                        <!-- <button type="button" class="btn btn-danger btn-sm" @click="onDelete(props.row)">Delete</button> -->
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
            console.log(row);
        },
        onEdit(row) {
            this.$router.push("/penerimaan_barang/"+row.no_penerimaan+"/edit");
            console.log(row);
        },
        onDelete(row) {
            alert("on delete clicked");
            console.log(row);
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
                    console.log(this.rows)
                })
                .catch(errors => {
                    console.log(errors);
                }).finally(() => {
                    this.loading =  false
                });
        },
        deleteData(id) {
        // delete data
        this.loading = true
          axios.delete("data-kehadiran/" + id).then(response => {
            this.getProjects();
            // $swal function calls SweetAlert into the application with the specified configuration.
            this.$swal('Deleted', 'You successfully deleted this file', 'success');
          }).finally(() => {
            this.loading =  false
          });
        },

    },
    computed: {
    }
};
</script>