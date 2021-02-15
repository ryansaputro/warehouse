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

                </vue-bootstrap4-table>
                
                <vue-bootstrap4-table 
                    :rows="rows" 
                    :columns="columns" 
                    :config="config"
                    v-else>

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
            filter: '',
            rows: [],
            columns: [
                {
                    label: "Kode Item",
                    name: "kode_barang",
                    sort: true,
                },
                {
                    label: "Nama Item",
                    name: "nama_barang",
                    sort: true,
                },
                {
                    label: "Stok",
                    name: "stok",
                    sort: true,
                },
                {
                    label: "Satuan",
                    name: "nama_satuan",
                    sort: true,
                },
                {
                    label: "Lokasi",
                    name: "nama_lokasi",
                    sort: true,
                },
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
                        showClearButton: true,
                        searchOnPressEnter: false,
                        searchDebounceRate: 500,
                    },
                    show_refresh_button: false, 
                    show_reset_button: false, 
                per_page_options: [5, 10, 20, 30],
            },
            actions: [
                {
                    btn_text: "Filter",
                    event_name: "on-newdata",
                    class: "btn btn-primary dropdown",
                    event_payload: {
                        msg: "my custom msg"
                    }
                }
            ],

        }
    },
    methods: {
        newData(payload) {
            try {
                const { value: fruit } = this.$swal.fire({
                    title: 'Group data sesuai dengan',
                    input: 'select',
                    inputOptions: {
                        gudang: 'Gudang',
                        item: 'Item',
                    },
                    inputPlaceholder: 'Pilih group',
                    showCancelButton: true,
                    inputValidator: (value) => {
                        return new Promise((resolve) => {
                        this.filter = value;
                        this.getProjects(value);
                            resolve()
                        })
                    }
                    })

                    if (fruit) {
                    this.$swal.fire(`You selected: ${fruit}`)
                    }
                } catch (error) {
                    console.log("error")
                }
        },
        getProjects(filterBy) {
            this.loading = true
            axios.get('GetInfoStok',{params:{filter:filterBy}})
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
    },
    updated() {
        this.filter = this.filter == '' ? 'none' : this.filter;
        $('.card-header').html('<strong class="text-uppercase">Filter By : '+this.filter+'</strong>')
    },
    // watch : {
    //     totalStok:function(val) {
    //         console.log(this.rows);
    //     },

    // }
};
</script>